<#
.SYNOPSIS
Creates a new LogicMonitor diagnostic source.

.DESCRIPTION
The New-LMDiagnosticSource function creates a new diagnostic source in LogicMonitor using a provided diagnostic source configuration object.

.PARAMETER DiagnosticSource
A PSCustomObject containing the diagnostic source configuration. Must follow the schema model defined in LogicMonitor's API documentation.

.EXAMPLE
# Create a new diagnostic source
$config = @{
    name = "MyDiagnosticSource"
    # Additional configuration properties
}
New-LMDiagnosticSource -DiagnosticSource $config

.NOTES
You must run Connect-LMAccount before running this command.
For diagnostic source schema details, see: https://www.logicmonitor.com/swagger-ui-master/api-v3/dist/#/DiagnosticSources/addDiagnosticSource

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DiagnosticSource object.
#>
function New-LMDiagnosticSource {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$DiagnosticSource
    )
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            $ResourcePath = "/setting/diagnosticssources"
            $Message = "DiagnosticSource Name: $($DiagnosticSource.name)"
            $Data = $DiagnosticSource
            $Data = ($Data | ConvertTo-Json -Depth 10)
            
            if ($PSCmdlet.ShouldProcess($Message, "New DiagnosticSource")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data

                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DiagnosticSource")
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}