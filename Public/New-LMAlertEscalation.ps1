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

Function New-LMAlertEscalation {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$Id
    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/alert/alerts/$Id/escalate"

            Try {
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-WebRequest -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1]

                If ($Response.StatusCode -eq 200) {
                    Return "Successfully escalated alert id: $Id"
                }
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
    End {}
}
