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
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/serviceTemplates/list"

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
                    paging = @{
                        perPageCount = 25
                        pageOffsetCount = 0
                    }
                    sort = "serviceIssuesRank,name"
                }
            } | ConvertTo-Json -Depth 10
                
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

            if ($Response.data.byId.RestServiceTemplate) {
                $serviceTemplates = $Response.data.byId.RestServiceTemplate
                $transformedProperties = @()

                # Get all template names and sort them numerically
                $templateNames = $serviceTemplates.PSObject.Properties.Name | Sort-Object { [int]$_ }
                
                # Add each property's value to the array
                foreach ($templateName in $templateNames) {
                    $transformedProperties += $serviceTemplates.$templateName
                }

                return (Add-ObjectTypeInfo -InputObject $transformedProperties -TypeName "LogicMonitor.ServiceTemplate" )
            }

            return $Response
            
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}