<#
.SYNOPSIS
Updates the new user message template in LogicMonitor.

.DESCRIPTION
The Set-LMNewUserMessage function modifies the message template that is sent to new users in LogicMonitor.

.PARAMETER MessageBody
Specifies the body content of the message template.

.PARAMETER MessageSubject
Specifies the subject line of the message template.

.EXAMPLE
Set-LMNewUserMessage -MessageBody "Welcome to our monitoring system" -MessageSubject "Welcome to LogicMonitor"
Updates the new user message template with the specified subject and body.

.INPUTS
None.

.OUTPUTS
Returns the response from the API indicating the success of the update.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

Function Set-LMNewUserMessage {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (

        [Parameter(Mandatory)]
        [String]$MessageBody,

        [Parameter(Mandatory)]
        [String]$MessageSubject

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/messagetemplate"

            $Message = "New User Message Template"

            Try {
                $Data = @{
                    messageBody    = $MessageBody
                    messageSubject = $MessageSubject
                }

                #Remove empty keys so we dont overwrite them
                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys

                If ($PSCmdlet.ShouldProcess($Message, "Set New User Message Template")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return $Response
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
