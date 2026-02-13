<#
.SYNOPSIS
Retrieves instance groups for a LogicMonitor device datasource.

.DESCRIPTION
The Get-LMDeviceDatasourceInstanceGroup function retrieves all instance groups associated with a device datasource. It supports identifying the device and datasource by either ID or name, and allows filtering of the results.

.PARAMETER DatasourceName
The name of the datasource. Required for Id-dsName and Name-dsName parameter sets.

.PARAMETER DatasourceId
The ID of the datasource. Required for Id-dsId and Name-dsId parameter sets.

.PARAMETER Id
The ID of the device. Can be specified using the DeviceId alias. Required for Id-dsId, Id-dsName, and Id-HdsId parameter sets.

.PARAMETER Name
The name of the device. Can be specified using the DeviceName alias. Required for Name-dsName, Name-dsId, and Name-HdsId parameter sets.

.PARAMETER HdsId
The ID of the device datasource. Required for Id-HdsId and Name-HdsId parameter sets.

.PARAMETER InstanceGroupName
The name of the instance group to retrieve. This parameter is optional.

.PARAMETER Filter
A filter object to apply when retrieving instance groups. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve instance groups using names
Get-LMDeviceDatasourceInstanceGroup -DatasourceName "CPU" -Name "Server01"

.EXAMPLE
#Retrieve instance groups using IDs
Get-LMDeviceDatasourceInstanceGroup -DatasourceId 123 -Id 456

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns instance group objects.
#>

function Get-LMDeviceDatasourceInstanceGroup {

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

        [String]$InstanceGroupName,

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

        #Lookup DatasourceId
        if ($DatasourceName -or $DatasourceId) {
            $LookupResult = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId }).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                return
            }
            $HdsId = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/groups"

        $SingleObjectWhenNotPaged = $false

        $CommandInvocation = $MyInvocation
        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id"

            if ($Filter) {
                $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                if ($InstanceGroupName) {
                    $InstanceGroupNameEscaped = $InstanceGroupName.Replace("&", "%26").Replace("'", "%27")
                    $ValidFilter = $ValidFilter + ",name:`"$InstanceGroupNameEscaped`""
                }
                $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
            }
            elseif ($InstanceGroupName) {
                $InstanceGroupNameEscaped = $InstanceGroupName.Replace("&", "%26").Replace("'", "%27")
                $ValidFilter = "name:`"$InstanceGroupNameEscaped`""
                $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            #If the API call failed (for example, resource not found), stop processing.
            if ($null -eq $Response) {
                return
            }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        return $Results
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
