<#
.SYNOPSIS
Removes an OpsNote from LogicMonitor.

.DESCRIPTION
The Remove-LMOpsNote function removes an OpsNote from LogicMonitor. It requires the user to be logged in and have valid API credentials.

.PARAMETER Id
Specifies the ID of the OpsNote to be removed.

.EXAMPLE
Remove-LMOpsNote -Id "12345"
Removes the OpsNote with the ID "12345" from LogicMonitor.

.INPUTS
You can pipe objects to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed OpsNote and a message indicating the success of the removal operation.
#>
function Remove-LMOpsNote {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id

    )
    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/opsnotes/$Id"

            $Message = "Id: $Id"

            #Loop through requests
            try {
                if ($PSCmdlet.ShouldProcess($Message, "Remove OpsNote")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    Invoke-LMRestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

                    $Result = [PSCustomObject]@{
                        Id      = $Id
                        Message = "Successfully removed ($Message)"
                    }

                    return $Result
                }
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
