<#
.SYNOPSIS
Retrieves dashboard widgets from LogicMonitor.

.DESCRIPTION
The Get-LMDashboardWidget function retrieves widget information from LogicMonitor dashboards. It can return widgets by ID, name, or by their associated dashboard.

.PARAMETER Id
The ID of the widget to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Name
The name of the widget to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER DashboardId
The ID of the dashboard to retrieve widgets from. Part of a mutually exclusive parameter set.

.PARAMETER DashboardName
The name of the dashboard to retrieve widgets from. Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving widgets. Part of a mutually exclusive parameter set.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve a widget by ID
Get-LMDashboardWidget -Id 123

.EXAMPLE
#Retrieve widgets from a specific dashboard
Get-LMDashboardWidget -DashboardName "Production Overview"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DashboardWidget objects.
#>

function Get-LMDashboardWidget {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'DashboardId')]
        [String]$DashboardId,

        [Parameter(ParameterSetName = 'DashboardName')]
        [String]$DashboardName,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        if ($DashboardName) {
            $LookupResult = (Get-LMDashboard -Name $DashboardName).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $DashboardName) {
                return
            }
            $DashboardId = $LookupResult
        }

        $ResourcePath = "/dashboard/widgets"
        $ParameterSetName = $PSCmdlet.ParameterSetName
        $CommandInvocation = $MyInvocation
        $SingleObjectWhenNotPaged = $ParameterSetName -eq "Id"

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = ""

            switch ($ParameterSetName) {
                "All" { $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id" }
                "Id" { $RequestResourcePath = "$ResourcePath/$Id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$PageSize&offset=$Offset&sort=+id" }
                "DashboardId" { $QueryParams = "?filter=dashboardId:`"$DashboardId`"&size=$PageSize&offset=$Offset&sort=+id" }
                "DashboardName" { $QueryParams = "?filter=dashboardId:`"$DashboardId`"&size=$PageSize&offset=$Offset&sort=+id" }
                "Filter" {
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                    $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
                }
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return $null }
            return $Response
        }

        if ($null -eq $Results) { return }
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DashboardWidget" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
