<#
.SYNOPSIS
Retrieves cloud cost optimization recommendation categories from LogicMonitor.

.DESCRIPTION
The Get-LMCostOptimizationRecommendationCategory function retrieves cloud cost optimization recommendation categories from a connected LogicMonitor portal.

.PARAMETER Filter
A filter object to apply when retrieving cost optimization recommendation categories. Only recommendationCategory and recommendationStatus are supported for filtering using the equals operator all others are not supported at this time.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 50.

.EXAMPLE
#Retrieve all cost optimization recommendation categories
Get-LMCostOptimizationRecommendationCategory

.EXAMPLE
#Retrieve cost optimization recommendation categories using a filter
Get-LMCostOptimizationRecommendationCategory -Filter 'recommendationCategory -eq "Underutilized AWS EC2 instances"'

.NOTES
You must run Connect-LMAccount before running this command. When using filters, consult the LM API docs for allowed filter fields.

.INPUTS
No input is accepted.

.OUTPUTS
Returns LogicMonitor.CostOptimizationRecommendationCategory objects.
#>
function Get-LMCostOptimizationRecommendationCategory {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (

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
            $ResourcePath = "/cost-optimization/recommendations/categories"

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
                    "Filter" {
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                        $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                    }
                    "FilterWizard" {
                    $Filter = Build-LMFilter -PassThru -ResourcePath $ResourcePath
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                        $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                    }
                }
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Check result size and if needed loop again
                [Int]$Total = $Response.Total
                [Int]$Count += ($Response.Items | Measure-Object).Count
                $Results += $Response.Items
                if ($Count -ge $Total) {
                    $Done = $true
                }

            }
            return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.CostOptimizationRecommendationCategory" )
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
