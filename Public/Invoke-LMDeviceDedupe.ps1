<#
.SYNOPSIS
List and/or remove duplicte devices from a portal based on a specified device group and set of exclusion criteria.

.DESCRIPTION
List and/or remove duplicte devices from a portal based on a specified device group and set of exclusion criteria.

.EXAMPLE
Invoke-LMDeviceDedupe -ListDuplicates -DeviceGroupId 8

.NOTES
Additional arrays can be specified to exclude certain IPs, sysname and devicetypes from being used for duplicate comparison

.INPUTS
None. Does not accept pipeline input.
#>
function Invoke-LMDeviceDedupe {

    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'List', Mandatory)]
        [Switch]$ListDuplicates,

        [Parameter(ParameterSetName = 'Remove', Mandatory)]
        [Switch]$RemoveDuplicates,

        [String]$DeviceGroupId,

        [String[]]$IpExclusionList,

        [String[]]$SysNameExclusionList,

        [String[]]$ExcludeDeviceType = @(8) #Exclude K8s resources by default
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            $DeviceList = @()

            $IpExclusionList += @("127.0.0.1", "::1")

            $SysNameExclusionList += @("(none)", "N/A", "none", "blank", "empty", "")

            if ($DeviceGroupId) {
                $DeviceList = Get-LMDeviceGroupDevices -Id $DeviceGroupId
            }
            else {
                $DeviceList = Get-LMDevice
            }

            #Remove excluded device types
            $DeviceList = $DeviceList | Where-Object { $ExcludeDeviceType -notcontains $_.deviceType }

            if ($DeviceList) {
                $OrganizedDevicesList = @()
                $DuplicateSysNameList = @()
                $RemainingDeviceList = @()

                $OutputList = @()

                #Loop through list and compare sysname, hostname and ips
                foreach ($Device in $DeviceList) {
                    $IpList = $null
                    $IpListIndex = $Device.systemProperties.name.IndexOf("system.ips")
                    if ($IpListIndex -ne -1) {
                        $IpList = $Device.systemProperties[$IpListIndex].value
                    }

                    $SysName = $null
                    $SysNameIndex = $Device.systemProperties.name.IndexOf("system.sysname")
                    if ($SysNameIndex -ne -1) {
                        $SysName = $Device.systemProperties[$SysNameIndex].value.tolower()
                    }

                    $HostName = $null
                    $HostNameIndex = $Device.systemProperties.name.IndexOf("system.hostname")
                    if ($HostNameIndex -ne -1) {
                        $HostName = $Device.systemProperties[$HostNameIndex].value.tolower()
                    }

                    $OrganizedDevicesList += [PSCustomObject]@{
                        ipList             = $IpList
                        sysName            = $SysName
                        hostName           = $HostName
                        displayName        = $Device.displayName
                        deviceId           = $Device.id
                        currentCollectorId = $Device.currentCollectorId
                        createdOnEpoch     = $Device.createdOn
                        createdOnDate      = (Get-Date 01.01.1970) + ([System.TimeSpan]::fromseconds($($Device.createdOn)))
                    }
                }
                #Remove items that are missing system.ips and system.sysname
                $OrganizedDevicesList = $OrganizedDevicesList | Where-Object { -not [string]::IsNullOrWhiteSpace($_.ipList) -or -not [string]::IsNullOrWhiteSpace($_.sysName) }

                #group devices with matching sysname values
                $DuplicateSysNameList = $OrganizedDevicesList | Group-Object -Property sysname | Sort-Object Count -Unique -Descending | Where-Object { $_.Count -gt 1 -and $SysNameExclusionList -notcontains $_.Name }

                #Group remaining devices into array so we can process for duplicate ips
                $RemainingDeviceList = ($OrganizedDevicesList | Group-Object -Property sysname | Sort-Object Count -Unique -Descending | Where-Object { $_.Count -eq 1 -or $SysNameExclusionList -contains $_.Name }).Group

                #Loop through each group and add duplicates to our list
                foreach ($Group in $DuplicateSysNameList) {
                    #Get the oldest device out of the group and mark as original device to keep around
                    $OriginalDeviceEpochIndex = $Group.Group.createdOnEpoch.IndexOf($($Group.Group.createdOnEpoch | Sort-Object -Descending | Select-Object -Last 1))
                    $OriginalDevice = $Group.Group[$OriginalDeviceEpochIndex]
                    foreach ($Device in $Group.Group) {
                        if ($Device.deviceId -ne $OriginalDevice.deviceId) {
                            $OutputList += [PSCustomObject]@{
                                duplicate_deviceId           = $Device.deviceId
                                duplicate_sysName            = $Device.sysName
                                duplicate_hostName           = $Device.hostName
                                duplicate_displayName        = $Device.displayName
                                duplicate_currentCollectorId = $Device.currentCollectorId
                                duplicate_createdOnEpoch     = $Device.createdOnEpoch
                                duplicate_createdOnDate      = $Device.createdOnDate
                                duplicate_ipList             = $Device.ipList
                                original_deviceId            = $OriginalDevice.deviceId
                                original_sysName             = $OriginalDevice.sysName
                                original_hostName            = $OriginalDevice.hostName
                                original_displayName         = $OriginalDevice.displayName
                                original_currentCollectorId  = $OriginalDevice.currentCollectorId
                                original_createdOnEpoch      = $OriginalDevice.createdOnEpoch
                                original_createdOnDate       = $OriginalDevice.createdOnDate
                                original_ipList              = $OriginalDevice.ipList
                                duplicate_reason             = "device is considered a duplicate for having a matching sysname value of $($Device.sysName) with $($Group.Count) devices"
                            }
                        }
                    }
                }

                $DuplicateIPDeviceList = @()
                $DuplicateIPDeviceGroupList = @()

                #Find duplicate ips for use to locate
                $DuplicateIPList = @()
                $DuplicateIPList = ($RemainingDeviceList.iplist.split(",") | Group-Object | Where-Object { $_.Count -gt 1 -and $IpExclusionList -notcontains $_.Name }).Group | Select-Object -Unique

                if ($DuplicateIPList) {
                    foreach ($Device in $RemainingDeviceList) {
                        #TODO process system.ips list for dupes if assigned to same collector id
                        $DuplicateCheckResult = @()
                        $DuplicateCheckResult = Compare-Object -ReferenceObject $DuplicateIpList -DifferenceObject $($Device.ipList).split(",") -IncludeEqual -ExcludeDifferent -PassThru
                        if ($DuplicateCheckResult) {
                            $DuplicateIPDeviceList += [PSCustomObject]@{
                                deviceId           = $Device.deviceId
                                ipList             = $Device.ipList
                                sysName            = $Device.sysName
                                hostName           = $Device.hostName
                                displayName        = $Device.displayName
                                currentCollectorId = $Device.currentCollectorId
                                createdOnEpoch     = $Device.createdOnEpoch
                                createdOnDate      = $Device.createdOnDate
                                duplicate_ips      = $DuplicateCheckResult -join ","
                            }
                        }
                    }
                }

                #Group devices with the same duplicate IPs so we can add them to our group
                $DuplicateIPDeviceGroupList = $DuplicateIPDeviceList | Group-Object -Property duplicate_ips | Sort-Object Count -Unique -Descending | Where-Object { $_.count -gt 1 }
                foreach ($Group in $DuplicateIPDeviceGroupList) {
                    #Get the oldest device out of the group and mark as original device to keep around
                    $OriginalDeviceEpochIndex = $Group.Group.createdOnEpoch.IndexOf($($Group.Group.createdOnEpoch | Sort-Object -Descending | Select-Object -Last 1))
                    $OriginalDevice = $Group.Group[$OriginalDeviceEpochIndex]
                    foreach ($Device in $Group.Group) {
                        if ($Device.deviceId -ne $OriginalDevice.deviceId) {
                            $OutputList += [PSCustomObject]@{
                                duplicate_deviceId           = $Device.deviceId
                                duplicate_sysName            = $Device.sysName
                                duplicate_hostName           = $Device.hostName
                                duplicate_displayName        = $Device.displayName
                                duplicate_currentCollectorId = $Device.currentCollectorId
                                duplicate_createdOnEpoch     = $Device.createdOnEpoch
                                duplicate_createdOnDate      = $Device.createdOnDate
                                duplicate_ipList             = $Device.ipList
                                original_deviceId            = $OriginalDevice.deviceId
                                original_sysName             = $OriginalDevice.sysName
                                original_hostName            = $OriginalDevice.hostName
                                original_displayName         = $OriginalDevice.displayName
                                original_currentCollectorId  = $OriginalDevice.currentCollectorId
                                original_createdOnEpoch      = $OriginalDevice.createdOnEpoch
                                original_createdOnDate       = $OriginalDevice.createdOnDate
                                original_ipList              = $OriginalDevice.ipList
                                duplicate_reason             = "device is considered a duplicate for having a matching system.ips value of $($Device.duplicate_ips) with $($Group.Count) devices"
                            }
                        }
                    }
                }
                if ($OutputList) {
                    if ($ListDuplicates) {
                        return (Add-ObjectTypeInfo -InputObject $OutputList -TypeName "LogicMonitor.DedupeList" )
                    }
                    elseif ($RemoveDuplicates) {
                        foreach ($Device in $OutputList) {
                            #Remove duplicate devices
                            Write-Information "[INFO]: Removing device ($($Device.duplicate_deviceId)) $($Device.duplicate_displayName) for reason: $($Device.duplicate_reason)"
                            Remove-LMDevice -Id $Device.duplicate_deviceId
                        }
                    }
                }
                else {
                    Write-Information "[INFO]: No duplicates detected based on set parameters."
                }
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
