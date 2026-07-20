<#
.SYNOPSIS
Creates a new LogicMonitor diagnostic source.

.DESCRIPTION
The New-LMDiagnosticSource function creates a new diagnostic source in LogicMonitor. You can
specify individual parameters or provide a complete configuration object using the InputObject parameter.

.PARAMETER InputObject
A PSCustomObject containing the complete diagnostic source configuration. Must follow the schema model
defined in LogicMonitor's API documentation. Use this parameter for advanced or programmatic scenarios.

.PARAMETER Name
The name of the diagnostic source. This parameter is mandatory when using explicit parameters.

.PARAMETER Description
The description for the diagnostic source.

.PARAMETER AppliesTo
The AppliesTo expression for the diagnostic source.

.PARAMETER Technology
The technical notes for the diagnostic source.

.PARAMETER Tags
The tags to associate with the diagnostic source.

.PARAMETER Group
The group the diagnostic source belongs to.

.PARAMETER ScriptType
The script type for the diagnostic source. Valid values are 'groovy' or 'powershell'. Defaults to 'groovy'.

.PARAMETER GroovyScript
The script content for the diagnostic source.

.PARAMETER AccessGroupIds
An array of Access Group IDs to assign to the diagnostic source.

.EXAMPLE
# Create a new diagnostic source using explicit parameters
New-LMDiagnosticSource -Name "MyDiagnosticSource" -Description "Checks service status" -ScriptType "powershell" -GroovyScript "Get-Service MyService"

.EXAMPLE
# Create a new diagnostic source using an InputObject
$config = @{
    name = "MyDiagnosticSource"
    description = "Checks service status"
    scriptType = "powershell"
    groovyScript = "Get-Service MyService"
}
New-LMDiagnosticSource -InputObject $config

.NOTES
You must run Connect-LMAccount before running this command.
For diagnostic source schema details, see: https://www.logicmonitor.com/swagger-ui-master/api-v3/dist/#/DiagnosticSources/addDiagnosticSource

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DiagnosticSource object.
#>
function New-LMDiagnosticSource {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None', DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'InputObject')]
        [PSCustomObject]$InputObject,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Default')]
        [String]$Description,

        [Parameter(ParameterSetName = 'Default')]
        [String]$AppliesTo,

        [Parameter(ParameterSetName = 'Default')]
        [String]$Technology,

        [Parameter(ParameterSetName = 'Default')]
        [String]$Tags,

        [Parameter(ParameterSetName = 'Default')]
        [String]$Group,

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet('groovy', 'powershell')]
        [String]$ScriptType = 'groovy',

        [Parameter(ParameterSetName = 'Default')]
        [String]$GroovyScript,

        [Parameter(ParameterSetName = 'Default')]
        [Int32[]]$AccessGroupIds
    )
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            $ResourcePath = "/setting/diagnosticsources"

            # Build data based on parameter set
            if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
                $Message = "DiagnosticSource Name: $($InputObject.name)"
                $Data = $InputObject | ConvertTo-Json -Depth 10
            }
            else {
                $Message = "DiagnosticSource Name: $Name"
                $Data = @{
                    name           = $Name
                    description    = $Description
                    appliesTo      = $AppliesTo
                    technology     = $Technology
                    tags           = $Tags
                    group          = $Group
                    scriptType     = $ScriptType
                    groovyScript   = $GroovyScript
                    accessGroupIds = $AccessGroupIds
                }

                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys
            }

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
