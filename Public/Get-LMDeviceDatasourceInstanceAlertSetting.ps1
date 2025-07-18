<#
.SYNOPSIS
Retrieves alert settings for a LogicMonitor device datasource instance.

.DESCRIPTION
The Get-LMDeviceDatasourceInstanceAlertSetting function retrieves the alert configuration settings for a specific device datasource instance. It supports identifying the device and datasource by either ID or name, and allows filtering of the results.

.PARAMETER DatasourceName
The name of the datasource. Required for Id-dsName and Name-dsName parameter sets.

.PARAMETER DatasourceId
The ID of the datasource. Required for Id-dsId and Name-dsId parameter sets.

.PARAMETER Id
The ID of the device. Can be specified using the DeviceId alias. Required for Id-dsId and Id-dsName parameter sets.

.PARAMETER Name
The name of the device. Can be specified using the DeviceName alias. Required for Name-dsName and Name-dsId parameter sets.

.PARAMETER InstanceName
The name of the instance to retrieve alert settings for. This parameter is mandatory.

.PARAMETER Filter
A filter object to apply when retrieving alert settings. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve alert settings using names
Get-LMDeviceDatasourceInstanceAlertSetting -Name "MyDevice" -DatasourceName "MyDatasource" -InstanceName "MyInstance"

.EXAMPLE
#Retrieve alert settings using IDs with filter
Get-LMDeviceDatasourceInstanceAlertSetting -Id 123 -DatasourceId 456 -InstanceName "MyInstance" -Filter $filterObject

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.AlertSetting objects.
#>

function Get-LMDeviceDatasourceInstanceAlertSetting {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Int]$DatasourceId,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Alias('DeviceId')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Alias('DeviceName')]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$InstanceName,

        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000

    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Lookup Device Id
        if ($Name) {
            $LookupResult = (Get-LMDevice -Name $Name).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        #Lookup Hdsid
        if ($DatasourceName -or $DatasourceId) {
            $LookupResult = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId }).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                return
            }
            $HdsId = $LookupResult
        }

        #Replace brakets in instance name
        $InstanceName = $InstanceName -replace "[\[\]]", "?"

        #Lookup HdsiId
        if ($DatasourceName) {
            $LookupResult = (Get-LMDeviceDatasourceInstance -DatasourceName $DatasourceName -DeviceId $Id | Where-Object { $_.name -like "*$InstanceName" }).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $InstanceName) {
                return
            }
            $HdsiId = $LookupResult
        }
        else {
            $LookupResult = (Get-LMDeviceDatasourceInstance -DatasourceId $DatasourceId -DeviceId $Id | Where-Object { $_.name -like "*$InstanceName" }).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $InstanceName) {
                return
            }
            $HdsiId = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$HdsiId/alertsettings"

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

            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            #Stop looping if single device, no need to continue
            if (![bool]$Response.psobject.Properties["total"]) {
                $Done = $true
                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.AlertSetting" )
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
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.AlertSetting" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
