<#
.SYNOPSIS
Updates a LogicMonitor topology source configuration.

.DESCRIPTION
The Set-LMTopologysource function modifies an existing topology source in LogicMonitor.

.PARAMETER Id
Specifies the ID of the topology source to modify.

.PARAMETER Name
Specifies the current name of the topology source.

.PARAMETER NewName
Specifies the new name for the topology source.

.PARAMETER Description
Specifies the description for the topology source.

.PARAMETER appliesTo
Specifies the applies to expression for the topology source.

.PARAMETER TechNotes
Specifies technical notes for the topology source.

.PARAMETER PollingIntervalInSeconds
Specifies the polling interval in seconds. Valid values: 1800, 3600, 7200, 21600.

.PARAMETER Group
Specifies the group for the topology source.

.PARAMETER ScriptType
Specifies the script type. Valid values: "embed", "powerShell".

.PARAMETER Script
Specifies the script content.

.EXAMPLE
Set-LMTopologysource -Id 123 -NewName "UpdatedSource" -Description "New description"
Updates the topology source with new name and description.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.Topologysource object containing the updated configuration.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMTopologysource {

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

        [ValidateSet("1800", "3600", "7200", "21600")]
        [Nullable[Int]]$PollingIntervalInSeconds,

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

            #Build header and uri
            $ResourcePath = "/setting/topologysources/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            $collectorAttribute = $null
            if ($ScriptType -or $Script) {
                $collectorAttribute = @{
                    groovyScript = $Script
                    scriptType   = $ScriptType
                    name         = "script"
                }
                #Remove empty keys so we dont overwrite them
                @($collectorAttribute.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($collectorAttribute[$_])) { $collectorAttribute.Remove($_) } }
            }

            $Data = @{
                name               = $NewName
                description        = $Description
                appliesTo          = $appliesTo
                technology         = $TechNotes
                group              = $Group
                collectInterval    = $PollingIntervalInSeconds
                collectorAttribute = $collectorAttribute
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                -ConditionalKeep @{ 'name' = 'NewName' }

            if ($PSCmdlet.ShouldProcess($Message, "Set Topology Source")) {
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + "?forceUniqueIdentifier=true"

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request using new centralized method with retry logic
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Topologysource" )

            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
