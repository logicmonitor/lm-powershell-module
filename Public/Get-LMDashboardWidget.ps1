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

Function Get-LMDashboardWidget {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
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
    If ($Script:LMAuth.Valid) {

        If ($DashboardName) {
            $LookupResult = (Get-LMDashboard -Name $DashboardName).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DashboardName) {
                return
            }
            $DashboardId = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/dashboard/widgets"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests 
        While (!$Done) {
            #Build query params
            Switch ($PSCmdlet.ParameterSetName) {
                "All" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id" }
                "Id" { $resourcePath += "/$Id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+id" }
                "DashboardId" { $QueryParams = "?filter=dashboardId:`"$DashboardId`"&size=$BatchSize&offset=$Count&sort=+id" }
                "DashboardName" { $QueryParams = "?filter=dashboardId:`"$DashboardId`"&size=$BatchSize&offset=$Count&sort=+id" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                }
            }

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams
                    
                
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                If ($PSCmdlet.ParameterSetName -eq "Id") {
                    $Done = $true
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DashboardWidget" )
                }
                #Check result size and if needed loop again
                Else {
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If ($Count -ge $Total) {
                        $Done = $true
                    }
                }
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DashboardWidget" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
