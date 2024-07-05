<#
.SYNOPSIS
Retrieves the AWS Account ID associated with the LogicMonitor account.

.DESCRIPTION
The Get-LMAWSAccountId function is used to retrieve the AWS Account ID associated with the LogicMonitor account. It checks if the user is logged in and has valid API credentials. If the user is logged in, it builds the necessary headers and URI, and then sends a GET request to the LogicMonitor API to retrieve the AWS Account ID. The function returns the response containing the AWS Account ID.

.PARAMETER None
This function does not have any parameters.

.EXAMPLE
Get-LMAWSAccountId
Retrieves the AWS Account ID associated with the LogicMonitor account.
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
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
                
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
