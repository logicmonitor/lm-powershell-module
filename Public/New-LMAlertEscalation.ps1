<#
.SYNOPSIS
Creates a new escalation for a LogicMonitor alert.

.DESCRIPTION
The New-LMAlertEscalation function creates a new escalation for a specified alert in LogicMonitor.

.PARAMETER Id
The ID of the alert to escalate. This parameter is mandatory.

.EXAMPLE
#Escalate an alert
New-LMAlertEscalation -Id "DS12345"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a success message if the escalation is created successfully.
#>

function New-LMAlertEscalation {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$Id
    )
    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/alert/alerts/$Id/escalate"

            $Message = "Alert ID: $Id"

            if ($PSCmdlet.ShouldProcess($Message, "Escalate Alert")) {
                try {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

                    return "Successfully escalated alert id: $Id"
                }
                catch {
                    return
                }
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
