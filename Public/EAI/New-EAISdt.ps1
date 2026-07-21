<#
.SYNOPSIS
Creates a new Edwin scheduled downtime (SDT) entry.

.DESCRIPTION
New-EAISdt creates a maintenance window on the Edwin Action Service.
Use -ScheduleWizard for an interactive flow, or supply -Name, -Filter, and schedule parameters directly.

.PARAMETER Name
Display name for the schedule. Required in the Default parameter set; prompted when using -ScheduleWizard.

.PARAMETER Description
Optional description for the schedule.

.PARAMETER Filter
Filter condition object (hashtable or PSCustomObject) matching the Edwin filter schema.

.PARAMETER Enabled
When specified, creates the schedule enabled or disabled. Omit to create an enabled schedule.

.PARAMETER ScheduleWizard
Launches an interactive wizard to create the schedule.

.PARAMETER Duration
Duration in minutes for one-time SDTs. Use alone (starts now) or with -StartDate.

.PARAMETER StartDate
Start date and time. Required for one-time range; optional for one-time duration.

.PARAMETER EndDate
End date and time. Required for one-time range schedules.

.PARAMETER Timezone
IANA or Windows timezone identifier. Defaults to the local system timezone when omitted.

.PARAMETER SdtType
Recurring schedule type: Daily, Weekly, Monthly, or MonthlyByWeek.

.PARAMETER StartHour
Start hour (0-23) for recurring SDTs.

.PARAMETER StartMinute
Start minute (0-59) for recurring SDTs.

.PARAMETER EndHour
End hour (0-23) for recurring SDTs.

.PARAMETER EndMinute
End minute (0-59) for recurring SDTs.

.PARAMETER WeekDay
Day(s) of the week for Weekly or MonthlyByWeek SDTs.

.PARAMETER WeekOfMonth
Week of the month for MonthlyByWeek SDTs: First, Second, Third, Fourth, or Last.

.PARAMETER DayOfMonth
Day of the month for Monthly SDTs (1-31), or -3 for the last day of the month.

.PARAMETER PassThru
Re-fetches and returns the created schedule after a successful create.

.EXAMPLE
New-EAISdt -ScheduleWizard

.EXAMPLE
New-EAISdt -ScheduleWizard -Name "Maintenance" -Filter $filter

.EXAMPLE
New-EAISdt -Name "Weekly window" -Duration 60 -SdtType Weekly -WeekDay Monday -Filter $filter

.NOTES
Use Connect-EAIAccount to establish an Edwin session before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
None by default. With -PassThru, returns an Edwin.SDT object. Writes an informational success message when console logging is enabled.
#>
function New-EAISdt {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None', DefaultParameterSetName = 'Default')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the ScheduleWizard to work')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$Description,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Object]$Filter,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Switch]$Enabled,

        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Switch]$ScheduleWizard,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(1, [Int]::MaxValue)]
        [Int]$Duration,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Datetime]$StartDate,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Datetime]$EndDate,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateScript({ Test-LMTimezoneId -Timezone $_ })]
        [String]$Timezone,

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

    if (-not (Test-EAIAuth -CallerPSCmdlet $PSCmdlet)) {
        return
    }

    if ($ScheduleWizard) {
        $effectiveBound = Invoke-EAISdtCmdletWizard -BoundParameters $PSBoundParameters
        if (-not $effectiveBound) {
            return
        }
    }
    else {
        $effectiveBound = @{}
        foreach ($key in $PSBoundParameters.Keys) {
            $effectiveBound[$key] = $PSBoundParameters[$key]
        }
    }

    $payload = Build-EAISdtSchedulePayload -BoundParameters $effectiveBound
    $body = $payload | ConvertTo-Json -Depth 20 -Compress
    $headers = New-EAIHeader -Auth $Script:EAIAuth -Method 'POST'
    $uri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath '/action/sdt'
    $target = "Name: $($effectiveBound['Name'])"
    $enableDebugLogging = $DebugPreference -ne 'SilentlyContinue'

    Resolve-EAIDebugInfo -Url $uri -Headers $headers -Command $MyInvocation

    if ($PSCmdlet.ShouldProcess($target, 'Create Edwin SDT')) {
        $null = Invoke-EAIRestMethod -Uri $uri -Method POST -Headers $headers -Auth $Script:EAIAuth -Body $body `
            -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging

        if ($PassThru) {
            $created = Get-EAISdt | Where-Object { $_.name -eq $effectiveBound['Name'] } | Select-Object -Last 1
            if ($created) {
                return $created
            }
        }

        Write-Information "[INFO]: Successfully created Edwin SDT '$($effectiveBound['Name'])'."
    }
}
