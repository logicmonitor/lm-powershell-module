function Invoke-CPPaginatedGet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$ResourcePath,

        [Hashtable]$QueryParameters = @{},

        [String]$ItemPropertyName,

        [ValidateRange(1, 100)]
        [Int]$PageSize = 100,

        [Nullable[int]]$PageNumber,

        [System.Management.Automation.PSCmdlet]$CallerPSCmdlet,

        [System.Management.Automation.InvocationInfo]$Command
    )

    $headers = New-CPHeader -Auth $Script:CPAuth -Method GET
    $enableDebugLogging = $DebugPreference -ne 'SilentlyContinue'
    $results = New-Object System.Collections.Generic.List[object]
    $currentPage = if ($PageNumber) { [int]$PageNumber } else { 1 }
    $singlePage = $null -ne $PageNumber -and $PageNumber -gt 0
    $nextUri = $null

    do {
        $query = @{} + $QueryParameters
        $query['pageNumber'] = $currentPage
        $query['pageSize'] = $PageSize

        $uri = if ($nextUri) {
            $nextUri
        }
        else {
            Join-CPUri -PortalUrl $Script:CPAuth.PortalUrl -ResourcePath $ResourcePath -QueryString (New-CPQueryString -Parameters $query)
        }

        if ($Command) {
            Resolve-CPDebugInfo -Url $uri -Headers $headers -Command $Command
        }

        $response = Invoke-CPRestMethod -Uri $uri -Method GET -Headers $headers -Auth $Script:CPAuth `
            -CallerPSCmdlet $CallerPSCmdlet -EnableDebugLogging:$enableDebugLogging

        $page = Get-CPResponseItems -Response $response -ItemPropertyName $ItemPropertyName
        foreach ($item in $page.Items) {
            $results.Add($item)
        }

        if ($singlePage) {
            break
        }

        $nextUri = $null
        if ($page.Next -and $page.Next -match '^https?://') {
            $nextUri = $page.Next
        }
        elseif ($page.HasMore) {
            $currentPage++
        }
        else {
            break
        }
    }
    while ($true)

    return @($results.ToArray())
}
