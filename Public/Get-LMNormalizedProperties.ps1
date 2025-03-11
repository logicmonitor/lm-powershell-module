<#
.SYNOPSIS
    Gets normalized property mappings that allow standardizing property names across your LogicMonitor environment.

.DESCRIPTION
    The Get-LMNormalizedProperties cmdlet retrieves normalized properties from LogicMonitor. Currently only supports the v4 API.

.EXAMPLE
    PS C:\> Get-LMNormalizedProperties
    Retrieves all normalized properties.
#>
Function Get-LMNormalizedProperties {

    [CmdletBinding()]
    Param ()

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/normalizedProperties/filter"

            $Body = [PSCustomObject]@{
                meta = @{
                    filters = @{
                        filterType = "FILTER_CATEGORICAL_MODEL_TYPE"
                        normalizedProperties = @{
                            dynamic = @(
                                @{
                                    field = "alias"
                                    expressions = @(
                                        @{
                                            operator = "REGEX"
                                            value = ".*"
                                        }
                                    )
                                }
                            )
                        }
                    }
                    paging = @{
                        perPageCount = 100
                        pageOffsetCount = 0
                    }
                    sort = "alias, hostPropertyPriority"
                    columns = @(
                        @{ properties = "id, name, propertyType"}
                    )
                }
            } | ConvertTo-Json -Depth 10

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

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
                    
                    Return (Add-ObjectTypeInfo -InputObject $transformedProperties -TypeName "LogicMonitor.NormalizedProperties" )
                }
                
                return $Response
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
