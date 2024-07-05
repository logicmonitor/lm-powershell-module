<#
.SYNOPSIS
Retrieves the instance groups associated with a LogicMonitor device datasource.

.DESCRIPTION
The Get-LMDeviceDatasourceInstanceGroup function retrieves the instance groups associated with a LogicMonitor device datasource. It requires valid API credentials and a logged-in session.

.PARAMETER DatasourceName
Specifies the name of the datasource. This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

.PARAMETER DatasourceId
Specifies the ID of the datasource. This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

.PARAMETER Id
Specifies the ID of the device. This parameter is mandatory when using the 'Id-dsId', 'Id-dsName', or 'Id-HdsId' parameter sets. This parameter is also aliased as 'DeviceId'.

.PARAMETER Name
Specifies the name of the device. This parameter is mandatory when using the 'Name-dsName', 'Name-dsId', or 'Name-HdsId' parameter sets. This parameter is also aliased as 'DeviceName'.

.PARAMETER HdsId
Specifies the ID of the device datasource. This parameter is mandatory when using the 'Id-HdsId' or 'Name-HdsId' parameter sets.

.PARAMETER Filter
Specifies an optional filter to apply to the results.

.PARAMETER BatchSize
Specifies the number of results to retrieve per batch. The default value is 1000.

.EXAMPLE
Get-LMDeviceDatasourceInstanceGroup -DatasourceName "CPU" -Name "Server01"
Retrieves the instance groups associated with the "CPU" datasource on the device named "Server01".

.EXAMPLE
Get-LMDeviceDatasourceInstanceGroup -DatasourceId 123 -Id 456
Retrieves the instance groups associated with the datasource with ID 123 on the device with ID 456.

#>

Function Get-LMDeviceDatasourceInstanceGroup {
    ...
}

Function Get-LMDeviceDatasourceInstanceGroup {

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
        [Parameter(Mandatory, ParameterSetName = 'Id-HdsId')]
        [Alias('DeviceId')]
        [Int]$Id,
    
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-HdsId')]
        [Alias('DeviceName')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Id-HdsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-HdsId')]
        [String]$HdsId,

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

        #Lookup DatasourceId
        If ($DatasourceName -or $DatasourceId) {
            $LookupResult = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId }).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                return
            }
            $HdsId = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/groups"

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
                    Return $Response
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
        Return $Results
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
