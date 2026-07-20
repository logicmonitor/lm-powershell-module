<#
.SYNOPSIS
Retrieves dashboard groups from LogicMonitor.

.DESCRIPTION
The Get-LMDashboardGroup function retrieves dashboard group information from LogicMonitor based on specified parameters. It can return a single dashboard group by ID or multiple groups based on name, parent group, or using filters.

.PARAMETER Id
The ID of the dashboard group to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Name
The name of the dashboard group to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER ParentGroupId
The ID of the parent group to filter results by. Part of a mutually exclusive parameter set.

.PARAMETER ParentGroupName
The name of the parent group to filter results by. Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving dashboard groups. Part of a mutually exclusive parameter set.

.PARAMETER FilterWizard
Switch to use the filter wizard interface for building the filter. Part of a mutually exclusive parameter set.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve a dashboard group by ID
Get-LMDashboardGroup -Id 123

.EXAMPLE
#Retrieve dashboard groups by parent group
Get-LMDashboardGroup -ParentGroupName "Production"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DashboardGroup objects.
#>

function Get-LMDashboardGroup {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the FilterWizard to work')]
    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'ParentId')]
        [String]$ParentGroupId,

        [Parameter(ParameterSetName = 'ParentName')]
        [String]$ParentGroupName,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [Parameter(ParameterSetName = 'FilterWizard')]
        [Switch]$FilterWizard,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        if ($ParentGroupName) {
            $LookupResult = (Get-LMDashboardGroup -Name $ParentGroupName).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $ParentGroupName) {
                return
            }
            $ParentGroupId = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/dashboard/groups"
        $ParameterSetName = $PSCmdlet.ParameterSetName
        $SingleObjectWhenNotPaged = $ParameterSetName -eq "Id"
        $CommandInvocation = $MyInvocation
        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = ""

            switch ($ParameterSetName) {
                "All" { $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id" }
                "Id" { $RequestResourcePath = "$ResourcePath/$Id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$PageSize&offset=$Offset&sort=+id" }
                "ParentId" { $QueryParams = "?filter=parentId:`"$ParentGroupId`"&size=$PageSize&offset=$Offset&sort=+id" }
                "ParentName" { $QueryParams = "?filter=parentId:`"$ParentGroupId`"&size=$PageSize&offset=$Offset&sort=+id" }
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
            if ($null -eq $Response) {
                return $null
            }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DashboardGroup" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
