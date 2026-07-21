<#
.SYNOPSIS
Retrieves calculated or realised Edwin SDT instances.

.DESCRIPTION
Get-EAISdtInstance lists downtime instances for a schedule within a time range, or retrieves a
single instance by ID.

.PARAMETER ScheduleId
Schedule ID (UUID). Required for the BySchedule parameter set unless piping an Edwin.SDT object.

.PARAMETER StartTime
Inclusive range start. Defaults to the current UTC time when omitted.

.PARAMETER EndTime
Exclusive range end. Defaults to seven days after StartTime when omitted.

.PARAMETER InstanceId
Instance ID in the format scheduleId:isoStartTime.

.EXAMPLE
Get-EAISdtInstance -ScheduleId '97038d1b-648a-4718-b287-33726ed49624'

.EXAMPLE
Get-EAISdt -Id $id | Get-EAISdtInstance

.EXAMPLE
$instances = Get-EAISdt -Id $id | Get-EAISdtInstance -EndTime (Get-Date).ToUniversalTime().AddDays(30)
$instances | Format-Table instanceId, startTime, endTime, status

.EXAMPLE
Get-EAISdtInstance -InstanceId '97038d1b-648a-4718-b287-33726ed49624:2026-07-22T16:00:00.000Z'

.NOTES
Use Connect-EAIAccount before running this command.
Use instance.originalInstanceId.startTime (not the top-level startTime) when creating overrides.
The instanceId property is formatted as scheduleId:isoStartTime for use with Remove-EAISdtOverride.

.INPUTS
You can pipe Edwin.SDT objects (scheduleId), objects with an Id property, or schedule ID strings.

.OUTPUTS
Returns Edwin.SDT.Instance objects.
#>
function Get-EAISdtInstance {
    [CmdletBinding(DefaultParameterSetName = 'BySchedule')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'BySchedule', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [String]$ScheduleId,

        [Parameter(ParameterSetName = 'BySchedule')]
        [Datetime]$StartTime,

        [Parameter(ParameterSetName = 'BySchedule')]
        [Datetime]$EndTime,

        [Parameter(Mandatory, ParameterSetName = 'ByInstanceId')]
        [String]$InstanceId
    )

    begin {
        if (-not (Test-EAIAuth -CallerPSCmdlet $PSCmdlet)) {
            $script:SkipGetEAISdtInstance = $true
            return
        }

        $script:SkipGetEAISdtInstance = $false
        $script:GetEAISdtInstanceHeaders = New-EAIHeader -Auth $Script:EAIAuth -Method 'GET'
        $script:GetEAISdtInstanceEnableDebugLogging = $DebugPreference -ne 'SilentlyContinue'
    }

    process {
        if ($script:SkipGetEAISdtInstance) {
            return
        }

        if ($PSCmdlet.ParameterSetName -eq 'ByInstanceId') {
            $encodedInstanceId = [System.Uri]::EscapeDataString($InstanceId)
            $resourcePath = "/action/sdt/instance/$encodedInstanceId"
            $uri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath $resourcePath

            Resolve-EAIDebugInfo -Url $uri -Headers $script:GetEAISdtInstanceHeaders -Command $MyInvocation

            $response = Invoke-EAIRestMethod -Uri $uri -Method GET -Headers $script:GetEAISdtInstanceHeaders `
                -Auth $Script:EAIAuth -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$script:GetEAISdtInstanceEnableDebugLogging

            if ($null -eq $response) {
                return
            }

            $normalized = ConvertTo-EAISdtInstanceObject -InputObject $response
            return Add-ObjectTypeInfo -InputObject $normalized -TypeName 'Edwin.SDT.Instance'
        }

        if ([string]::IsNullOrWhiteSpace($ScheduleId)) {
            throw 'ScheduleId is required. Pipe an Edwin.SDT object or specify -ScheduleId.'
        }

        $effectiveStart = if ($PSBoundParameters.ContainsKey('StartTime')) {
            $StartTime.ToUniversalTime()
        }
        else {
            (Get-Date).ToUniversalTime()
        }

        $effectiveEnd = if ($PSBoundParameters.ContainsKey('EndTime')) {
            $EndTime.ToUniversalTime()
        }
        else {
            $effectiveStart.AddDays(7)
        }

        if ($effectiveEnd -le $effectiveStart) {
            throw 'EndTime must be after StartTime.'
        }

        $startQuery = [System.Uri]::EscapeDataString((ConvertTo-EAISdtApiInstant -DateTime $effectiveStart))
        $endQuery = [System.Uri]::EscapeDataString((ConvertTo-EAISdtApiInstant -DateTime $effectiveEnd))
        $resourcePath = "/action/sdt/$ScheduleId/instance?startTime=$startQuery&endTime=$endQuery"
        $uri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath $resourcePath

        Resolve-EAIDebugInfo -Url $uri -Headers $script:GetEAISdtInstanceHeaders -Command $MyInvocation

        $response = Invoke-EAIRestMethod -Uri $uri -Method GET -Headers $script:GetEAISdtInstanceHeaders `
            -Auth $Script:EAIAuth -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$script:GetEAISdtInstanceEnableDebugLogging

        $instances = if ($null -eq $response) {
            @()
        }
        else {
            @($response | ForEach-Object { ConvertTo-EAISdtInstanceObject -InputObject $_ })
        }

        if ($instances.Count -eq 0) {
            Write-Output @() -NoEnumerate
            return
        }

        return Add-ObjectTypeInfo -InputObject $instances -TypeName 'Edwin.SDT.Instance'
    }
}
