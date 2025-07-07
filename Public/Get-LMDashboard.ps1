<#
.SYNOPSIS
Retrieves dashboards from LogicMonitor.

.DESCRIPTION
The Get-LMDashboard function retrieves dashboard information from LogicMonitor based on specified parameters. It supports filtering by ID, name, group information, and custom filters.

.PARAMETER Id
The ID of the dashboard to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Name
The name of the dashboard to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER GroupId
The ID of the group to filter dashboards by. Part of a mutually exclusive parameter set.

.PARAMETER GroupName
The name of the group to filter dashboards by. Part of a mutually exclusive parameter set.

.PARAMETER GroupPathSearchString
A search string to filter dashboards by group path. Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving dashboards. Part of a mutually exclusive parameter set.

.PARAMETER FilterWizard
Switch to use the filter wizard interface for building the filter. Part of a mutually exclusive parameter set.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve a dashboard by ID
Get-LMDashboard -Id 123

.EXAMPLE
#Retrieve dashboards by group name
Get-LMDashboard -GroupName "Production"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Dashboard objects.
#>
function Get-LMDashboard {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the FilterWizard to work')]

    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'GroupId')]
        [String]$GroupId,

        [Parameter(ParameterSetName = 'GroupName')]
        [String]$GroupName,

        [Parameter(ParameterSetName = 'SubGroups')]
        [String]$GroupPathSearchString,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [Parameter(ParameterSetName = 'FilterWizard')]
        [Switch]$FilterWizard,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )

    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/dashboard/dashboards"

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
                "GroupId" { $QueryParams = "?filter=groupId:`"$GroupId`"&size=$BatchSize&offset=$Count&sort=+id" }
                "GroupName" { $QueryParams = "?filter=groupName:`"$GroupName`"&size=$BatchSize&offset=$Count&sort=+id" }
                "SubGroups" { $QueryParams = "?filter=groupFullPath~`"$GroupPathSearchString`"&size=$BatchSize&offset=$Count&sort=+id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+id" }
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
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            #Stop looping if single device, no need to continue
            if ($PSCmdlet.ParameterSetName -eq "Id") {
                $Done = $true
                return $Response
                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Dashboard" )
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
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Dashboard" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
