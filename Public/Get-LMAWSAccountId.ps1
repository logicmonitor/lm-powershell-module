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

Function Get-LMAWSAccountId {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param ()

    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/aws/accountId"

        Try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams
                
            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            Return $Response
        }
        Catch [Exception] {
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
