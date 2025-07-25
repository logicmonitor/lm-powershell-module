<#
.SYNOPSIS
Exports the latest version of device configurations from LogicMonitor.

.DESCRIPTION
The Export-LMDeviceConfigBackup function exports the latest version of device configurations for specified devices. It can export configs from either a single device or all devices in a device group.

.PARAMETER DeviceGroupId
The ID of the device group to export configurations from. This parameter is mandatory when using the DeviceGroup parameter set.

.PARAMETER DeviceId
The ID of the device to export configurations from. This parameter is mandatory when using the Device parameter set.

.PARAMETER InstanceNameFilter
A regex filter to use for filtering Instance names. Defaults to "running|current|PaloAlto".

.PARAMETER ConfigSourceNameFilter
A regex filter to use for filtering ConfigSource names. Defaults to ".*".

.PARAMETER Path
The file path where the CSV backup will be exported to.

.EXAMPLE
#Export configurations from a device group
Export-LMDeviceConfigBackup -DeviceGroupId 2 -Path "export-report.csv"

.EXAMPLE
#Export configurations from a single device
Export-LMDeviceConfigBackup -DeviceId 1 -Path "export-report.csv"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns an array of device configuration objects if successful.
#>

function Export-LMDeviceConfigBackup {

    [CmdletBinding(DefaultParameterSetName = "Device")]
    param (
        [Parameter(ParameterSetName = "DeviceGroup", Mandatory)]
        [Int]$DeviceGroupId,

        [Parameter(ParameterSetName = "Device", Mandatory)]
        [Int]$DeviceId,

        [Regex]$InstanceNameFilter = "[rR]unning|[cC]urrent|[pP]aloAlto",

        [Regex]$ConfigSourceNameFilter = ".*",

        [Parameter()]
        [String]$Path
    )

    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        if ($DeviceId) {
            $network_devices = Get-LMDevice -id $DeviceId
        }
        else {
            $network_devices = Get-LMDeviceGroupDevice -id $DeviceGroupId
        }

        #Loop through Network group devices and pull list of applied ConfigSources
        $instance_list = @()
        Write-Information "[INFO]: Found $(($network_devices | Measure-Object).Count) devices."
        foreach ($device in $network_devices) {
            Write-Information "[INFO]: Collecting configurations for: $($device.displayName)"
            $device_config_sources = Get-LMDeviceDatasourceList -id $device.id | Where-Object { $_.dataSourceType -eq "CS" -and $_.instanceNumber -gt 0 -and $_.dataSourceName -match $ConfigSourceNameFilter }

            Write-Information "[INFO]: Found $(($device_config_sources | Measure-Object).Count) configsource(s) with discovered instances using match filter ($ConfigSourceNameFilter)."
            #Loop through DSes and pull all instances matching running or current and add them to processing list
            $filtered_config_instance_count = 0
            foreach ($config_source in $device_config_sources) {
                $running_config_instance = Get-LMDeviceDatasourceInstance -DeviceId $config_source.deviceId -DatasourceId $config_source.dataSourceId
                $filtered_config_instance = $running_config_instance | Where-Object { $_.displayName -match $InstanceNameFilter }
                if ($filtered_config_instance) {
                    foreach ($instance in $filtered_config_instance) {
                        $filtered_config_instance_count++
                        $instance_list += [PSCustomObject]@{
                            deviceId              = $device.id
                            deviceDisplayName     = $device.displayName
                            dataSourceId          = $config_source.id
                            dataSourceName        = $config_source.datasourceName
                            dataSourceDisplayname = $config_source.dataSourceDisplayname
                            instanceDisplayName   = $instance.displayName
                            instanceDescription   = $instance.description
                            instanceId            = $instance.id
                        }
                    }
                }
            }
            Write-Information "[INFO]: Found $filtered_config_instance_count configsource instance(s) using match filter ($InstanceNameFilter)."
        }

        #Loop through filtered instance list and pull config diff
        $device_configs = @()
        foreach ($instance in $instance_list) {
            $device_configs += Get-LMDeviceConfigSourceData -id $instance.deviceId -HdsId $instance.dataSourceId -HdsInsId $instance.instanceId -ConfigType Full -LatestConfigOnly
        }

        #We found some config changes, let organize them
        $output_list = @()
        if ($device_configs) {
            #Group Configs by device so we can work through each set
            $config_grouping = $device_configs | Group-Object -Property deviceId
            Write-Information "[INFO]: Collecting latest device configurations from $(($config_grouping | Measure-Object).Count) devices."
            #Loop through each set and built report
            foreach ($device in $config_grouping) {
                $config = $device.Group | Sort-Object -Property pollTimestamp -Descending | Select-Object -First 1
                Write-Information "[INFO]: Found $(($device.Group | Measure-Object).Count) configsource instance version(s) for: $($config.deviceDisplayName), selecting latest config dated: $([datetimeoffset]::FromUnixTimeMilliseconds($config.pollTimestamp).DateTime)UTC"
                $output_list += [PSCustomObject]@{
                    deviceDisplayName        = $config.deviceDisplayName
                    deviceInstanceName       = $config.instanceName
                    deviceDatasourceName     = $config.dataSourceName
                    devicePollTimestampEpoch = $config.pollTimestamp
                    devicePollTimestampUTC   = [datetimeoffset]::FromUnixTimeMilliseconds($config.pollTimestamp).DateTime
                    deviceConfigVersion      = $config.version
                    configContent            = $config.config
                }
            }
        }

        if ($output_list) {
            if ($Path) {
                #Generate CSV Export
                $output_list | Export-Csv -Path $Path -NoTypeInformation
            }
            return (Add-ObjectTypeInfo -InputObject $output_list -TypeName "LogicMonitor.ConfigBackup" )
        }
        else {
            Write-Warning "[WARN]: Did not find any configs to output based on selected resource(s), check your parameters and try again."
        }

    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
