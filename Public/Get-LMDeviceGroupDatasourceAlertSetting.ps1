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

function Get-LMDeviceGroupDatasourceAlertSetting {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
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
    if ($Script:LMAuth.Valid) {

        if ($Name) {
            $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        #Lookup ParentGroupName
        if ($DatasourceName) {
            $LookupResult = (Get-LMDatasource -Name $DatasourceName).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                return
            }
            $DatasourceId = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/device/groups/$Id/datasources/$DatasourceId/alertsettings"

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id"

            if ($Filter) {
                $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            $RawResponse = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $RawResponse) {
                return $null
            }

            $Response = $RawResponse.dpConfig
            if ($null -eq $Response) {
                return $null
            }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DeviceGroupDatasourceAlertSetting" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
