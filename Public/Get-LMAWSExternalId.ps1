<#
.SYNOPSIS
Retrieves the AWS External ID associated with the LogicMonitor account.

.DESCRIPTION
The Get-LMAWSExternalId function retrieves the AWS External ID that is associated with the current LogicMonitor account. This ID is used for AWS integration purposes and helps identify the AWS account linked to your LogicMonitor instance.

.EXAMPLE
#Retrieve the AWS External ID
Get-LMAWSExternalId

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a string containing the AWS External ID.
#>

function Get-LMAWSExternalId {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param ()

    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/aws/externalId"

        
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
