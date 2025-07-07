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

.PARAMETER Filter
A filter object to apply when retrieving data. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve data using IDs
Get-LMDeviceData -DeviceId 123 -DatasourceId 456 -InstanceId 789

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

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000

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
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests
        while (!$Done) {
            #Build query params
            $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id"

            if ($Filter) {
                #List of allowed filter props
                $PropList = @()
                $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
            }

            #Add time range filter if provided data ranges
            if ($StartDate -and $EndDate) {
                $QueryParams = $QueryParams + "&start=$StartDate&end=$EndDate"
            }

            try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                if (![bool]$Response.psobject.Properties["total"]) {
                    $Done = $true
                }
                #Check result size and if needed loop again
                else {
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    if ($Count -ge $Total) {
                        $Done = $true
                    }
                }
            }
            catch {
                return
            }
        }
        #Convert results into readable format for consumption
        if ($Response) {
            $DatapointResults = @($null) * ($Response.values | Measure-Object).Count
            for ($v = 0 ; $v -lt ($Response.values | Measure-Object).Count ; $v++) {
                $DatapointResults[$v] = [PSCustomObject]@{}
                $DatapointResults[$v] | Add-Member -MemberType NoteProperty -Name "TimestampEpoch" -Value $Response.time[$v]

                $TimestampConverted = (([System.DateTimeOffset]::FromUnixTimeMilliseconds($Response.time[$v])).DateTime).ToString()
                $DatapointResults[$v] | Add-Member -MemberType NoteProperty -Name "TimestampUTC" -Value $TimestampConverted

                for ($dp = 0 ; $dp -lt ($Response.dataPoints | Measure-Object).Count; $dp++) {
                    $DatapointResults[$v] | Add-Member -MemberType NoteProperty -Name $Response.dataPoints[$dp] -Value $Response.values[$v][$dp]
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
