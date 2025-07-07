<#
.SYNOPSIS
Retrieves debug results for a LogicMonitor collector.

.DESCRIPTION
The Get-LMCollectorDebugResult function retrieves the debug output for a specified collector debug session. It requires both a session ID and either a collector ID or name to identify the specific debug results to retrieve.

.PARAMETER SessionId
The ID of the debug session to retrieve results from. This parameter is mandatory.

.PARAMETER Id
The ID of the collector to retrieve debug results for. This parameter is mandatory when using the Id parameter set.

.PARAMETER Name
The name of the collector to retrieve debug results for. This parameter is mandatory when using the Name parameter set.

.EXAMPLE
#Retrieve debug results using collector ID
Get-LMCollectorDebugResult -SessionId 12345 -Id 67890

.EXAMPLE
#Retrieve debug results using collector name
Get-LMCollectorDebugResult -SessionId 12345 -Name "Collector1"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns the debug output for the specified collector debug session.
#>
function Get-LMCollectorDebugResult {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Int]$SessionId,

        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name
    )

    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Lookup device name
            if ($Name) {
                if ($Name -match "\*") {
                    Write-Error "Wildcard values not supported for collector names."
                    return
                }
                $Id = (Get-LMCollector -Name $Name | Select-Object -First 1 ).Id
                if (!$Id) {
                    Write-Error "Unable to find collector: $Name, please check spelling and try again."
                    return
                }
            }

            #Build header and uri
            $ResourcePath = "/debug/$SessionId"

            #Build query params
            $QueryParams = "?collectorId=$Id"

            try {

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            }
            catch {
                return
            }
            return $Response.output
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}