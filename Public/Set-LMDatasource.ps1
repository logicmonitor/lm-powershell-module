<#
.SYNOPSIS
Updates a LogicMonitor datasource configuration.

.DESCRIPTION
The Set-LMDatasource function modifies an existing datasource in LogicMonitor, allowing updates to its name, display name, description, applies to settings, and other properties.

.PARAMETER Id
Specifies the ID of the datasource to modify. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the current name of the datasource. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER NewName
Specifies the new name for the datasource.

.PARAMETER DisplayName
Specifies the new display name for the datasource.

.PARAMETER Description
Specifies the new description for the datasource.

.PARAMETER Tags
Specifies an array of tags to associate with the datasource.

.PARAMETER TagsMethod
Specifies how to handle existing tags. Valid values are "Add" or "Refresh". Default is "Refresh".

.PARAMETER AppliesTo
Specifies the new applies to expression for the datasource.

.PARAMETER TechNotes
Specifies the new technical notes for the datasource.

.PARAMETER PollingIntervalInSeconds
Specifies the polling interval in seconds.

.PARAMETER Datapoints
Specifies the datapoints configuration object for the datasource.

.EXAMPLE
Set-LMDatasource -Id 123 -NewName "UpdatedSource" -Description "New description"
Updates the datasource with ID 123 with a new name and description.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.Datasource object containing the updated datasource information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMDatasource {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [String]$DisplayName,

        [String]$Description,

        [String[]]$Tags,

        [ValidateSet("Add", "Refresh")] # Add will append to existing prop, Refresh will replace existing props with new
        [String]$TagsMethod = "Refresh",

        [String]$appliesTo,

        [String]$TechNotes,

        [String]$PollingIntervalInSeconds, #In Seconds

        [PSCustomObject]$Datapoints #Should be the full datapoints object from the output of Get-LMDatasource

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
                $Tags = [String[]](Get-LMDatasource -Id $Id).tags + $Tags
            }


            #Build header and uri
            $ResourcePath = "/setting/datasources/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name) | DisplayName: $($PSItem.displayName)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            
            $Data = @{
                name            = $NewName
                displayName     = $DisplayName
                description     = $Description
                appliesTo       = $appliesTo
                technology      = $TechNotes
                tags            = $Tags -join ","
                collectInterval = $PollingIntervalInSeconds
                dataPoints      = $Datapoints
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                -ConditionalKeep @{ 'name' = 'NewName' }

            if ($PSCmdlet.ShouldProcess($Message, "Set Datasource")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + "?forceUniqueIdentifier=true"

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Datasource" )
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
