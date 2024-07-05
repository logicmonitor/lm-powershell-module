<#
.SYNOPSIS
Retrieves the alert settings for a specific LogicMonitor device datasource instance.

.DESCRIPTION
The Get-LMDeviceDatasourceInstanceAlertSetting function retrieves the alert settings for a specific LogicMonitor device datasource instance. It requires the device name or ID, datasource name or ID, and instance name as input parameters. Optionally, you can also provide a filter to narrow down the results. The function returns an array of alert settings for the specified instance.

.PARAMETER DatasourceName
Specifies the name of the datasource. This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter set.

.PARAMETER DatasourceId
Specifies the ID of the datasource. This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter set.

.PARAMETER Id
Specifies the ID of the device. This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter set. This parameter can also be specified using the 'DeviceId' alias.

.PARAMETER Name
Specifies the name of the device. This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter set. This parameter can also be specified using the 'DeviceName' alias.

.PARAMETER InstanceName
Specifies the name of the instance for which to retrieve the alert settings. This parameter is mandatory.

.PARAMETER Filter
Specifies a filter to narrow down the results. This parameter is optional.

.PARAMETER BatchSize
Specifies the number of results to retrieve per batch. The default value is 1000. This parameter is optional.

.EXAMPLE
Get-LMDeviceDatasourceInstanceAlertSetting -Name "MyDevice" -DatasourceName "MyDatasource" -InstanceName "MyInstance"
Retrieves the alert settings for the instance named "MyInstance" of the datasource "MyDatasource" on the device named "MyDevice".

.EXAMPLE
Get-LMDeviceDatasourceInstanceAlertSetting -Id 123 -DatasourceId 456 -InstanceName "MyInstance" -Filter "Property -eq 'value'"
Retrieves the alert settings for the instance named "MyInstance" of the datasource with ID 456 on the device with ID 123, applying the specified filter.

.NOTES
This function requires a valid LogicMonitor API authentication. Make sure you are logged in before running any commands by using the Connect-LMAccount function.
#>

Function Get-LMDeviceDatasourceInstanceAlertSetting {

    [CmdletBinding()]
    Param (
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
    If ($Script:LMAuth.Valid) {

        #Lookup Device Id
        If ($Name) {
            $LookupResult = (Get-LMDevice -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        #Lookup Hdsid
        If ($DatasourceName -or $DatasourceId) {
            $LookupResult = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId }).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                return
            }
            $HdsId = $LookupResult
        }

        #Replace brakets in instance name
        $InstanceName = $InstanceName -replace "[\[\]]", "?"
        
        #Lookup HdsiId
        If ($DatasourceName) {
            $LookupResult = (Get-LMDeviceDatasourceInstance -DatasourceName $DatasourceName -DeviceId $Id | Where-Object { $_.name -like "*$InstanceName" }).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $InstanceName) {
                return
            }
            $HdsiId = $LookupResult
        }
        Else {
            $LookupResult = (Get-LMDeviceDatasourceInstance -DatasourceId $DatasourceId -DeviceId $Id | Where-Object { $_.name -like "*$InstanceName" }).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $InstanceName) {
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
        While (!$Done) {
            #Build query params
            $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id"

            If ($Filter) {
                #List of allowed filter props
                $PropList = @()
                $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
            }

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
                    
                
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                If (![bool]$Response.psobject.Properties["total"]) {
                    $Done = $true
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.AlertSetting" )
                }
                #Check result size and if needed loop again
                Else {
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If ($Count -ge $Total) {
                        $Done = $true
                    }
                }
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.AlertSetting" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
