<#
.SYNOPSIS
Retrieves Catchpoint tests.

.DESCRIPTION
Get-CPTests lists Catchpoint tests from GET /v4/Tests, or retrieves one or more
tests by ID. List results are paginated automatically while the API returns
hasMore = true, unless -PageNumber is specified.

.PARAMETER Id
One or more Catchpoint test IDs. When specified, retrieves those tests via
GET /v4/Tests/{id}.

.PARAMETER Name
Filter tests by name.

.PARAMETER ProductId
One or more product IDs to filter by.

.PARAMETER ParentFolderId
One or more folder IDs. Only tests contained immediately in the specified
folders are returned.

.PARAMETER Status
Test status. Active maps to statusId 0; Inactive maps to statusId 1.

.PARAMETER Url
Filter web tests by URL.

.PARAMETER AlertsPaused
When specified, filter tests with alerts paused ($true) or unpaused ($false).

.PARAMETER TypeId
One or more test type IDs.

.PARAMETER MonitorId
One or more monitor IDs.

.PARAMETER PageSize
Number of results per page. Maximum is 100. Defaults to 100.

.PARAMETER PageNumber
Return only this page instead of automatically paging through all results.

.PARAMETER ShowInheritedProperties
Include inherited properties in the response.

.PARAMETER IncludeAdvancedSettings
Include advanced settings in the response.

.PARAMETER IncludeRequest
Include request settings in the response.

.PARAMETER IncludeInsight
Include insights in the response.

.PARAMETER IncludeTargeting
Include targeting and scheduling in the response.

.PARAMETER IncludeAlerts
Include alert settings in the response.

.EXAMPLE
Get-CPTests

.EXAMPLE
Get-CPTests -Name "Homepage"

.EXAMPLE
Get-CPTests -Id 12345

.EXAMPLE
Get-CPTests -Status Active -ProductId 10, 20

.NOTES
You must run Connect-CPAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns Catchpoint.Test objects.
#>
function Get-CPTests {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int[]]$Id,

        [Parameter(ParameterSetName = 'All')]
        [String]$Name,

        [Parameter(ParameterSetName = 'All')]
        [Int[]]$ProductId,

        [Parameter(ParameterSetName = 'All')]
        [Int[]]$ParentFolderId,

        [Parameter(ParameterSetName = 'All')]
        [ValidateSet('Active', 'Inactive')]
        [String]$Status,

        [Parameter(ParameterSetName = 'All')]
        [String]$Url,

        [Parameter(ParameterSetName = 'All')]
        [Nullable[bool]]$AlertsPaused,

        [Parameter(ParameterSetName = 'All')]
        [Int[]]$TypeId,

        [Parameter(ParameterSetName = 'All')]
        [Int[]]$MonitorId,

        [ValidateRange(1, 100)]
        [Int]$PageSize = 100,

        [ValidateRange(1, [int]::MaxValue)]
        [Int]$PageNumber,

        [Switch]$ShowInheritedProperties,

        [Switch]$IncludeAdvancedSettings,

        [Switch]$IncludeRequest,

        [Switch]$IncludeInsight,

        [Switch]$IncludeTargeting,

        [Switch]$IncludeAlerts
    )

    if (-not (Test-CPAuth -CallerPSCmdlet $PSCmdlet)) {
        return
    }

    if ($PSCmdlet.ParameterSetName -eq 'Id') {
        $testIds = ($Id | ForEach-Object { [string]$_ }) -join ','
        $query = @{}
        if ($ShowInheritedProperties.IsPresent) {
            $query['showInheritedProperties'] = $true
        }

        $uri = Join-CPUri -PortalUrl $Script:CPAuth.PortalUrl -ResourcePath "/v4/Tests/$testIds" -QueryString (New-CPQueryString -Parameters $query)
        $headers = New-CPHeader -Auth $Script:CPAuth -Method GET
        $enableDebugLogging = $DebugPreference -ne 'SilentlyContinue'

        Resolve-CPDebugInfo -Url $uri -Headers $headers -Command $MyInvocation

        $response = Invoke-CPRestMethod -Uri $uri -Method GET -Headers $headers -Auth $Script:CPAuth `
            -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging

        $page = Get-CPResponseItems -Response $response -ItemPropertyName 'tests'
        if ($page.Items.Count -eq 0) {
            Write-Output @() -NoEnumerate
            return
        }

        if ($page.Items.Count -eq 1) {
            return (Add-ObjectTypeInfo -InputObject $page.Items[0] -TypeName 'Catchpoint.Test')
        }

        return (Add-ObjectTypeInfo -InputObject $page.Items -TypeName 'Catchpoint.Test')
    }

    $query = @{}
    if ($Name) { $query['name'] = $Name }
    if ($ProductId) { $query['productIds'] = $ProductId }
    if ($ParentFolderId) { $query['parentFolderIds'] = $ParentFolderId }
    if ($Url) { $query['url'] = $Url }
    if ($TypeId) { $query['typeIds'] = $TypeId }
    if ($MonitorId) { $query['monitorIds'] = $MonitorId }
    if ($PSBoundParameters.ContainsKey('AlertsPaused') -and $null -ne $AlertsPaused) {
        $query['alertsPaused'] = [bool]$AlertsPaused
    }
    if ($Status) {
        $query['statusId'] = if ($Status -eq 'Active') { 0 } else { 1 }
    }
    if ($ShowInheritedProperties.IsPresent) { $query['showInheritedProperties'] = $true }
    if ($IncludeAdvancedSettings.IsPresent) { $query['includeAdvanceSettings'] = $true }
    if ($IncludeRequest.IsPresent) { $query['includeRequest'] = $true }
    if ($IncludeInsight.IsPresent) { $query['includeInsight'] = $true }
    if ($IncludeTargeting.IsPresent) { $query['includeTargeting'] = $true }
    if ($IncludeAlerts.IsPresent) { $query['includeAlerts'] = $true }

    $pageNumberValue = $null
    if ($PSBoundParameters.ContainsKey('PageNumber')) {
        $pageNumberValue = $PageNumber
    }

    $results = Invoke-CPPaginatedGet -ResourcePath '/v4/Tests' -QueryParameters $query -ItemPropertyName 'tests' `
        -PageSize $PageSize -PageNumber $pageNumberValue -CallerPSCmdlet $PSCmdlet -Command $MyInvocation

    if ($results.Count -eq 0) {
        Write-Output @() -NoEnumerate
        return
    }

    return (Add-ObjectTypeInfo -InputObject $results -TypeName 'Catchpoint.Test')
}
