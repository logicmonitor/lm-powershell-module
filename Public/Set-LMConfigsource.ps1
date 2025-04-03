<#
.SYNOPSIS
Updates a LogicMonitor config source configuration.

.DESCRIPTION
The Set-LMConfigsource function modifies an existing config source in LogicMonitor, allowing updates to its name, display name, description, applies to settings, and other properties.

.PARAMETER Id
Specifies the ID of the config source to modify. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the current name of the config source. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER NewName
Specifies the new name for the config source.

.PARAMETER DisplayName
Specifies the new display name for the config source.

.PARAMETER Description
Specifies the new description for the config source.

.PARAMETER AppliesTo
Specifies the new applies to expression for the config source.

.PARAMETER TechNotes
Specifies the new technical notes for the config source.

.PARAMETER Tags
Specifies an array of tags to associate with the config source.

.PARAMETER TagsMethod
Specifies how to handle existing tags. Valid values are "Add" or "Refresh". Default is "Refresh".

.PARAMETER PollingIntervalInSeconds
Specifies the polling interval in seconds. Valid values are "3600", "14400", "28800", "86400".

.PARAMETER ConfigChecks
Specifies the configuration checks object for the config source.

.EXAMPLE
Set-LMConfigsource -Id 123 -NewName "UpdatedSource" -Description "New description"
Updates the config source with ID 123 with a new name and description.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.Datasource object containing the updated config source information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
Function Set-LMConfigsource {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [String]$DisplayName,

        [String]$Description,

        [String]$appliesTo,

        [String]$TechNotes,

        [String[]]$Tags,

        [ValidateSet("Add", "Refresh")] # Add will append to existing prop, Refresh will replace existing props with new
        [String]$TagsMethod = "Refresh",

        [ValidateSet("3600", "14400", "28800", "86400")]
        [String]$PollingIntervalInSeconds, #In Seconds

        [PSCustomObject]$ConfigChecks #Should be the full datapoints object from the output of Get-LMDatasource

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Lookup ParentGroupName
            If ($Name) {
                $LookupResult = (Get-LMConfigSource -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Get existing tags if we are adding tags
            If ($Tags -and $TagsMethod -eq "Add") {
                $Tags = [String[]](Get-LMConfigSource -Id $Id).tags + $Tags
            }
                    
            #Build header and uri
            $ResourcePath = "/setting/configsources/$Id"

            If ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name) | DisplayName: $($PSItem.displayName)"
            }
            Elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            Else {
                $Message = "Id: $Id"
            }

            Try {
                $Data = @{
                    name            = $NewName
                    displayName     = $DisplayName
                    description     = $Description
                    appliesTo       = $appliesTo
                    technology      = $TechNotes
                    tags            = $Tags -join ","
                    collectInterval = $PollingIntervalInSeconds
                    configChecks    = $ConfigChecks
                }

                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { If ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json)

                If ($PSCmdlet.ShouldProcess($Message, "Set Configsource")) {  
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?forceUniqueIdentifier=true"

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Datasource" )
                }
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
