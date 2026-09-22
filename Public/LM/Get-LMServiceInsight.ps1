<#
.SYNOPSIS
Retrieves Service Insights from LogicMonitor.

.DESCRIPTION
A Service Insight is a LogicMonitor device with DeviceType 6, whose
membership (which devices/instances feed it) is defined by a
"predef.bizservice.members" custom property. Get-LMServiceInsight wraps
Get-LMDevice filtered to deviceType 6, and (unless -Raw is specified)
parses the predef.bizservice.* custom properties into readable
DeviceMemberFilter / InstanceMemberFilter / EvalMembersInterval
properties on the returned object, so the membership definition doesn't
have to be manually pulled out of a nested JSON string.

.PARAMETER Id
The ID of the Service Insight to retrieve. Part of a mutually exclusive
parameter set.

.PARAMETER Name
The (internal) name of the Service Insight to retrieve. Part of a
mutually exclusive parameter set.

.PARAMETER DisplayName
The display name of the Service Insight to retrieve. Part of a mutually
exclusive parameter set.

.PARAMETER Raw
Skip parsing predef.bizservice.* properties; return the plain
LogicMonitor.Device object as Get-LMDevice would, with all other
Service Insights included unfiltered by name/id/displayName.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000.
Defaults to 1000.

.EXAMPLE
#List every Service Insight in the portal
Get-LMServiceInsight

.EXAMPLE
#Get one Service Insight by id, with parsed membership filters
Get-LMServiceInsight -Id 129189

.EXAMPLE
#Get by display name
Get-LMServiceInsight -DisplayName "WebApp Prod"

.NOTES
You must run Connect-LMAccount before running this command.
See New-LMServiceInsight for creating one.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Device objects. Unless -Raw is specified, each also
carries DeviceMemberFilter, InstanceMemberFilter, and
EvalMembersInterval properties parsed from its predef.bizservice.*
custom properties.
#>
function Get-LMServiceInsight {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'DisplayName')]
        [String]$DisplayName,

        [Switch]$Raw,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )

    begin {}
    process {
        if (-not $Script:LMAuth.Valid) {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
            return
        }

        switch ($PSCmdlet.ParameterSetName) {
            'Id' {
                $device = Get-LMDevice -Id $Id
                if ($device -and $device.deviceType -ne 6) {
                    Write-Error "Device $Id (displayName: $($device.displayName)) is not a Service Insight (deviceType $($device.deviceType), expected 6)."
                    return
                }
                $devices = @($device)
            }
            'Name' {
                $devices = @(Get-LMDevice -Name $Name -BatchSize $BatchSize | Where-Object { $_.deviceType -eq 6 })
            }
            'DisplayName' {
                $devices = @(Get-LMDevice -DisplayName $DisplayName -BatchSize $BatchSize | Where-Object { $_.deviceType -eq 6 })
            }
            'All' {
                $devices = @(Get-LMDevice -Filter "deviceType -eq 6" -BatchSize $BatchSize)
            }
        }

        if ($Raw) {
            return $devices
        }

        foreach ($device in $devices) {
            if (-not $device) { continue }

            $properties = Get-LMDeviceProperty -Id $device.id
            $membersRaw = ($properties | Where-Object { $_.name -eq 'predef.bizservice.members' }).value
            $intervalRaw = ($properties | Where-Object { $_.name -eq 'predef.bizservice.evalMembersInterval' }).value

            $deviceMemberFilter = @()
            $instanceMemberFilter = @()
            if ($membersRaw) {
                try {
                    $members = $membersRaw | ConvertFrom-Json
                    $deviceMemberFilter = @($members.device)
                    $instanceMemberFilter = @($members.instance)
                }
                catch {
                    Write-Verbose "Could not parse predef.bizservice.members for device $($device.id): $_"
                }
            }

            $device | Add-Member -NotePropertyName 'DeviceMemberFilter' -NotePropertyValue $deviceMemberFilter -Force
            $device | Add-Member -NotePropertyName 'InstanceMemberFilter' -NotePropertyValue $instanceMemberFilter -Force
            $device | Add-Member -NotePropertyName 'EvalMembersInterval' -NotePropertyValue ([Nullable[Int]]$intervalRaw) -Force

            $device
        }
    }
    end {}
}
