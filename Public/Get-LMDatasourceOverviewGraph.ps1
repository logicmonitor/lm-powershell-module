<#
.SYNOPSIS
Retrieves overview graphs for a LogicMonitor datasource.

.DESCRIPTION
The Get-LMDatasourceOverviewGraph function retrieves overview graph information from LogicMonitor datasources. It can retrieve graphs by ID, name, or by their associated datasource using either datasource ID or name.

.PARAMETER Id
The ID of the overview graph to retrieve. This parameter is mandatory when using the Id-dsId or Id-dsName parameter sets.

.PARAMETER DataSourceName
The name of the datasource to retrieve overview graphs from. This parameter is mandatory for dsName, Id-dsName, Name-dsName, and Filter-dsName parameter sets.

.PARAMETER DataSourceId
The ID of the datasource to retrieve overview graphs from. This parameter is mandatory for dsId, Id-dsId, Name-dsId, and Filter-dsId parameter sets.

.PARAMETER Name
The name of the overview graph to retrieve. This parameter is mandatory for Name-dsId and Name-dsName parameter sets.

.PARAMETER Filter
A filter object to apply when retrieving overview graphs. This parameter is mandatory for Filter-dsId and Filter-dsName parameter sets.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve an overview graph by ID from a specific datasource
Get-LMDatasourceOverviewGraph -Id 123 -DataSourceId 456

.EXAMPLE
#Retrieve overview graphs by name from a datasource
Get-LMDatasourceOverviewGraph -Name "System Overview" -DataSourceName "CPU"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DatasourceGraph objects.
#>
function Get-LMDatasourceOverviewGraph {

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
        $ResourcePath = "/setting/datasources/$DatasourceId/ographs"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests
        while (!$Done) {
            #Build query params
            switch -Wildcard ($PSCmdlet.ParameterSetName) {
                "All*" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+displayPrio" }
                "Id" { $resourcePath += "/$Id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+displayPrio" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+displayPrio"
                }
            }
            try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                if ($PSCmdlet.ParameterSetName -eq "Id") {
                    $Done = $true
                    return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DatasourceGraph")
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
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DatasourceGraph")
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
