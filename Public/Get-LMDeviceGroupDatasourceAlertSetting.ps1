<#
.SYNOPSIS
Retrieves datasource alert settings for a LogicMonitor device group.

.DESCRIPTION
The Get-LMDeviceGroupDatasourceAlertSetting function retrieves the alert settings for a specific datasource within a device group. It supports identifying both the group and datasource by either ID or name.

.PARAMETER DatasourceName
The name of the datasource. Required for Id-dsName and Name-dsName parameter sets.

.PARAMETER DatasourceId
The ID of the datasource. Required for Id-dsId and Name-dsId parameter sets.

.PARAMETER Id
The ID of the device group. Required for Id-dsId and Id-dsName parameter sets.

.PARAMETER Name
The name of the device group. Required for Name-dsName and Name-dsId parameter sets.

.PARAMETER Filter
A filter object to apply when retrieving alert settings. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve alert settings using names
Get-LMDeviceGroupDatasourceAlertSetting -Name "Production Servers" -DatasourceName "CPU"

.EXAMPLE
#Retrieve alert settings using IDs
Get-LMDeviceGroupDatasourceAlertSetting -Id 123 -DatasourceId 456

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DeviceGroupDatasourceAlertSetting objects.
#>

Function Get-LMDeviceGroupDatasourceAlertSetting {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Int]$DatasourceId,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Int]$Id,
    
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [String]$Name,

        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If ($Name) {
            $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        #Lookup ParentGroupName
        If ($DatasourceName) {
            $LookupResult = (Get-LMDatasource -Name $DatasourceName).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                return
            }
            $DatasourceId = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/device/groups/$Id/datasources/$DatasourceId/alertsettings"

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
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams
                    
                
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = (Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]).dpConfig

                #Stop looping if single device, no need to continue
                If (![bool]$Response.psobject.Properties["total"]) {
                    $Done = $true
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroupDatasourceAlertSetting" )
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DeviceGroupDatasourceAlertSetting" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
