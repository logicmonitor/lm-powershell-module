<#
.SYNOPSIS
Creates a new LogicMonitor remediation source.

.DESCRIPTION
The New-LMRemediationSource function creates a new remediation source in LogicMonitor using
a provided remediation source configuration object.

.PARAMETER RemediationSource
A PSCustomObject containing the remediation source configuration. Must follow the schema model
defined in LogicMonitor's API documentation.

.EXAMPLE
# Create a new remediation source
$config = @{
    name = "MyRemediationSource"
    # Additional configuration properties
}
New-LMRemediationSource -RemediationSource $config

.NOTES
You must run Connect-LMAccount before running this command.
For remediation source schema details, see the LogicMonitor API documentation.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.RemediationSource object.
#>
function New-LMRemediationSource {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$RemediationSource
    )
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            $ResourcePath = "/setting/remediationsources"
            $Message = "RemediationSource Name: $($RemediationSource.name)"
            $Data = $RemediationSource
            $Data = ($Data | ConvertTo-Json -Depth 10)

            if ($PSCmdlet.ShouldProcess($Message, "New RemediationSource")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data

                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.RemediationSource")
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
