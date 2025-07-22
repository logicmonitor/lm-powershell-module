<#
.SYNOPSIS
Updates normalized properties in LogicMonitor.

.DESCRIPTION
The Set-LMNormalizedProperty cmdlet updates normalized properties in LogicMonitor. Normalized properties allow you to map multiple host properties to a single alias that can be used across your environment.

.PARAMETER Alias
The alias name for the normalized property.

.PARAMETER Add
Indicates that properties should be added to the existing normalized property.

.PARAMETER Remove
Indicates that properties should be removed from the existing normalized property.

.PARAMETER Properties
An array of host property names to map to the alias.

.EXAMPLE
Set-LMNormalizedProperty -Add -Alias "location" -Properties @("location", "snmp.sysLocation", "auto.meraki.location")
Updates a normalized property with alias "location" to include the new properties.

.EXAMPLE
Set-LMNormalizedProperty -Remove -Alias "location" -Properties @("auto.meraki.location")
Removes the "auto.meraki.location" property from the "location" alias.

.INPUTS
None.

.OUTPUTS
Returns a message indicating the success of the operation.

.NOTES
This function requires a valid LogicMonitor API authentication and uses API v4.
#>

function Set-LMNormalizedProperty {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory = $true)]
        [String]$Alias,
        [Parameter(Mandatory = $true, ParameterSetName = "Add")]
        [Switch]$Add,
        [Parameter(Mandatory = $true, ParameterSetName = "Remove")]
        [Switch]$Remove,
        [Parameter(Mandatory = $true)]
        [Array]$Properties
    )

    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            #Get existing normalized properties as all updates have to be done via bulk
            $ExistingProperties = Get-LMNormalizedProperties

            #Build header and uri
            $ResourcePath = "/normalizedProperties/bulk"

            #Initialize the body with existing properties that don't match our alias
            $Body = [PSCustomObject]@{
                data = [PSCustomObject]@{
                    items = @()
                }
            }

            # Track the highest priority for the current alias
            $maxPriority = 0

            # If we're removing properties, we need to preserve all other aliases
            if ($Remove) {
                # Add all existing properties
                foreach ($prop in $ExistingProperties) {
                    if ($prop.isEditable) {
                        if ($prop.alias -eq $Alias) {
                            # Only keep properties that aren't in our removal list
                            if ($prop.hostProperty -notin $Properties) {
                                $Body.data.items += [PSCustomObject]@{
                                    id                   = $prop.id
                                    model                = "normalizedProperties"
                                    alias                = $prop.alias
                                    hostProperty         = $prop.hostProperty
                                    hostPropertyPriority = $prop.hostPropertyPriority
                                    description          = $prop.description
                                }
                            }
                        }
                        else {
                            # For non-editable properties, only include id and model
                            $Body.data.items += [PSCustomObject]@{
                                id    = $prop.id
                                model = "normalizedProperties"
                            }
                        }
                    }
                }
            }
            # If we're adding properties, we need to preserve existing properties for other aliases
            # and add our new properties
            else {
                # First add all existing properties
                foreach ($prop in $ExistingProperties) {
                    if ($prop.alias -eq $Alias) {
                        # Track the highest priority for this alias
                        if ($prop.hostPropertyPriority -gt $maxPriority) {
                            $maxPriority = $prop.hostPropertyPriority
                        }
                        # Only include full property details if it's editable
                        if ($prop.isEditable) {
                            $Body.data.items += [PSCustomObject]@{
                                id                   = $prop.id
                                model                = "normalizedProperties"
                                alias                = $prop.alias
                                hostProperty         = $prop.hostProperty
                                hostPropertyPriority = $prop.hostPropertyPriority
                                description          = $prop.description
                            }
                        }
                        else {
                            # For non-editable properties, only include id and model
                            $Body.data.items += [PSCustomObject]@{
                                id    = $prop.id
                                model = "normalizedProperties"
                            }
                        }
                    }
                    else {
                        if ($prop.isEditable) {
                            # For other aliases, only include id and model
                            $Body.data.items += [PSCustomObject]@{
                                id    = $prop.id
                                model = "normalizedProperties"
                            }
                        }

                    }
                }

                # Then add our new properties starting from the next available priority
                $Index = $maxPriority + 1
                foreach ($Property in $Properties) {
                    # Check if this property already exists for this alias
                    $exists = $false
                    foreach ($prop in $ExistingProperties) {
                        if ($prop.alias -eq $Alias -and $prop.hostProperty -eq $Property) {
                            $exists = $true
                            break
                        }
                    }

                    # Only add if it doesn't already exist
                    if (-not $exists) {
                        $Body.data.items += [PSCustomObject]@{
                            model                = "normalizedProperties"
                            alias                = $Alias
                            hostProperty         = $Property
                            hostPropertyPriority = $Index
                        }
                        $Index++
                    }
                }
            }

            $Body = $Body | ConvertTo-Json -Depth 10

            $ActionType = if ($Add) { "add" } else { "remove" }
            $PropertiesCount = ($Properties | Measure-Object).Count
            $Message = "Alias: $Alias | Action: $ActionType | Properties: $PropertiesCount"

            
            if ($PSCmdlet.ShouldProcess($Message, "Set Normalized Properties")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Version 4
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

                # Check for errors in the response
                if ($Response.errors.Count -gt 0) {
                    foreach ($errorItem in $Response.errors) {
                        Write-Error "Error updating normalized properties: $($errorItem.message)"
                    }
                    return
                }
                Write-Output "Normalized properties updated successfully"
                return
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
