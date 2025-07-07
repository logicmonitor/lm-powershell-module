<#
.SYNOPSIS
Retrieves data for a specific topology map from LogicMonitor.

.DESCRIPTION
The Get-LMTopologyMapData function retrieves the vertex and edge data for a specified topology map in LogicMonitor. The map can be identified by either ID or name.

.PARAMETER Id
The ID of the topology map to retrieve data from. Required for Id parameter set.

.PARAMETER Name
The name of the topology map to retrieve data from. Required for Name parameter set.

.EXAMPLE
#Retrieve topology map data by ID
Get-LMTopologyMapData -Id 123

.EXAMPLE
#Retrieve topology map data by name
Get-LMTopologyMapData -Name "Network-Topology"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.TopologyMapData objects.
#>

function Get-LMTopologyMapData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Lookup Id if supplying name
        if ($Name) {
            $LookupResult = (Get-LMTopologyMap -Name $Name).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/topology/topologies/$Id/data"

        #Loop through requests
        try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            return (Add-ObjectTypeInfo -InputObject $Response.vertices -TypeName "LogicMonitor.TopologyMapData" )
        }
        catch {
            return
        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
