<#
.SYNOPSIS
Creates a new LogicMonitor remediation source.

.DESCRIPTION
The New-LMRemediationSource function creates a new remediation source in LogicMonitor. You can
specify individual parameters or provide a complete configuration object using the InputObject parameter.

.PARAMETER InputObject
A PSCustomObject containing the complete remediation source configuration. Must follow the schema model
defined in LogicMonitor's API documentation. Use this parameter for advanced or programmatic scenarios.

.PARAMETER Name
The name of the remediation source. This parameter is mandatory when using explicit parameters.

.PARAMETER Description
The description for the remediation source.

.PARAMETER AppliesTo
The AppliesTo expression for the remediation source.

.PARAMETER Technology
The technical notes for the remediation source.

.PARAMETER Tags
The tags to associate with the remediation source.

.PARAMETER Group
The group the remediation source belongs to.

.PARAMETER ScriptType
The script type for the remediation source. Valid values are 'groovy' or 'powershell'. Defaults to 'groovy'.

.PARAMETER GroovyScript
The script content for the remediation source.

.PARAMETER AccessGroupIds
An array of Access Group IDs to assign to the remediation source.

.EXAMPLE
# Create a new remediation source using explicit parameters
New-LMRemediationSource -Name "MyRemediationSource" -Description "Restarts service" -ScriptType "powershell" -GroovyScript "Restart-Service MyService"

.EXAMPLE
# Create a new remediation source using an InputObject
$config = @{
    name = "MyRemediationSource"
    description = "Restarts service"
    scriptType = "powershell"
    groovyScript = "Restart-Service MyService"
}
New-LMRemediationSource -InputObject $config

.NOTES
You must run Connect-LMAccount before running this command.
For remediation source schema details, see the LogicMonitor API documentation.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.RemediationSource object.
#>
function New-LMRemediationSource {
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
            $ResourcePath = "/setting/remediationsources"

            # Build data based on parameter set
            if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
                $Message = "RemediationSource Name: $($InputObject.name)"
                $Data = $InputObject | ConvertTo-Json -Depth 10
            }
            else {
                $Message = "RemediationSource Name: $Name"
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
