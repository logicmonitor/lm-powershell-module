<#
.SYNOPSIS
Retrieves the AWS External Account ID associated with the LogicMonitor account.

.DESCRIPTION
The Get-LMAWSAccountId function retrieves the AWS External Account ID that is associated with the current LogicMonitor account. This ID is used for AWS integration purposes and helps identify the AWS account linked to your LogicMonitor instance.

.EXAMPLE
#Retrieve the AWS External Account ID
Get-LMAWSAccountId

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a string containing the AWS Account ID.
#>

function Get-LMAWSAccountId {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param ()

    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/aws/accountId"

        try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            return $Response
        }
        catch {
            return
        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
