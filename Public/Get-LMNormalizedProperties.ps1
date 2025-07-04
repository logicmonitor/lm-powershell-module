<#
.SYNOPSIS
Gets normalized property mappings from LogicMonitor.

.DESCRIPTION
The Get-LMNormalizedProperties function retrieves normalized property mappings that allow standardizing property names across your LogicMonitor environment. This function only supports the v4 API.

.PARAMETER None
This cmdlet has no parameters.

.EXAMPLE
#Retrieve all normalized properties
Get-LMNormalizedProperties

.NOTES
You must run Connect-LMAccount before running this command. This command is reserver for internal use only.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.NormalizedProperties objects.
#>
function Get-LMNormalizedProperty {

    [CmdletBinding()]
    param ()

    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/normalizedProperties/filter"

            $Body = [PSCustomObject]@{
                meta = @{
                    filters = @{
                        filterType           = "FILTER_CATEGORICAL_MODEL_TYPE"
                        normalizedProperties = @{
                            dynamic = @(
                                @{
                                    field       = "alias"
                                    expressions = @(
                                        @{
                                            operator = "REGEX"
                                            value    = ".*"
                                        }
                                    )
                                }
                            )
                        }
                    }
                    paging  = @{
                        perPageCount    = 100
                        pageOffsetCount = 0
                    }
                    sort    = "alias, hostPropertyPriority"
                    columns = @(
                        @{ properties = "id, name, propertyType" }
                    )
                }
            } | ConvertTo-Json -Depth 10

            try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-LMRestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

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

                return $Response
            }
            catch {
                return
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
