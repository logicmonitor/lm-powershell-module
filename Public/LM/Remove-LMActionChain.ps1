<#
.SYNOPSIS
Removes a LogicMonitor action chain.

.DESCRIPTION
The Remove-LMActionChain function removes a LogicMonitor action chain based on either its ID or name.

.PARAMETER Id
Specifies the ID of the action chain to be removed.

.PARAMETER Name
Specifies the name of the action chain to be removed.

.EXAMPLE
Remove-LMActionChain -Id 12345

.EXAMPLE
Remove-LMActionChain -Name "Disk-Remediation-Chain"

.INPUTS
You can pipe input to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed action chain and a success message.
#>
function Remove-LMActionChain {
    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name
    )
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            if ($Name) {
                $LookupResult = (Get-LMActionChain -Name $Name).Id
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

            $ResourcePath = "/setting/action/chains/$Id"

            if ($PSCmdlet.ShouldProcess($Message, "Remove Action Chain")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation
                Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

                return [PSCustomObject]@{
                    Id      = $Id
                    Message = "Successfully removed ($Message)"
                }
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
