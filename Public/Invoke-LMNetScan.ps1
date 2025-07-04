<#
.SYNOPSIS
Invokes a NetScan task in LogicMonitor.

.DESCRIPTION
The Invoke-LMNetScan function schedules execution of a specified NetScan task in LogicMonitor.

.PARAMETER Id
The ID of the NetScan to execute.

.EXAMPLE
#Execute a NetScan
Invoke-LMNetScan -Id "12345"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a success message if the NetScan is scheduled successfully.
#>

function Invoke-LMNetScan {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Id
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/netscans/$id/executenow"

            try {

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                Invoke-LMRestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

                return "Scheduled NetScan task for NetScan id: $Id."
            }
            catch {
                return
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
