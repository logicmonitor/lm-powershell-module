<#
.SYNOPSIS
Retrieves LogicMonitor account usage metrics from the API.

.DESCRIPTION
The Get-LMUsageMetric cmdlet calls the `/metrics/usage` endpoint and returns the usage payload
for your LogicMonitor portal (for example device counts and related usage figures). You must
call Connect-LMAccount before using this cmdlet.

.EXAMPLE
Get-LMUsageMetric

Retrieves current usage metrics for the connected portal.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this cmdlet.

.OUTPUTS
Returns the object returned by the LogicMonitor usage metrics API.

#>
function Get-LMUsageMetric {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param ()
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/metrics/usage"

        
        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

        #Issue request
        $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

        return $Response

    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
