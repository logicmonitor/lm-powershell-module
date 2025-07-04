<#
.SYNOPSIS
Retrieves portal information from LogicMonitor.

.DESCRIPTION
The Get-LMPortalInfo function retrieves company settings and portal information from your LogicMonitor instance.

.PARAMETER None
This cmdlet has no parameters.

.EXAMPLE
#Retrieve portal information
Get-LMPortalInfo

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns portal information object containing company settings.
#>
function Get-LMPortalInfo {
    [CmdletBinding()]
    param ()
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/setting/companySetting"

        try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
        }
        catch {
            return
        }
        return $Response
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
