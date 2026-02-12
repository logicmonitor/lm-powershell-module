<#
.SYNOPSIS
Retrieves service template information from LogicMonitor.

.DESCRIPTION
The Get-LMServiceTemplate function retrieves service templates from LogicMonitor. This function only supports the v4 API.

.PARAMETER None
This cmdlet has no parameters.

.EXAMPLE
#Retrieve all service templates
Get-LMServiceTemplate

.NOTES
You must run Connect-LMAccount before running this command. This command is reserved for internal use only.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.ServiceTemplate objects.
#>
function Get-LMServiceTemplate {

    [CmdletBinding()]
    param ()

    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid -and $Script:LMAuth.Type -eq "SessionSync") {

            #Build header and uri
            $ResourcePath = "/serviceTemplates/list"
            $BatchSize = 25
            $CommandInvocation = $MyInvocation

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

                return (Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body)
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