<#
.SYNOPSIS
Removes a LogicMonitor escalation chain.

.DESCRIPTION
The Remove-LMEscalationChain function removes a LogicMonitor escalation chain based on either its ID or name.

.PARAMETER Id
Specifies the ID of the escalation chain to be removed. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the escalation chain to be removed. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMEscalationChain -Id 12345
Removes the LogicMonitor escalation chain with ID 12345.

.EXAMPLE
Remove-LMEscalationChain -Name "Critical-Alerts"
Removes the LogicMonitor escalation chain with the name "Critical-Alerts".

.INPUTS
You can pipe input to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed escalation chain and a message indicating the success of the removal operation.
#>
function Remove-LMEscalationChain {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Lookup Id if supplying name
            if ($Name) {
                $LookupResult = (Get-LMEscalationChain -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            #Build header and uri
            $ResourcePath = "/setting/alert/chains/$Id"

            
            if ($PSCmdlet.ShouldProcess($Message, "Remove Escalation Chain")) {
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

