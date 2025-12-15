<#
.SYNOPSIS
Retrieves monitoring data for a LogicMonitor device.

.DESCRIPTION
The Get-LMDeviceData function retrieves monitoring data from a specific device's datasource instance in LogicMonitor. It supports various combinations of identifying the device, datasource, and instance, and allows for time range filtering of the data.

.PARAMETER DatasourceName
The name of the datasource to retrieve data from. Required for certain parameter sets.

.PARAMETER DatasourceId
The ID of the datasource to retrieve data from. Required for certain parameter sets.

.PARAMETER DeviceId
The ID of the device to retrieve data from. Required for certain parameter sets.

.PARAMETER DeviceName
The name of the device to retrieve data from. Required for certain parameter sets.

.PARAMETER InstanceId
The ID of the datasource instance to retrieve data from. Required for certain parameter sets.

.PARAMETER InstanceName
The name of the datasource instance to retrieve data from. Required for certain parameter sets.

.PARAMETER StartDate
The start date and time for data collection. Defaults to 7 days ago if not specified.

.PARAMETER EndDate
The end date and time for data collection. Defaults to current time if not specified.

.PARAMETER Datapoints
Comma separated list of datapoints to retrieve. If not provided, all datapoints will be retrieved.

.PARAMETER Filter
A filter object to apply when retrieving data. This parameter is optional.

.EXAMPLE
#Retrieve data using IDs for datapoints "cpu" and "memory"
Get-LMDeviceData -DeviceId 123 -DatasourceId 456 -InstanceId 789 -Datapoints "cpu,memory"

.EXAMPLE
#Retrieve data using names with time range
Get-LMDeviceData -DeviceName "Production-Server" -DatasourceName "CPU" -InstanceName "Total" -StartDate (Get-Date).AddDays(-1)

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns formatted monitoring data with timestamps and values.
#>
function Get-LMDeviceData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceId-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceId-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceName-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceName-instanceId')]
        [String]$DatasourceName,

        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceId-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceId-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceName-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceName-instanceId')]
        [Int]$DatasourceId,

        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceId-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceId-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceId-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceId-instanceName')]
        [Int]$DeviceId,

        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceName-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceName-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceName-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceName-instanceId')]
        [String]$DeviceName,

        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceId-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceName-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceId-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceName-instanceId')]
        [Int]$InstanceId,

        [Parameter(ParameterSetName = 'dsName-deviceId-instanceName')]
        [Parameter(ParameterSetName = 'dsName-deviceName-instanceName')]
        [Parameter(ParameterSetName = 'dsId-deviceName-instanceName')]
        [Parameter(ParameterSetName = 'dsId-deviceId-instanceName')]
        [String]$InstanceName,

        [Datetime]$StartDate,

        [Datetime]$EndDate,

        [Object]$Filter,

        [String]$Datapoints

    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Convert to epoch, if not set use defaults
        if ($StartDate) {
            #If start date is provided, convert to epoch
            [int]$StartDate = ([DateTimeOffset]$($StartDate)).ToUnixTimeSeconds()
        }
        else {
            #If no start date is provided, use 7 days ago
            [int]$StartDate = ([DateTimeOffset]$(Get-Date).AddDays(-7)).ToUnixTimeSeconds()
        }

        if ($EndDate) {
            #If end date is provided, convert to epoch
            [int]$EndDate = ([DateTimeOffset]$($EndDate)).ToUnixTimeSeconds()
        }
        else {
            #If no end date is provided, use current date
            [int]$EndDate = ([DateTimeOffset]$(Get-Date)).ToUnixTimeSeconds()
        }


        #Lookup Device Id
        if ($DeviceName) {
            $LookupResult = (Get-LMDevice -Name $DeviceName).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $DeviceName) {
                return
            }
            $DeviceId = $LookupResult
        }

        #Lookup DatasourceId
        if ($DatasourceName -or $DatasourceId) {
            $LookupResult = (Get-LMDeviceDataSourceList -Id $DeviceId | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId }).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                return
            }
            $HdsId = $LookupResult
        }

        #Lookup InstanceId
        if ($InstanceName) {
            #Replace brakets in instance name
            $InstanceName = $InstanceName -replace "[\[\]]", "?"

            $LookupResult = (Get-LMDeviceDatasourceInstance -DeviceId $DeviceId -DatasourceId $DatasourceId | Where-Object { $_.displayName -eq $InstanceName -or $_.name -like "*$InstanceName" -or $_.name -eq "$InstanceName" }).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $InstanceName) {
                return
            }
            $InstanceId = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/device/devices/$DeviceId/devicedatasources/$HdsId/instances/$InstanceId/data"

        #Initalize vars
        $QueryParams = ""
        $Done = $false
        $AllDatapoints = @()
        $AllValues = @()
        $AllTimes = @()

        #Loop through requests using nextPageParams
        while (!$Done) {
            #Build query params - start with empty or use nextPageParams from previous response
            if (!$QueryParams) {
                $QueryParams = "?"
                
                #Add time range filter if provided data ranges
                if ($StartDate -and $EndDate) {
                    $QueryParams = $QueryParams + "start=$StartDate&end=$EndDate"
                }

                #Add datapoints filter if provided
                if ($Datapoints) {
                    if ($QueryParams -ne "?") {
                        $QueryParams = $QueryParams + "&"
                    }
                    $QueryParams = $QueryParams + "datapoints=$Datapoints"
                }

                #Remove trailing ? if no params were added
                if ($QueryParams -eq "?") {
                    $QueryParams = ""
                }
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            #Collect data from this page
            if ($Response.values) {
                $AllValues += $Response.values
            }
            if ($Response.time) {
                $AllTimes += $Response.time
            }
            if ($Response.dataPoints -and $AllDatapoints.Count -eq 0) {
                $AllDatapoints = $Response.dataPoints
            }

            #Check if there are more pages using nextPageParams
            if ($Response.nextPageParams) {
                $QueryParams = "?$($Response.nextPageParams)"
            }
            else {
                $Done = $true
            }

        }
        #Convert results into readable format for consumption
        if ($AllValues.Count -gt 0) {
            $DatapointResults = @($null) * $AllValues.Count
            for ($v = 0 ; $v -lt $AllValues.Count ; $v++) {
                $DatapointResults[$v] = [PSCustomObject]@{}
                $DatapointResults[$v] | Add-Member -MemberType NoteProperty -Name "TimestampEpoch" -Value $AllTimes[$v]

                $TimestampConverted = (([System.DateTimeOffset]::FromUnixTimeMilliseconds($AllTimes[$v])).DateTime).ToString()
                $DatapointResults[$v] | Add-Member -MemberType NoteProperty -Name "TimestampUTC" -Value $TimestampConverted

                for ($dp = 0 ; $dp -lt $AllDatapoints.Count; $dp++) {
                    $DatapointResults[$v] | Add-Member -MemberType NoteProperty -Name $AllDatapoints[$dp] -Value $AllValues[$v][$dp]
                }
            }
            return $DatapointResults
        }
        else {
            return
        }

    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
