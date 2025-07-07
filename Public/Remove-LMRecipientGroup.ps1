<#
.SYNOPSIS
Removes a LogicMonitor recipient group.

.DESCRIPTION
The Remove-LMRecipientGroup function removes a LogicMonitor recipient group based on the specified Id or Name. It requires valid API credentials to be logged in.

.PARAMETER Id
The Id of the recipient group to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The name of the recipient group to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMRecipientGroup -Id 123
Removes the recipient group with Id 123.

.EXAMPLE
Remove-LMRecipientGroup -Name "MyRecipientGroup"
Removes the recipient group with the name "MyRecipientGroup".

.INPUTS
You can pipe input to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed recipient group and a success message confirming the removal.
#>
function Remove-LMRecipientGroup {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name

    )
    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup Id if supplying name
            if ($Name) {
                $LookupResult = (Get-LMRecipientGroup -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            if ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            #Build header and uri
            $ResourcePath = "/setting/recipientgroups/$Id"

            
            if ($PSCmdlet.ShouldProcess($Message, "Remove Recipient Group")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

                $Result = [PSCustomObject]@{
                    Id      = $Id
                    Message = "Successfully removed ($Message)"
                }

                return $Result
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
