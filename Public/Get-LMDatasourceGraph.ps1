<#
.SYNOPSIS
Retrieves graphs associated with a LogicMonitor datasource.

.DESCRIPTION
The Get-LMDatasourceGraph function retrieves graph information from LogicMonitor datasources. It can retrieve graphs by ID, name, or by their associated datasource using either datasource ID or name.

.PARAMETER Id
The ID of the graph to retrieve. This parameter is mandatory when using the Id-dsId or Id-dsName parameter sets.

.PARAMETER DataSourceName
The name of the datasource to retrieve graphs from. This parameter is mandatory for dsName, Id-dsName, Name-dsName, and Filter-dsName parameter sets.

.PARAMETER DataSourceId
The ID of the datasource to retrieve graphs from. This parameter is mandatory for dsId, Id-dsId, Name-dsId, and Filter-dsId parameter sets.

.PARAMETER Name
The name of the graph to retrieve. This parameter is mandatory for Name-dsId and Name-dsName parameter sets.

.PARAMETER Filter
A filter object to apply when retrieving graphs. This parameter is mandatory for Filter-dsId and Filter-dsName parameter sets.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve a graph by ID from a specific datasource
Get-LMDatasourceGraph -Id 123 -DataSourceId 456

.EXAMPLE
#Retrieve graphs by name from a datasource
Get-LMDatasourceGraph -Name "CPU Usage" -DataSourceName "CPU"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DatasourceGraph objects.
#>
function Get-LMDatasourceGraph {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Filter-dsName')]
        [String]$DataSourceName,

        [Parameter(Mandatory, ParameterSetName = 'dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Filter-dsId')]
        [String]$DataSourceId,

        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Filter-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Filter-dsName')]
        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        if ($DataSourceName) {
            $LookupResult = (Get-LMDatasource -Name $DataSourceName).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $DataSourceName) {
                return
            }
            $DatasourceId = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/setting/datasources/$DatasourceId/graphs"
        $ParameterSetName = $PSCmdlet.ParameterSetName
        $SingleObjectWhenNotPaged = $ParameterSetName -match "^Id"

        $CommandInvocation = $MyInvocation
        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = ""

            switch -Wildcard ($ParameterSetName) {
                "All*" { $QueryParams = "?size=$PageSize&offset=$Offset&sort=+displayPrio" }
                "Id*" { $RequestResourcePath = "$ResourcePath/$Id" }
                "Name*" { $QueryParams = "?filter=name:`"$Name`"&size=$PageSize&offset=$Offset&sort=+displayPrio" }
                "Filter*" {
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                    $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+displayPrio"
                }
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) {
                return $null
            }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DatasourceGraph")
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
