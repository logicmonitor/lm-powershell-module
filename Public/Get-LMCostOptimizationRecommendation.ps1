<#
.SYNOPSIS
Retrieves cloud cost optimization recommendations from LogicMonitor.

.DESCRIPTION
The Get-LMCostOptimizationRecommendation function retrieves cloud cost optimization recommendations from a connected LogicMonitor portal.

.PARAMETER Id
The alphanumeric ID of the cost optimization recommendation to retrieve. Example: 1-2-EBS_UNATTACHED

.PARAMETER Filter
A filter object to apply when retrieving cost optimization recommendations.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 50.

.EXAMPLE
#Retrieve all cost optimization recommendations
Get-LMCostOptimizationRecommendation

.EXAMPLE
#Retrieve cost optimization recommendations using a filter
Get-LMCostOptimizationRecommendation -Filter 'recommendationCategory -eq "Underutilized AWS EC2 instances"'

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

        [Parameter(ParameterSetName = 'FilterWizard')]
        [Switch]$FilterWizard,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 50
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            $ResourcePath = "/cost-optimization/recommendations"
            $ParameterSetName = $PSCmdlet.ParameterSetName
            $CommandInvocation = $MyInvocation
            $SingleObjectWhenNotPaged = $ParameterSetName -eq "Id"
            $CallerPSCmdlet = $PSCmdlet

            $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
                param($Offset, $PageSize)

                $RequestResourcePath = $ResourcePath
                $QueryParams = ""

                switch ($ParameterSetName) {
                    "All" { $QueryParams = "?size=$PageSize&offset=$Offset" }
                    "Id" { $RequestResourcePath = "$ResourcePath/$Id" }
                    "Filter" {
                        $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                        $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
                    }
                    "FilterWizard" {
                        $Filter = Build-LMFilter -PassThru -ResourcePath $ResourcePath
                        $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                        $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
                    }
                }

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

                $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
                if ($null -eq $Response) { return $null }
                return $Response
            }

            if ($null -eq $Results) { return }
            return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.CostOptimizationRecommendations" )
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
