<#
.SYNOPSIS
Removes an Edwin SDT instance override.

.DESCRIPTION
Remove-EAISdtOverride deletes an override and restores the calculated instance behavior.

The DELETE path uses the canonical original instance identity (`scheduleId:isoStartTime`), not
the rescheduled newStartTime. Pipe objects from Get-EAISdtInstance or from a schedule's
overrides array returned by Get-EAISdt.

.PARAMETER InputObject
An Edwin.SDT.Instance, a schedule override object from Get-EAISdt, or any object with
instanceId or originalInstanceId properties.

.PARAMETER InstanceId
Instance ID in the format scheduleId:isoStartTime.

.EXAMPLE
Remove-EAISdtOverride -InstanceId '97038d1b-648a-4718-b287-33726ed49624:2026-07-22T16:00:00.000Z'

.EXAMPLE
Get-EAISdtInstance -ScheduleId $id | Where-Object { $_.instanceId -like '*2026-07-22T16:00:00.000Z*' } |
    Remove-EAISdtOverride

.EXAMPLE
# Remove one stored override (originalInstanceId.startTime may be epoch seconds from the API)
(Get-EAISdt -Id $id).overrides | Select-Object -First 1 | Remove-EAISdtOverride

.EXAMPLE
# Preview removals before deleting orphaned overrides
(Get-EAISdt -Id $id).overrides | Remove-EAISdtOverride -WhatIf

.NOTES
Use Connect-EAIAccount before running this command.
To remove all overrides at once, use Set-EAISdtOverride -ScheduleId $id -Override @().

.INPUTS
You can pipe Edwin.SDT.Instance objects, override objects from Get-EAISdt, or instance ID strings.

.OUTPUTS
None.
#>
function Remove-EAISdtOverride {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject,

        [Parameter(ValueFromPipelineByPropertyName)]
        [String]$InstanceId
    )

    begin {
        if (-not (Test-EAIAuth -CallerPSCmdlet $PSCmdlet)) {
            $script:SkipRemoveEAISdtOverride = $true
            return
        }

        $script:SkipRemoveEAISdtOverride = $false
    }

    process {
        if ($script:SkipRemoveEAISdtOverride) {
            return
        }

        $resolvedInstanceId = if ($null -ne $InputObject) {
            if ($InputObject.PSObject.Properties['instanceId'] -and $InputObject.instanceId -is [string]) {
                $InputObject.instanceId
            }
            elseif ($InputObject.PSObject.Properties['originalInstanceId']) {
                Format-EAISdtInstanceId -ScheduleId $InputObject.originalInstanceId.scheduleId `
                    -StartTime $InputObject.originalInstanceId.startTime
            }
            elseif ($InputObject.PSObject.Properties['instanceId']) {
                Format-EAISdtInstanceId -ScheduleId $InputObject.instanceId.scheduleId `
                    -StartTime $InputObject.instanceId.startTime
            }
            else {
                throw 'Piped input must include instanceId or originalInstanceId.'
            }
        }
        elseif (-not [string]::IsNullOrWhiteSpace($InstanceId)) {
            $InstanceId
        }
        else {
            throw 'InstanceId is required.'
        }

        $encodedInstanceId = [System.Uri]::EscapeDataString($resolvedInstanceId)
        $headers = New-EAIHeader -Auth $Script:EAIAuth -Method 'DELETE'
        $uri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath "/action/sdt/override/$encodedInstanceId"
        $enableDebugLogging = $DebugPreference -ne 'SilentlyContinue'

        if ($PSCmdlet.ShouldProcess($resolvedInstanceId, 'Remove Edwin SDT override')) {
            Resolve-EAIDebugInfo -Url $uri -Headers $headers -Command $MyInvocation

            $null = Invoke-EAIRestMethod -Uri $uri -Method DELETE -Headers $headers -Auth $Script:EAIAuth `
                -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging

            Write-Information "[INFO]: Successfully removed Edwin SDT override for instance $resolvedInstanceId."
        }
    }
}
