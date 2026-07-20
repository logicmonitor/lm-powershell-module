<#
.SYNOPSIS
Removes a LogicMonitor remediation source.

.DESCRIPTION
The Remove-LMRemediationSource function removes a LogicMonitor remediation source based on the
specified parameters. It requires the user to be logged in and have valid API credentials.

.PARAMETER Id
Specifies the ID of the remediation source to be removed. This parameter is mandatory when
using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the remediation source to be removed. This parameter is mandatory when
using the 'Name' parameter set.

.EXAMPLE
Remove-LMRemediationSource -Id 123
Removes the remediation source with the ID 123.

.EXAMPLE
Remove-LMRemediationSource -Name "MyRemediationSource"
Removes the remediation source with the name "MyRemediationSource".

.INPUTS
You can pipe input to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed remediation source and a success
message confirming the removal.
#>
function Remove-LMRemediationSource {
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
                $LookupResult = (Get-LMRemediationSource -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) { return }
                $Id = $LookupResult
            }
            $ResourcePath = "/setting/remediationsources/$Id"
            $Message = "Id: $Id | Name: $Name"

            if ($PSCmdlet.ShouldProcess($Message, "Remove RemediationSource")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath

                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation
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
