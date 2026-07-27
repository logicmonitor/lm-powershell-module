<#
.SYNOPSIS
Updates a LogicMonitor remediation source configuration.

.DESCRIPTION
The Set-LMRemediationSource function modifies an existing remediation source in LogicMonitor,
allowing updates to its name, description, group, script, tags, technology, appliesTo, scriptType,
accessGroupIds, and other properties. You can specify individual parameters or provide a complete
configuration object using the InputObject parameter.

.PARAMETER Id
Specifies the ID of the remediation source to modify. This parameter is mandatory when using
the 'Id' parameter set.

.PARAMETER Name
Specifies the current name of the remediation source. This parameter is mandatory when using
the 'Name' parameter set.

.PARAMETER InputObject
A PSCustomObject containing the complete remediation source configuration. Must include either
an 'id' or 'name' property to identify the target. Use this parameter for advanced or programmatic scenarios.

.PARAMETER NewName
Specifies the new name for the remediation source.

.PARAMETER Description
Specifies the new description for the remediation source.

.PARAMETER Group
Specifies the group for the remediation source.

.PARAMETER GroovyScript
Specifies the script content for the remediation source.

.PARAMETER Tags
Specifies tags to associate with the remediation source.

.PARAMETER Technology
Specifies the technology details for the remediation source.

.PARAMETER AppliesTo
Specifies the appliesTo expression for the remediation source.

.PARAMETER ScriptType
Specifies the script type for the remediation source. Valid values are 'groovy' or 'powershell'.

.PARAMETER AccessGroupIds
An array of Access Group IDs to assign to the remediation source.

.EXAMPLE
Set-LMRemediationSource -Id 123 -NewName "UpdatedSource" -Description "New description"
Updates the remediation source with ID 123 with a new name and description.

.EXAMPLE
Set-LMRemediationSource -Name "MySource" -Description "Updated description" -ScriptType "powershell"
Updates the remediation source by name and changes the script type.

.EXAMPLE
$config = Get-LMRemediationSource -Id 123
$config.description = "Updated via InputObject"
Set-LMRemediationSource -InputObject $config
Updates the remediation source using an InputObject.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.RemediationSource object containing the updated remediation source information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function Set-LMRemediationSource {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'InputObject')]
        [PSCustomObject]$InputObject,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [String]$NewName,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [String]$Description,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [String]$Group,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [String]$GroovyScript,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [String]$Tags,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [String]$Technology,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [String]$AppliesTo,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [ValidateSet('groovy', 'powershell')]
        [String]$ScriptType,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [Int32[]]$AccessGroupIds
    )
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            # Handle InputObject parameter set
            if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
                # Extract Id from InputObject
                if ($InputObject.id) {
                    $Id = $InputObject.id
                }
                elseif ($InputObject.name) {
                    $LookupResult = (Get-LMRemediationSource -Name $InputObject.name).Id
                    if (Test-LookupResult -Result $LookupResult -LookupString $InputObject.name) { return }
                    $Id = $LookupResult
                }
                else {
                    Write-Error "InputObject must contain either an 'id' or 'name' property."
                    return
                }
                $ResourcePath = "/setting/remediationsources/$Id"
                $Message = "Id: $Id | Name: $($InputObject.name)"
                $Data = $InputObject | ConvertTo-Json -Depth 10
            }
            else {
                # Handle Id and Name parameter sets
                if ($Name) {
                    $LookupResult = (Get-LMRemediationSource -Name $Name).Id
                    if (Test-LookupResult -Result $LookupResult -LookupString $Name) { return }
                    $Id = $LookupResult
                }
                $ResourcePath = "/setting/remediationsources/$Id"
                $Message = "Id: $Id | Name: $Name"
                $Data = @{
                    name           = $NewName
                    description    = $Description
                    group          = $Group
                    groovyScript   = $GroovyScript
                    tags           = $Tags -join ","
                    technology     = $Technology
                    appliesTo      = $AppliesTo
                    scriptType     = $ScriptType
                    accessGroupIds = $AccessGroupIds
                }
                # Remove empty keys so we don't overwrite them, with special handling for 'name'/'NewName'
                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                    -ConditionalKeep @{ 'name' = 'NewName' }
            }

            if ($PSCmdlet.ShouldProcess($Message, "Set RemediationSource")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data

                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.RemediationSource")
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
