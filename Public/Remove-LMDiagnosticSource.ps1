<#
.SYNOPSIS
Removes a LogicMonitor diagnostic source.

.DESCRIPTION
The Remove-LMDiagnosticSource function removes a LogicMonitor diagnostic source based on the specified parameters. It requires the user to be logged in and have valid API credentials.

.PARAMETER Id
Specifies the ID of the diagnostic source to be removed. This parameter is mandatory and can be provided as an integer.

.PARAMETER Name
Specifies the name of the diagnostic source to be removed. This parameter is mandatory when using the 'Name' parameter set and can be provided as a string.

.EXAMPLE
Remove-LMDiagnosticSource -Id 123
Removes the diagnostic source with the ID 123.

.EXAMPLE
Remove-LMDiagnosticSource -Name "MyDiagnosticSource"
Removes the diagnostic source with the name "MyDiagnosticSource".

.INPUTS
You can pipe input to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed diagnostic source and a success message confirming the removal.
#>
function Remove-LMDiagnosticSource {
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
                $LookupResult = (Get-LMDiagnosticSource -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) { return }
                $Id = $LookupResult
            }
            $ResourcePath = "/setting/diagnosticsources/$Id"
            $Message = "Id: $Id | Name: $Name"
            
            if ($PSCmdlet.ShouldProcess($Message, "Remove DiagnosticSource")) {
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