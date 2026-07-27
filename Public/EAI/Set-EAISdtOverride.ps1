<#
.SYNOPSIS
Replaces all overrides on an Edwin SDT schedule.

.DESCRIPTION
Set-EAISdtOverride replaces the entire overrides list on a schedule. Prefer New-EAISdtOverride and
Remove-EAISdtOverride for single-instance changes.

.PARAMETER ScheduleId
Schedule ID (UUID).

.PARAMETER Override
One or more override objects to store on the schedule. Use with an empty array (@()) or -Clear to
remove all overrides.

.PARAMETER Clear
Removes all overrides from the schedule.

.PARAMETER PassThru
Re-fetches and returns the updated schedule.

.EXAMPLE
Set-EAISdtOverride -ScheduleId $id -Clear

.EXAMPLE
Set-EAISdtOverride -ScheduleId $id -Override @()

.EXAMPLE
# Replace with a single skip override
Set-EAISdtOverride -ScheduleId $id -Override @(
    @{
        originalInstanceId = @{
            scheduleId = $id
            startTime  = '2026-07-21T16:00:00.000Z'
        }
        status  = 'SKIPPED'
        summary = 'bulk skip'
    }
)

.NOTES
Use Connect-EAIAccount before running this command.
This cmdlet calls PUT /action/sdt/{scheduleId}/override and replaces all existing overrides.
Use -Clear or -Override @() to clear every override when the UI cannot delete orphaned entries.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
None by default. With -PassThru, returns an Edwin.SDT object. Writes an informational success message when console logging is enabled.
#>
function Set-EAISdtOverride {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None', DefaultParameterSetName = 'Replace')]
    param (
        [Parameter(Mandatory)]
        [Alias('Id')]
        [String]$ScheduleId,

        [Parameter(Mandatory, ParameterSetName = 'Replace')]
        [AllowEmptyCollection()]
        [Object[]]$Override,

        [Parameter(Mandatory, ParameterSetName = 'Clear')]
        [Switch]$Clear,

        [Switch]$PassThru
    )

    if (-not (Test-EAIAuth -CallerPSCmdlet $PSCmdlet)) {
        return
    }

    $overrideInput = if ($PSCmdlet.ParameterSetName -eq 'Clear') {
        @()
    }
    elseif ($PSBoundParameters.ContainsKey('Override')) {
        if ($null -eq $Override) { @() } else { @($Override) }
    }
    else {
        @()
    }

    $normalizedOverrides = if ($overrideInput.Count -eq 0) {
        @()
    }
    else {
        ConvertTo-EAISdtOverrideRequestBody -Override $overrideInput
    }
    $body = if ($normalizedOverrides.Count -eq 0) {
        '[]'
    }
    else {
        $normalizedOverrides | ConvertTo-Json -Depth 10 -Compress
    }
    $headers = New-EAIHeader -Auth $Script:EAIAuth -Method 'PUT'
    $uri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath "/action/sdt/$ScheduleId/override"
    $target = "ScheduleId: $ScheduleId | Overrides: $($normalizedOverrides.Count)"
    $enableDebugLogging = $DebugPreference -ne 'SilentlyContinue'

    if ($PSCmdlet.ShouldProcess($target, 'Replace Edwin SDT overrides')) {
        Resolve-EAIDebugInfo -Url $uri -Headers $headers -Command $MyInvocation -Payload $body

        $null = Invoke-EAIRestMethod -Uri $uri -Method PUT -Headers $headers -Auth $Script:EAIAuth `
            -Body $body -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging

        if ($PassThru) {
            return Get-EAISdt -Id $ScheduleId
        }

        Write-Information "[INFO]: Successfully replaced overrides on Edwin SDT schedule $ScheduleId ($($normalizedOverrides.Count) override(s))."
    }
}
