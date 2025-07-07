<#
.SYNOPSIS
Retrieves cloud cost optimization recommendations from LogicMonitor.

.DESCRIPTION
The Get-LMCostOptimizationRecommendations function retrieves cloud cost optimization recommendations from a connected LogicMonitor portal.

.PARAMETER Id
The alphanumeric ID of the cost optimization recommendation to retrieve. Example: 1-2-EBS_UNATTACHED

.PARAMETER Filter
A filter object to apply when retrieving cost optimization recommendations.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 50.

.EXAMPLE
#Retrieve all cost optimization recommendations
Get-LMCostOptimizationRecommendations

.EXAMPLE
#Retrieve cost optimization recommendations using a filter
Get-LMCostOptimizationRecommendations -Filter 'recommendationCategory -eq "Underutilized AWS EC2 instances"'

.NOTES
You must run Connect-LMAccount before running this command. When using filters, consult the LM API docs for allowed filter fields.

.INPUTS
No input is accepted.

.OUTPUTS
Returns LogicMonitor.CostOptimizationRecommendations objects.
#>
function Get-LMCostOptimizationRecommendation {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'Id')]
        [String]$Id,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 50
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/cost-optimization/recommendations"

            #Initalize vars
            $QueryParams = ""
            $Count = 0
            $Done = $false
            $Results = @()

            #Loop through requests
            while (!$Done) {
                #Build query params
                switch ($PSCmdlet.ParameterSetName) {
                    "All" { $QueryParams = "?size=$BatchSize&offset=$Count" }
                    "Id" { $ResourcePath += "/$Id" }
                    "Filter" {
                        #List of allowed filter props
                        $PropList = @()
                        $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                        $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                    }
                    "FilterWizard" {
                        $PropList = @()
                        $Filter = Build-LMFilter -PassThru
                        $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                        $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                    }
                }
                try {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                    #Stop looping if single device, no need to continue
                    if ($PSCmdlet.ParameterSetName -eq "Id") {
                        $Done = $true
                        return $Response
                        return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.CostOptimizationRecommendations" )
                    }
                    #Check result size and if needed loop again
                    else {
                        [Int]$Total = $Response.Total
                        [Int]$Count += ($Response.Items | Measure-Object).Count
                        $Results += $Response.Items
                        if ($Count -ge $Total) {
                            $Done = $true
                        }
                    }
                }
                catch {
                    return
                }
            }
            return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.CostOptimizationRecommendations" )
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
