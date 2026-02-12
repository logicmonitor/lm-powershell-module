<#
.SYNOPSIS
Gets normalized property mappings from LogicMonitor.

.DESCRIPTION
The Get-LMNormalizedProperty function retrieves normalized property mappings that allow standardizing property names across your LogicMonitor environment. This function only supports the v4 API.

.PARAMETER None
This cmdlet has no parameters.

.EXAMPLE
#Retrieve all normalized properties
Get-LMNormalizedProperty

.NOTES
You must run Connect-LMAccount before running this command. This command is reserved for internal use only.

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
        if ($Script:LMAuth.Valid -and $Script:LMAuth.Type -eq "SessionSync") {

            #Build header and uri
            $ResourcePath = "/normalizedProperties/filter"
            $BatchSize = 100
            $CommandInvocation = $MyInvocation
            $CallerPSCmdlet = $PSCmdlet

            $Results = Invoke-LMPaginatedPostV4 -BatchSize $BatchSize -InvokeRequest {
                param($Offset, $PageSize)

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
                            perPageCount    = $PageSize
                            pageOffsetCount = $Offset
                        }
                        sort    = "alias, hostPropertyPriority"
                        columns = @(
                            @{ properties = "id, name, propertyType" }
                        )
                    }
                } | ConvertTo-Json -Depth 10

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation -Payload $Body

                return (Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body)
            } -ExtractItems {
                param($RawResponse)

                if ($RawResponse.data.byId.normalizedProperties) {
                    $normalizedProperties = $RawResponse.data.byId.normalizedProperties
                    $propertyNames = $normalizedProperties.PSObject.Properties.Name | Sort-Object {
                        $parsedName = 0
                        if ([int]::TryParse([string]$_, [ref]$parsedName)) {
                            return $parsedName
                        }
                        return [int]::MaxValue
                    }
                    $transformedProperties = @()
                    foreach ($propName in $propertyNames) {
                        $transformedProperties += $normalizedProperties.$propName
                    }
                    return $transformedProperties
                }

                if ($RawResponse.data.items) {
                    return @($RawResponse.data.items)
                }

                return @()
            }

            if ($null -eq $Results) {
                return
            }

            return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.NormalizedProperties" )

        }
        else {
             Write-Error "This cmdlet is for internal use only at this time does not support LMv1 or Bearer auth. Use Connect-LMAccount to login with the correct auth type and try again"
        }
    }
    end {}
}
