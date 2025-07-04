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

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests
        while (!$Done) {
            #Build query params
            switch ($PSCmdlet.ParameterSetName) {
                "All" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id" }
                "Id" { $resourcePath += "/$Id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+id" }
                "ParentId" { $QueryParams = "?filter=parentId:`"$ParentGroupId`"&size=$BatchSize&offset=$Count&sort=+id" }
                "ParentName" { $QueryParams = "?filter=parentId:`"$ParentGroupId`"&size=$BatchSize&offset=$Count&sort=+id" }
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
                $Response = Invoke-LMRestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                if ($PSCmdlet.ParameterSetName -eq "Id") {
                    $Done = $true
                    return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DashboardGroup" )
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
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DashboardGroup" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
