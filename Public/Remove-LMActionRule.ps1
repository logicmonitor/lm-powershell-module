<#
.SYNOPSIS
Removes a LogicMonitor action rule.

.DESCRIPTION
The Remove-LMActionRule function removes a LogicMonitor action rule based on the specified ID or name.

.PARAMETER Id
The ID of the action rule to remove.

.PARAMETER Name
The name of the action rule to remove.

.EXAMPLE
Remove-LMActionRule -Id 123

.EXAMPLE
Remove-LMActionRule -Name "MyActionRule"

.NOTES
This function requires a valid LogicMonitor API authentication.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed action rule and a success message.
#>
function Remove-LMActionRule {
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
                $LookupResult = (Get-LMActionRule -Name $Name).Id
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

            $ResourcePath = "/setting/action/rules/$Id"

            if ($PSCmdlet.ShouldProcess($Message, "Remove Action Rule")) {
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
