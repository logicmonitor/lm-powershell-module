<#
.SYNOPSIS
Creates normalized properties in LogicMonitor.

.DESCRIPTION
The New-LMNormalizedProperties cmdlet creates normalized properties in LogicMonitor. Normalized properties allow you to map multiple host properties to a single alias that can be used across your environment.

.PARAMETER Alias
The alias name for the normalized property.

.PARAMETER Properties
An array of host property names to map to the alias.

.EXAMPLE
#Creates a normalized property with alias "location" mapped to multiple source properties.
New-LMNormalizedProperties -Alias "location" -Properties @("location", "snmp.sysLocation", "auto.meraki.location")

.NOTES
You must run Connect-LMAccount before running this command. Reserved for internal use.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.NormalizedProperties object.
#>

function New-LMNormalizedProperty {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory = $true)]
        [String]$Alias,
        [Parameter(Mandatory = $true)]
        [Array]$Properties
    )

    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/normalizedProperties/bulk"

            #Loop through each property and build the body
            $Body = [PSCustomObject]@{
                data = [PSCustomObject]@{
                    items = @()
                }
            }
            $Index = 1
            foreach ($Property in $Properties) {
                $Body.data.items += [PSCustomObject]@{
                    alias                = $Alias
                    hostProperty         = $Property
                    hostPropertyPriority = $Index
                    model                = "normalizedProperties"
                }
                $Index++
            }

            $Body = $Body | ConvertTo-Json -Depth 10

            $Message = "Alias: $Alias"

            if ($PSCmdlet.ShouldProcess($Message, "Create Normalized Property")) {
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Version 4
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

                # Transform the response to return just the normalized property values
                if ($Response.data.byId.normalizedProperties) {
                    $normalizedProperties = $Response.data.byId.normalizedProperties
                    $transformedProperties = @()

                    # Get all property names and sort them numerically
                    $propertyNames = $normalizedProperties.PSObject.Properties.Name | Sort-Object { [int]$_ }

                    # Add each property's value to the array
                    foreach ($propName in $propertyNames) {
                        $transformedProperties += $normalizedProperties.$propName
                    }

                    return (Add-ObjectTypeInfo -InputObject $transformedProperties -TypeName "LogicMonitor.NormalizedProperties" )
                }

            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
