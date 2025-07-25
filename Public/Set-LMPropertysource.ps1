<#
.SYNOPSIS
Updates a LogicMonitor property source configuration.

.DESCRIPTION
The Set-LMPropertysource function modifies an existing property source in LogicMonitor.

.PARAMETER Id
Specifies the ID of the property source to modify.

.PARAMETER Name
Specifies the current name of the property source.

.PARAMETER NewName
Specifies the new name for the property source.

.PARAMETER Description
Specifies the description for the property source.

.PARAMETER appliesTo
Specifies the applies to expression for the property source.

.PARAMETER TechNotes
Specifies technical notes for the property source.

.PARAMETER Tags
Specifies an array of tags to associate with the property source.

.PARAMETER TagsMethod
Specifies how to handle tags. Valid values: "Add" (append to existing), "Refresh" (replace existing).

.PARAMETER Group
Specifies the group for the property source.

.PARAMETER ScriptType
Specifies the script type. Valid values: "embed", "powerShell".

.PARAMETER Script
Specifies the script content.

.EXAMPLE
Set-LMPropertysource -Id 123 -NewName "UpdatedSource" -Description "New description" -Tags @("prod", "windows")
Updates the property source with new name, description, and tags.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.Propertysource object containing the updated configuration.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMPropertysource {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [String]$Description,

        [String]$appliesTo,

        [String]$TechNotes,

        [String[]]$Tags,

        [ValidateSet("Add", "Refresh")] # Add will append to existing prop, Refresh will replace existing props with new
        [String]$TagsMethod = "Refresh",

        [String]$Group,

        [ValidateSet("embed", "powerShell")]
        [String]$ScriptType,

        [String]$Script

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Lookup ParentGroupName
            if ($Name) {
                $LookupResult = (Get-LMDatasource -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Get existing tags if we are adding tags
            if ($Tags -and $TagsMethod -eq "Add") {
                $Tags = [String[]](Get-LMPropertysource -Id $Id).tags + $Tags
            }

            #Build header and uri
            $ResourcePath = "/setting/propertyrules/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            
            $Data = @{
                name         = $NewName
                description  = $Description
                appliesTo    = $appliesTo
                technology   = $TechNotes
                group        = $Group
                tags         = $Tags -join ","
                groovyScript = $Script
                scriptType   = $ScriptType
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                -ConditionalKeep @{ 'name' = 'NewName' }

            if ($PSCmdlet.ShouldProcess($Message, "Set Property Source")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + "?forceUniqueIdentifier=true"

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Propertysource" )
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
