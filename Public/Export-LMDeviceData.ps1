<#
.SYNOPSIS
Exports device monitoring data from LogicMonitor.

.DESCRIPTION
The Export-LMDeviceData function exports monitoring data from LogicMonitor devices or device groups. It supports exporting data for specific time ranges and can filter datasources. Data can be exported in CSV or JSON format.

.PARAMETER DeviceId
The ID of the device to export data from. This parameter is part of a mutually exclusive parameter set.

.PARAMETER DeviceDisplayName
The display name of the device to export data from. This parameter is part of a mutually exclusive parameter set.

.PARAMETER DeviceHostName
The hostname of the device to export data from. This parameter is part of a mutually exclusive parameter set.

.PARAMETER DeviceGroupId
The ID of the device group to export data from. This parameter is part of a mutually exclusive parameter set.

.PARAMETER DeviceGroupName
The name of the device group to export data from. This parameter is part of a mutually exclusive parameter set.

.PARAMETER StartDate
The start date and time for data collection. Defaults to 1 hour ago.

.PARAMETER EndDate
The end date and time for data collection. Defaults to current time.

.PARAMETER DatasourceIncludeFilter
A filter pattern to include specific datasources. Defaults to "*" (all datasources).

.PARAMETER DatasourceExcludeFilter
A filter pattern to exclude specific datasources. Defaults to null (no exclusions).

.PARAMETER ExportFormat
The format for the exported data. Valid values are "csv", "json", or "none". Defaults to "none".

.PARAMETER ExportPath
The path where exported files will be saved. Defaults to current directory.

.EXAMPLE
#Export device data to JSON
Export-LMDeviceData -DeviceId 12345 -StartDate (Get-Date).AddDays(-1) -ExportFormat json

.EXAMPLE
#Export device group data to CSV with datasource filtering
Export-LMDeviceData -DeviceGroupName "Production" -DatasourceIncludeFilter "CPU*" -ExportFormat csv

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns device data objects if ExportFormat is "none", otherwise creates export files.
#>
function Export-LMDeviceData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'DeviceId')]
        [Int]$DeviceId,

        [Parameter(Mandatory, ParameterSetName = 'DeviceDisplayName')]
        [String]$DeviceDisplayName,

        [Parameter(Mandatory, ParameterSetName = 'DeviceHostName')]
        [String]$DeviceHostName,

        [Parameter(Mandatory, ParameterSetName = 'DeviceGroupId')]
        [String]$DeviceGroupId,

        [Parameter(Mandatory, ParameterSetName = 'DeviceGroupName')]
        [String]$DeviceGroupName,

        [Datetime]$StartDate = (Get-Date).AddHours(-1),

        [Datetime]$EndDate = (Get-Date),

        [String]$DatasourceIncludeFilter = "*",

        [String]$DatasourceExcludeFilter = $null,

        [ValidateSet("csv", "json", "none")]
        [String]$ExportFormat = 'none',

        [String]$ExportPath = (Get-Location).Path
    )

    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {
        $DeviceList = @()
        $DataExportList = @()
        switch ($PSCmdlet.ParameterSetName) {
            "DeviceId" { $DeviceList = Get-LMDevice -Id $DeviceId }
            "DeviceDisplayName" { $DeviceList = Get-LMDevice -DisplayName $DeviceDisplayName }
            "DeviceHostName" { $DeviceList = Get-LMDevice -Name $DeviceHostName }
            "DeviceGroupId" { $DeviceList = Get-LMDeviceGroupDevice -Id $DeviceGroupId }
            "DeviceGroupName" { $DeviceList = Get-LMDeviceGroupDevice -Name $DeviceGroupName }
        }

        if ($DeviceList) {
            Write-Information "[INFO]: $(($DeviceList | Measure-Object).count) resource(s) selected for data export"
            foreach ($Device in $DeviceList) {
                $DatasourceList = @()
                Write-Information "[INFO]: Starting data collection for resource: $($Device.displayName)"
                $DatasourceList = Get-LMDeviceDatasourceList -Id $Device.id | Where-Object { $_.monitoringInstanceNumber -gt 0 -and $_.dataSourceName -like $DatasourceIncludeFilter -and $_.datasourceName -notlike $DatasourceExcludeFilter }
                if ($DatasourceList) {
                    Write-Information "[INFO]: Found ($(($DatasourceList | Measure-Object).count)) datasource(s) with 1 or more active instances for resource: $($Device.displayName) using datasource filter (Include:$DatasourceIncludeFilter | Exclude:$DatasourceExcludeFilter)"
                    foreach ($Datasource in $DatasourceList) {
                        Write-Information "[INFO]: Starting instance discovery for datasource $($Datasource.dataSourceName) for resource: $($Device.displayName)"
                        $InstanceList = @()
                        $InstanceList = Get-LMDeviceDatasourceInstance -Id $Device.id -DatasourceId $Datasource.dataSourceId | Where-Object { $_.stopMonitoring -eq $false }
                        if ($InstanceList) {
                            Write-Information "[INFO]: Found ($(($InstanceList | Measure-Object).count)) instance(s) for resource: $($Device.displayName)"
                            foreach ($Instance in $InstanceList) {
                                Write-Information "[INFO]: Starting datapoint collection for instance $($Instance.name) for resource: $($Device.displayName)"
                                $Datapoints = @()
                                $Datapoints = Get-LMDeviceData -DeviceId $Device.id -DatasourceId $Datasource.dataSourceId -InstanceId $Instance.id -StartDate $StartDate -EndDate $EndDate
                                if ($Datapoints) {
                                    Write-Information "[INFO]: Finished datapoint collection for instance $($Instance.name) for resource: $($Device.displayName)"
                                    $DataExportList += [PSCustomObject]@{
                                        deviceId       = $Device.id
                                        deviceName     = $Device.displayName
                                        datasourceName = $Datasource.dataSourceName
                                        instanceName   = $Instance.name
                                        instanceGroup  = $Instance.groupName
                                        dataPoints     = $Datapoints
                                    }
                                }
                            }
                        }
                    }
                }
            }

            switch ($ExportFormat) {
                "json" { $DataExportList | ConvertTo-Json -Depth 3 | Out-File -FilePath "$ExportPath\LMDeviceDataExport.json" ; return }
                "csv" { $DataExportList | Export-Csv -NoTypeInformation -Path "$ExportPath\LMDeviceDataExport.csv" ; return }
                default { return $DataExportList }
            }
        }
        else {
            Write-Error "No resources found using supplied parameters, please check you settings and try again."
        }

    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
