<#
.SYNOPSIS
Updates an existing Edwin scheduled downtime (SDT) entry.

.DESCRIPTION
Set-EAISdt applies partial updates to an Edwin SDT schedule. Depending on the parameters supplied,
it may call one or more update endpoints (metadata, filter, recurrence).

Use Set-EAISdt -Enabled:$false to disable a schedule. There is no delete endpoint.

.PARAMETER Id
Schedule ID (UUID). Required in the Default parameter set unless piped; optional with -ScheduleWizard.
Accepts the scheduleId property from Edwin.SDT objects.

.PARAMETER ScheduleWizard
Launches an interactive wizard to select and update a schedule.

.PARAMETER Name
Updates the schedule name (metadata endpoint).

.PARAMETER Description
Updates the schedule description (metadata endpoint).

.PARAMETER Enabled
Enables or disables the schedule (metadata endpoint).

.PARAMETER Filter
Updates the filter condition (filter endpoint).

.PARAMETER SdtType
Updates recurrence pattern type: Daily, Weekly, Monthly, or MonthlyByWeek.

.PARAMETER StartHour
Start hour (0-23) for recurring recurrence updates.

.PARAMETER StartMinute
Start minute (0-59) for recurring recurrence updates.

.PARAMETER EndHour
End hour (0-23) for recurring recurrence updates.

.PARAMETER EndMinute
End minute (0-59) for recurring recurrence updates.

.PARAMETER WeekDay
Day(s) of the week for recurring recurrence updates.

.PARAMETER WeekOfMonth
Week of the month for MonthlyByWeek recurrence updates.

.PARAMETER DayOfMonth
Day of the month for Monthly recurrence updates.

.PARAMETER PassThru
Re-fetches and returns the updated schedule after all updates succeed.

.EXAMPLE
Set-EAISdt -ScheduleWizard

.EXAMPLE
Set-EAISdt -Id '6d18821f-8f3c-48ca-8331-3e4c8d77cac3' -Enabled:$false

.EXAMPLE
Get-EAISdt | Where-Object enabled -eq 'ENABLED' | Set-EAISdt -Enabled:$false

.EXAMPLE
Set-EAISdt -Id '6d18821f-8f3c-48ca-8331-3e4c8d77cac3' -SdtType Weekly -WeekDay Monday, Thursday `
    -StartHour 13 -StartMinute 0 -EndHour 14 -EndMinute 0

.NOTES
Use Connect-EAIAccount to establish an Edwin session before running this command.
startTime and duration cannot be changed after create.

.INPUTS
You can pipe Edwin.SDT objects (scheduleId), objects with an Id property, or schedule ID strings.

.OUTPUTS
None by default. With -PassThru, returns an Edwin.SDT object. Writes an informational success message when console logging is enabled.
#>
function Set-EAISdt {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None', DefaultParameterSetName = 'Default')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the ScheduleWizard to work')]
    param (
        [Parameter(ParameterSetName = 'Default', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName = 'ScheduleWizard', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('ScheduleId')]
        [String]$Id,

        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Switch]$ScheduleWizard,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$Description,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Switch]$Enabled,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Object]$Filter,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateSet('Daily', 'Weekly', 'Monthly', 'MonthlyByWeek')]
        [String]$SdtType,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 23)]
        [Int]$StartHour,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 59)]
        [Int]$StartMinute,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 23)]
        [Int]$EndHour,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 59)]
        [Int]$EndMinute,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateSet('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')]
        [String[]]$WeekDay,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateSet('First', 'Second', 'Third', 'Fourth', 'Last')]
        [String]$WeekOfMonth,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Int]$DayOfMonth,

        [Switch]$PassThru
    )

    begin {
        if (-not (Test-EAIAuth -CallerPSCmdlet $PSCmdlet)) {
            $script:SkipSetEAISdt = $true
            return
        }

        $script:SkipSetEAISdt = $false
    }

    process {
        if ($script:SkipSetEAISdt) {
            return
        }

        if ($ScheduleWizard -and $null -ne $_) {
            throw 'Set-EAISdt -ScheduleWizard cannot be used with pipeline input. Pipe schedules to Set-EAISdt with explicit update parameters instead.'
        }

        $effectiveBound = @{}
        foreach ($key in $PSBoundParameters.Keys) {
            if ($key -ne 'Id') {
                $effectiveBound[$key] = $PSBoundParameters[$key]
            }
        }

        if ($ScheduleWizard) {
            if (-not $effectiveBound.ContainsKey('Id') -and -not [string]::IsNullOrWhiteSpace($Id)) {
                $effectiveBound['Id'] = $Id
            }

            $effectiveBound = Invoke-EAISdtUpdateWizard -BoundParameters $effectiveBound
            if (-not $effectiveBound) {
                return
            }

            $Id = $effectiveBound['Id']
        }
        else {
            if ([string]::IsNullOrWhiteSpace($Id)) {
                throw 'Id is required.'
            }

            $effectiveBound['Id'] = $Id
        }

        foreach ($blockedKey in @('Duration', 'StartDate', 'EndDate', 'Timezone')) {
            if ($effectiveBound.ContainsKey($blockedKey)) {
                throw "Cannot update -$blockedKey on an existing schedule. Edwin only supports metadata, filter, and recurrence updates after create."
            }
        }

        $metadataKeys = @('Name', 'Description', 'Enabled')
        $scheduleKeys = @(
            'SdtType', 'StartHour', 'StartMinute', 'EndHour', 'EndMinute',
            'WeekDay', 'WeekOfMonth', 'DayOfMonth'
        )

        $hasMetadataUpdate = $false
        foreach ($key in $metadataKeys) {
            if ($effectiveBound.ContainsKey($key)) {
                $hasMetadataUpdate = $true
                break
            }
        }

        $hasFilterUpdate = $effectiveBound.ContainsKey('Filter')
        $hasRecurrenceUpdate = $false
        foreach ($key in $scheduleKeys) {
            if ($effectiveBound.ContainsKey($key)) {
                $hasRecurrenceUpdate = $true
                break
            }
        }

        if (-not $hasMetadataUpdate -and -not $hasFilterUpdate -and -not $hasRecurrenceUpdate) {
            throw 'No update parameters were specified. Provide metadata (-Name, -Description, -Enabled), -Filter, or recurrence schedule parameters.'
        }

        $existingSchedule = $null
        if ($hasMetadataUpdate -or $hasRecurrenceUpdate) {
            if ($null -ne $_ -and (Test-EAISdtScheduleSnapshot -InputObject $_)) {
                $existingSchedule = $_
            }
            else {
                $existingSchedule = Get-EAISdt -Id $Id
            }
        }

        $headers = New-EAIHeader -Auth $Script:EAIAuth -Method 'POST'
        $enableDebugLogging = $DebugPreference -ne 'SilentlyContinue'
        $scheduleLabel = if ($null -ne $existingSchedule -and $existingSchedule.PSObject.Properties['name']) {
            [string]$existingSchedule.name
        }
        elseif ($null -ne $_ -and $_.PSObject.Properties['name']) {
            [string]$_.name
        }
        else {
            $Id
        }
        $target = "Id: $Id | Name: $scheduleLabel"

        if ($PSCmdlet.ShouldProcess($target, 'Update Edwin SDT')) {
            $updatedSections = [System.Collections.Generic.List[string]]::new()

            if ($hasMetadataUpdate) {
                $metadataPayload = Build-EAISdtMetadataUpdatePayload -BoundParameters $effectiveBound `
                    -ExistingSchedule $existingSchedule
                $metadataBody = $metadataPayload | ConvertTo-Json -Depth 10 -Compress
                $metadataUri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath "/action/sdt/$Id/update/metadata"

                Resolve-EAIDebugInfo -Url $metadataUri -Headers $headers -Command $MyInvocation -Payload $metadataBody

                $null = Invoke-EAIRestMethod -Uri $metadataUri -Method POST -Headers $headers -Auth $Script:EAIAuth `
                    -Body $metadataBody -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging
                $updatedSections.Add('metadata') | Out-Null
            }

            if ($hasFilterUpdate) {
                $filterPayload = Build-EAISdtFilterUpdatePayload -BoundParameters $effectiveBound
                $filterBody = $filterPayload | ConvertTo-Json -Depth 20 -Compress
                $filterUri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath "/action/sdt/$Id/update/filter"

                Resolve-EAIDebugInfo -Url $filterUri -Headers $headers -Command $MyInvocation -Payload $filterBody

                $null = Invoke-EAIRestMethod -Uri $filterUri -Method POST -Headers $headers -Auth $Script:EAIAuth `
                    -Body $filterBody -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging
                $updatedSections.Add('filter') | Out-Null
            }

            if ($hasRecurrenceUpdate) {
                $recurrencePayload = Build-EAISdtRecurrenceUpdatePayload -BoundParameters $effectiveBound -ExistingSchedule $existingSchedule
                $recurrenceBody = $recurrencePayload | ConvertTo-Json -Depth 20 -Compress
                $recurrenceUri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath "/action/sdt/$Id/update/recurrence"

                Resolve-EAIDebugInfo -Url $recurrenceUri -Headers $headers -Command $MyInvocation -Payload $recurrenceBody

                $null = Invoke-EAIRestMethod -Uri $recurrenceUri -Method POST -Headers $headers -Auth $Script:EAIAuth `
                    -Body $recurrenceBody -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging
                $updatedSections.Add('recurrence') | Out-Null
            }

            if ($PassThru) {
                return Get-EAISdt -Id $Id
            }

            $updateSummary = $updatedSections -join ', '
            Write-Information "[INFO]: Successfully updated Edwin SDT '$scheduleLabel' (Id: $Id) [$updateSummary]."
        }
    }
}
