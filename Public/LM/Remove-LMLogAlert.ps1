<#
.SYNOPSIS
Removes a log alert processor from LogicMonitor.

.DESCRIPTION
The Remove-LMLogAlert function removes a log alert processor based on either its ID or name.

.PARAMETER Id
Specifies the ID of the log alert processor to be removed.

.PARAMETER Name
Specifies the name of the log alert processor to be removed.

.EXAMPLE
Remove-LMLogAlert -Id 5

.EXAMPLE
Remove-LMLogAlert -Name "High Error Rate"

.INPUTS
You can pipe input to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed log alert processor and a success message.
#>
function Remove-LMLogAlert {
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
                $LookupResult = (Get-LMLogAlert -Name $Name).id
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

            $ResourcePath = "/logpipelines/processors/$Id"

            if ($PSCmdlet.ShouldProcess($Message, "Remove Log Alert")) {
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
