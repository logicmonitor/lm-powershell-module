<#
.SYNOPSIS
Retrieves service template information from LogicMonitor.

.DESCRIPTION
The Get-LMDynamicServiceInsight function retrieves service templates from LogicMonitor. This function only supports the v4 API.

With no parameters, returns a summary listing of every template (a
fixed, limited set of columns - does not include fields like
cardinality, propertySelector, properties, serviceNamingPattern,
membershipEvaluationInterval, criticality, staticGroup, or
filterType). Pass -Id to fetch one template's full detail, including
those fields - needed before doing a partial edit of an existing
template (see Set-LMDynamicServiceInsight), since editing anything other
than the isEnabled flag requires resending the complete object.

.PARAMETER Id
The ID of a single Service Template to retrieve in full detail. Part
of a mutually exclusive parameter set; omit to list all templates
(summary view only).

.EXAMPLE
#Retrieve all service templates (summary view)
Get-LMDynamicServiceInsight

.EXAMPLE
#Retrieve one template's full detail
Get-LMDynamicServiceInsight -Id 7

.NOTES
You must run Connect-LMAccount before running this command. This command is reserved for internal use only.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.ServiceTemplate objects.
#>
function Get-LMDynamicServiceInsight {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [String]$Id
    )

    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid -and $Script:LMAuth.Type -eq "SessionSync") {

            if ($PSCmdlet.ParameterSetName -eq 'Id') {
                #Full-detail fetch for a single template by id
                $ResourcePath = "/serviceTemplates/$Id"

                $Body = [PSCustomObject]@{
                    meta = @{
                        columns = @(@{ resources = "" })
                        filters = @{
                            filterType = "FILTER_CATEGORICAL_MODEL_TYPE"
                            resources  = @{
                                dynamic = @(@{
                                        field       = "id"
                                        expressions = @{ "0" = @{ operator = "EQ"; value = "$Id" } }
                                    })
                            }
                        }
                    }
                } | ConvertTo-Json -Depth 10

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body

                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

                $template = $Response.data.byId.RestServiceTemplate.$Id
                if (-not $template) {
                    return
                }
                return (Add-ObjectTypeInfo -InputObject $template -TypeName "LogicMonitor.ServiceTemplate")
            }

            #Build header and uri
            $ResourcePath = "/serviceTemplates/list"
            $BatchSize = 25
            $CommandInvocation = $MyInvocation
            $CallerPSCmdlet = $PSCmdlet

            $Results = Invoke-LMPaginatedPostV4 -BatchSize $BatchSize -InvokeRequest {
                param($Offset, $PageSize)

                $Body = [PSCustomObject]@{
                    meta = @{
                        filters = @{
                            filterType = "FILTER_CATEGORICAL_MODEL_TYPE"
                        }
                        columns = @(
                            @{
                                RestServiceTemplate = "model,id,name,description,isEnabled,noOfServices,serviceIssues,metrics,createdAtMS,isDatasourceAttached,status,isLogicallyDeleted"
                            }
                        )
                        paging  = @{
                            perPageCount    = $PageSize
                            pageOffsetCount = $Offset
                        }
                        sort    = "serviceIssuesRank,name"
                    }
                } | ConvertTo-Json -Depth 10

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation -Payload $Body

                return (Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body)
            } -ExtractItems {
                param($RawResponse)

                if ($RawResponse.data.byId.RestServiceTemplate) {
                    $serviceTemplates = $RawResponse.data.byId.RestServiceTemplate
                    $templateNames = $serviceTemplates.PSObject.Properties.Name | Sort-Object {
                        $parsedName = 0
                        if ([int]::TryParse([string]$_, [ref]$parsedName)) {
                            return $parsedName
                        }
                        return [int]::MaxValue
                    }
                    $transformedProperties = @()
                    foreach ($templateName in $templateNames) {
                        $transformedProperties += $serviceTemplates.$templateName
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

            return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.ServiceTemplate" )

        }
        else {
            Write-Error "This cmdlet is for internal use only at this time does not support LMv1 or Bearer auth. Use Connect-LMAccount to login with the correct auth type and try again"
        }
    }
    end {}
}
