<#
.SYNOPSIS
Removes a LogicMonitor Service Insight, and by default its companion
aggregate "Health" DataSource.

.DESCRIPTION
Removes a Service Insight (a DeviceType 6 device) via Remove-LMDevice.
By default also finds and removes any DataSource whose appliesTo
targets this Service Insight specifically (system.deviceId ==
"<id>") — the companion DataSource New-LMServiceInsight creates — so
the two objects it creates together are also removed together. Use
-DataSourceAction Keep to leave any linked DataSource in place, or
-DataSourceAction Skip to skip looking for one entirely.

Finding the linked DataSource is scoped to DataSources associated with
this device (Get-LMDeviceDatasourceList), not a full-portal scan, then
narrowed to the one(s) whose appliesTo specifically references this
device's id — DataSources that merely happen to also apply broadly to
this device (e.g. a portal-wide DataSource) are left alone.

.PARAMETER Id
The ID of the Service Insight to remove. Mandatory.

.PARAMETER HardDelete
If set, permanently deletes the Service Insight device instead of
moving it to the Recycle Bin. Defaults to $false (soft delete), matching
Remove-LMDevice's own default.

.PARAMETER DataSourceAction
What to do about a linked "Health" DataSource (one whose appliesTo
targets this Service Insight's device id):
- Remove (default): find and remove it too.
- Keep: leave it in place (it will no longer collect anything
  meaningful once the Service Insight device is gone, but stays in the
  portal).
- Skip: don't look for one at all.

.EXAMPLE
Remove-LMServiceInsight -Id 129189

.EXAMPLE
#Permanently delete, leave any linked Health datasource alone
Remove-LMServiceInsight -Id 129189 -HardDelete $true -DataSourceAction Keep

.NOTES
You must run Connect-LMAccount before running this command.
See New-LMServiceInsight for creating one.

.INPUTS
You can pipe objects containing an Id property to this function.

.OUTPUTS
Returns a PSCustomObject with .Device and .Datasource removal results
(.Datasource is $null if none was found/removed).
#>
function Remove-LMServiceInsight {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [boolean]$HardDelete = $false,

        [ValidateSet('Remove', 'Keep', 'Skip')]
        [String]$DataSourceAction = 'Remove'
    )

    begin {}
    process {
        if (-not $Script:LMAuth.Valid) {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
            return
        }

        $device = Get-LMDevice -Id $Id
        if (-not $device) {
            Write-Error "No device found with Id $Id."
            return
        }
        if ($device.deviceType -ne 6) {
            Write-Error "Device $Id (displayName: $($device.displayName)) is not a Service Insight (deviceType $($device.deviceType), expected 6). Refusing to remove - use Remove-LMDevice directly if this is intentional."
            return
        }

        $linkedDatasource = $null
        if ($DataSourceAction -ne 'Skip') {
            $candidates = Get-LMDeviceDatasourceList -Id $Id
            foreach ($candidate in $candidates) {
                $ds = Get-LMDatasource -Id $candidate.dataSourceId
                if ($ds.appliesTo -match "system\.deviceId\s*==\s*[`"']$Id[`"']") {
                    $linkedDatasource = $ds
                    break
                }
            }
        }

        $Message = "Id: $Id | DisplayName: $($device.displayName)"
        if ($linkedDatasource -and $DataSourceAction -eq 'Remove') {
            $Message += " (with linked DataSource: $($linkedDatasource.displayName), Id: $($linkedDatasource.id))"
        }

        if (-not $PSCmdlet.ShouldProcess($Message, "Remove Service Insight")) {
            return
        }

        $datasourceResult = $null
        if ($linkedDatasource -and $DataSourceAction -eq 'Remove') {
            $datasourceResult = Remove-LMDatasource -Id $linkedDatasource.id -Confirm:$false
        }

        $deviceResult = Remove-LMDevice -Id $Id -HardDelete $HardDelete -Confirm:$false

        return [PSCustomObject]@{
            Device     = $deviceResult
            Datasource = $datasourceResult
        }
    }
    end {}
}
