<#
.SYNOPSIS
Retrieves metadata for a LogicMonitor datasource.

.DESCRIPTION
The Get-LMDatasourceMetadata function retrieves metadata information for a specified LogicMonitor datasource. The datasource can be identified by ID, name, or display name.

.PARAMETER Id
The ID of the datasource to retrieve metadata for. Part of a mutually exclusive parameter set.

.PARAMETER Name
The name of the datasource to retrieve metadata for. Part of a mutually exclusive parameter set.

.PARAMETER DisplayName
The display name of the datasource to retrieve metadata for. Part of a mutually exclusive parameter set.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve metadata by datasource ID
Get-LMDatasourceMetadata -Id 123

.EXAMPLE
#Retrieve metadata by datasource name
Get-LMDatasourceMetadata -Name "CPU"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns metadata information for the specified datasource.
#>

function Get-LMDatasourceMetadata {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'DisplayName')]
        [String]$DisplayName,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Lookup Name
        if ($Name) {
            $LookupResult = (Get-LMDatasource -Name $Name).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        #Lookup DisplayName
        if ($DisplayName) {
            $LookupResult = (Get-LMDatasource -DisplayName $DisplayName).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $DisplayName) {
                return
            }
            $Id = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/setting/registry/metadata/datasource/$Id"

        #Initalize vars
        $QueryParams = ""

        #Build query params
        $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id"

        
        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

        #Issue request
        $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

        return $Response


        return $Results
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
