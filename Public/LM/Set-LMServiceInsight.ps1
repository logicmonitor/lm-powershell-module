<#
.SYNOPSIS
Updates a LogicMonitor Service Insight, most commonly its membership.

.DESCRIPTION
Updates a Service Insight (a DeviceType 6 device) via Set-LMDevice.
-DeviceMemberFilter / -InstanceMemberFilter replace the Service
Insight's entire membership definition (the predef.bizservice.members
custom property) — LogicMonitor's membership model isn't additive per
filter entry, so this cmdlet always replaces the full set of filters
rather than trying to merge with what's already there. Pull the
current filters first with Get-LMServiceInsight, edit the array, and
pass the whole thing back if you need to add/remove one filter among
several.

Also supports updating -EvalMembersInterval and the same general
device fields (name, description, etc.) as Set-LMDevice, without
disturbing the predef.bizservice.* properties unless you specifically
pass -DeviceMemberFilter, -InstanceMemberFilter, or
-EvalMembersInterval.

.PARAMETER Id
The ID of the Service Insight to update. Mandatory.

.PARAMETER DeviceMemberFilter
Replaces the Service Insight's device-level membership filters entirely.
Pass the full desired array (see New-LMServiceInsight for the filter
shape) — omitting this parameter leaves existing device filters
untouched; passing an empty array clears them.

.PARAMETER InstanceMemberFilter
Replaces the Service Insight's instance-level membership filters
entirely, same semantics as -DeviceMemberFilter.

.PARAMETER EvalMembersInterval
Updates how often membership is re-evaluated, in minutes (5, 30, or
1440).

.PARAMETER DisplayName
New display name for the Service Insight device.

.PARAMETER Description
New description for the Service Insight device.

.PARAMETER PreferredCollectorId
New preferred collector for the Service Insight device.

.PARAMETER HostGroupIds
New device group IDs for the Service Insight device. Dynamic group IDs
are ignored; this replaces all existing groups (same as Set-LMDevice).

.PARAMETER Properties
Additional custom properties to set (besides the predef.bizservice.*
ones this cmdlet manages), merged in with -PropertiesMethod Replace
semantics.

.EXAMPLE
#Add another device filter to an existing Service Insight
$si = Get-LMServiceInsight -Id 129189
$newFilters = $si.DeviceMemberFilter + @{
    deviceGroupFullPath = "*"
    deviceDisplayName   = "*"
    deviceProperties    = @(@{ name = "environment"; value = "production" })
}
Set-LMServiceInsight -Id 129189 -DeviceMemberFilter $newFilters

.EXAMPLE
#Just change the re-evaluation interval
Set-LMServiceInsight -Id 129189 -EvalMembersInterval 1440

.NOTES
You must run Connect-LMAccount before running this command.
See New-LMServiceInsight for creating one, Get-LMServiceInsight for
reading current membership.

.INPUTS
You can pipe objects containing an Id property to this function.

.OUTPUTS
Returns a LogicMonitor.Device object for the updated Service Insight.
#>
function Set-LMServiceInsight {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Hashtable[]]$DeviceMemberFilter,

        [Hashtable[]]$InstanceMemberFilter,

        [ValidateSet(5, 30, 1440)]
        [Nullable[Int]]$EvalMembersInterval,

        [String]$DisplayName,

        [String]$Description,

        [Nullable[Int]]$PreferredCollectorId,

        [String[]]$HostGroupIds,

        [Hashtable]$Properties = @{}
    )

    begin {}
    process {
        if (-not $Script:LMAuth.Valid) {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
            return
        }

        $existing = Get-LMDevice -Id $Id
        if (-not $existing) {
            Write-Error "No device found with Id $Id."
            return
        }
        if ($existing.deviceType -ne 6) {
            Write-Error "Device $Id (displayName: $($existing.displayName)) is not a Service Insight (deviceType $($existing.deviceType), expected 6)."
            return
        }

        $touchesMembership = $PSBoundParameters.ContainsKey('DeviceMemberFilter') -or
                              $PSBoundParameters.ContainsKey('InstanceMemberFilter')

        $siProperties = @{}
        foreach ($key in $Properties.Keys) { $siProperties[$key] = $Properties[$key] }

        if ($touchesMembership) {
            # Normalize member filter hashtables into the shape LM expects,
            # same as New-LMServiceInsight.
            $normalizeFilter = {
                param($Filter)
                $normalized = [ordered]@{
                    deviceGroupFullPath = $Filter.deviceGroupFullPath
                    deviceDisplayName   = $Filter.deviceDisplayName
                    deviceProperties    = @($Filter.deviceProperties | ForEach-Object {
                            [ordered]@{ name = $_.name; value = $_.value }
                        })
                }
                # $Filter may be a Hashtable (user-supplied via
                # -DeviceMemberFilter/-InstanceMemberFilter) or a
                # PSCustomObject (the current value read back from
                # Get-LMServiceInsight when only one side was specified) -
                # .ContainsKey only exists on the former, so check
                # property presence in a way that works for both.
                $hasInstanceFields = if ($Filter -is [Hashtable]) {
                    $Filter.ContainsKey('dataSourceFullName')
                } else {
                    [bool]($Filter.PSObject.Properties.Name -contains 'dataSourceFullName')
                }
                if ($hasInstanceFields) {
                    $normalized['dataSourceFullName'] = $Filter.dataSourceFullName
                    $normalized['dataSourceId'] = $Filter.dataSourceId
                    $normalized['instanceName'] = $Filter.instanceName
                    $normalized['instanceProperties'] = @($Filter.instanceProperties)
                }
                return $normalized
            }

            # Only replace the side(s) actually specified - pull the
            # current value for whichever side wasn't, so an
            # -InstanceMemberFilter-only call doesn't blank out existing
            # device filters (and vice versa).
            $currentSI = Get-LMServiceInsight -Id $Id
            $effectiveDeviceFilter = if ($PSBoundParameters.ContainsKey('DeviceMemberFilter')) { $DeviceMemberFilter } else { $currentSI.DeviceMemberFilter }
            $effectiveInstanceFilter = if ($PSBoundParameters.ContainsKey('InstanceMemberFilter')) { $InstanceMemberFilter } else { $currentSI.InstanceMemberFilter }

            $membersPayload = @{
                device   = @($effectiveDeviceFilter | ForEach-Object { & $normalizeFilter $_ })
                instance = @($effectiveInstanceFilter | ForEach-Object { & $normalizeFilter $_ })
            }
            $siProperties['predef.bizservice.members'] = ($membersPayload | ConvertTo-Json -Depth 10 -Compress)
        }

        if ($PSBoundParameters.ContainsKey('EvalMembersInterval')) {
            $siProperties['predef.bizservice.evalMembersInterval'] = $EvalMembersInterval
        }

        $touchesAnyDeviceField = $PSBoundParameters.ContainsKey('DisplayName') -or
                                  $PSBoundParameters.ContainsKey('Description') -or
                                  $PSBoundParameters.ContainsKey('PreferredCollectorId') -or
                                  $PSBoundParameters.ContainsKey('HostGroupIds')
        if ($siProperties.Count -eq 0 -and -not $touchesAnyDeviceField) {
            Write-Error "No fields specified to update - provide at least one parameter besides -Id."
            return
        }

        $Message = "Id: $Id | DisplayName: $($existing.displayName)"

        if (-not $PSCmdlet.ShouldProcess($Message, "Update Service Insight")) {
            return
        }

        $setParams = @{
            Id               = $Id
            PropertiesMethod = 'Replace'
            Confirm          = $false
        }
        if ($siProperties.Count -gt 0) { $setParams['Properties'] = $siProperties }
        if ($DisplayName) { $setParams['DisplayName'] = $DisplayName }
        if ($Description) { $setParams['Description'] = $Description }
        if ($PSBoundParameters.ContainsKey('PreferredCollectorId')) { $setParams['PreferredCollectorId'] = $PreferredCollectorId }
        if ($HostGroupIds) { $setParams['HostGroupIds'] = $HostGroupIds }

        return (Set-LMDevice @setParams)
    }
    end {}
}
