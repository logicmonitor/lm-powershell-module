<#
.SYNOPSIS
Forces user logoff in LogicMonitor.

.DESCRIPTION
The Invoke-LMUserLogoff function forces one or more users to be logged out of their LogicMonitor sessions.

.PARAMETER Usernames
An array of usernames to log off.

.EXAMPLE
#Log off multiple users
Invoke-LMUserLogoff -Usernames "user1", "user2"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a success message if the logoff is completed successfully.
#>
function Invoke-LMUserLogoff {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String[]]$Usernames
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/admins/services/logoffUsers"

            $Data = @{
                userNames = $Usernames
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data | Out-Null

            return "Invoke session logoff for username(s): $($Usernames -Join ",")."

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
