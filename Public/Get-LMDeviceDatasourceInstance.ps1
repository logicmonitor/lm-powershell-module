<#
.SYNOPSIS
Retrieves datasource instances for a LogicMonitor device.

.DESCRIPTION
The Get-LMDeviceDatasourceInstance function retrieves instances of a datasource from a specific device in LogicMonitor. The device and datasource can be identified by either ID or name.

.PARAMETER DatasourceName
The name of the datasource to retrieve instances from. Required for certain parameter sets.

.PARAMETER DatasourceId
The ID of the datasource to retrieve instances from. Required for certain parameter sets.

.PARAMETER Id
The ID of the device. Can be specified using the DeviceId alias. Required for certain parameter sets.

.PARAMETER Name
The name of the device. Can be specified using the DeviceName alias. Required for certain parameter sets.

.PARAMETER Filter
A filter object to apply when retrieving instances. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve instances by device and datasource name
Get-LMDeviceDatasourceInstance -DatasourceName "CPU" -Name "Production-Server"

.EXAMPLE
#Retrieve instances by IDs
Get-LMDeviceDatasourceInstance -DatasourceId 123 -Id 456

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DeviceDatasourceInstance objects.
#>
function Get-LMDeviceDatasourceInstance {

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
        [Alias("DeviceId")]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Alias("DeviceName")]
        [String]$Name,

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
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances"

        $SingleObjectWhenNotPaged = $false

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
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

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            #If the API call failed (for example, resource not found), stop processing.
            if ($null -eq $Response) {
                return
            }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DeviceDatasourceInstance" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
