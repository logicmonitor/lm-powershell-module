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

        $ResourcePath = "/dashboard/dashboards"
        $ParameterSetName = $PSCmdlet.ParameterSetName
        $CommandInvocation = $MyInvocation
        $SingleObjectWhenNotPaged = $ParameterSetName -eq "Id"
        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = ""

            switch ($ParameterSetName) {
                "All" { $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id" }
                "Id" { $RequestResourcePath = "$ResourcePath/$Id" }
                "GroupId" { $QueryParams = "?filter=groupId:`"$GroupId`"&size=$PageSize&offset=$Offset&sort=+id" }
                "GroupName" { $QueryParams = "?filter=groupName:`"$GroupName`"&size=$PageSize&offset=$Offset&sort=+id" }
                "SubGroups" { $QueryParams = "?filter=groupFullPath~`"$GroupPathSearchString`"&size=$PageSize&offset=$Offset&sort=+id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$PageSize&offset=$Offset&sort=+id" }
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
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Dashboard" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
