<#
.SYNOPSIS
Removes a log alert group from LogicMonitor.

.DESCRIPTION
The Remove-LMLogAlertGroup function removes a log alert group (log pipeline) based on either its ID or name.

.PARAMETER Id
Specifies the ID of the log alert group to be removed.

.PARAMETER Name
Specifies the name of the log alert group to be removed.

.EXAMPLE
Remove-LMLogAlertGroup -Id 10

.EXAMPLE
Remove-LMLogAlertGroup -Name "Production Logs"

.INPUTS
You can pipe input to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed log alert group and a success message.
#>
function Remove-LMLogAlertGroup {
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
                $LookupResult = (Get-LMLogAlertGroup -Name $Name).id
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

            $ResourcePath = "/logpipelines/$Id"

            if ($PSCmdlet.ShouldProcess($Message, "Remove Log Alert Group")) {
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
