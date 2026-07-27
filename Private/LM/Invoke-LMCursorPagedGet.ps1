<#
.SYNOPSIS
Centralized cursor/async pagination runner for LogicMonitor requests.

.DESCRIPTION
Invoke-LMCursorPagedGet executes a caller-supplied request scriptblock that can
use next-page cursors and async completion state. It aggregates extracted items
across iterations and stops when completion criteria are met.
Callers should capture `$PSCmdlet` before invoking this helper and pass that
captured reference to `Invoke-LMRestMethod -CallerPSCmdlet` inside InvokeRequest.

.PARAMETER InvokeRequest
A scriptblock that accepts three arguments: cursor token, page index, and the
previous response. It returns the current API response.

.PARAMETER ExtractItems
A scriptblock that receives one argument (the response) and returns the items
collection for the current response.

.PARAMETER GetNextCursor
Optional scriptblock that receives one argument (the response) and returns the
next cursor token or nextPageParams value.

.PARAMETER IsComplete
Optional scriptblock that receives three arguments (response, page index, and
cursor token) and returns $true when pagination should stop.

.PARAMETER PollSeconds
Optional sleep interval between iterations. Defaults to 0.

.PARAMETER MaxIterations
Maximum loop iterations before stopping. Defaults to 1000.

.PARAMETER MaxPages
Optional maximum number of pages with extracted items to collect.

.PARAMETER MaxPagesWarningMessage
Optional informational message emitted when MaxPages is reached.

.OUTPUTS
Object[]
#>
function Invoke-LMCursorPagedGet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ScriptBlock]$InvokeRequest,

        [Parameter(Mandatory)]
        [ScriptBlock]$ExtractItems,

        [ScriptBlock]$GetNextCursor,

        [ScriptBlock]$IsComplete,

        [ValidateRange(0, 300)]
        [Int]$PollSeconds = 0,

        [ValidateRange(1, 50000)]
        [Int]$MaxIterations = 1000,

        [ValidateRange(0, 100000)]
        [Int]$MaxPages = 0,

        [String]$MaxPagesWarningMessage
    )

    $cursor = $null
    $previousResponse = $null
    $results = @()
    $pageIndex = 0
    $collectedPages = 0

    while ($pageIndex -lt $MaxIterations) {
        $response = & $InvokeRequest $cursor $pageIndex $previousResponse
        if ($null -eq $response) {
            if ($results.Count -eq 0) {
                return $null
            }
            break
        }

        $items = @(& $ExtractItems $response)
        if ($items.Count -gt 0) {
            $results += $items
            $collectedPages++

            if ($MaxPages -gt 0 -and $collectedPages -ge $MaxPages) {
                if ($MaxPagesWarningMessage) {
                    Write-Information $MaxPagesWarningMessage
                }
                break
            }
        }

        $shouldStop = $false
        if ($IsComplete) {
            $shouldStop = [bool](& $IsComplete $response $pageIndex $cursor)
        }

        if ($shouldStop) {
            break
        }

        if ($GetNextCursor) {
            $cursor = & $GetNextCursor $response
        }
        else {
            $cursor = $null
        }

        if (-not $GetNextCursor -and -not $IsComplete) {
            break
        }

        if ($PollSeconds -gt 0) {
            Start-Sleep -Seconds $PollSeconds
        }

        $previousResponse = $response
        $pageIndex++
    }

    return $results
}
