<#
.SYNOPSIS
Centralized v4 body-offset pagination runner for LogicMonitor POST requests.

.DESCRIPTION
Invoke-LMPaginatedPostV4 executes a caller-supplied request scriptblock for each
pageOffsetCount/perPageCount step and aggregates extracted items.

.PARAMETER InvokeRequest
A scriptblock that accepts two arguments: page offset count and page size, and
returns the API response for that page.

.PARAMETER ExtractItems
A scriptblock that receives one argument (the raw response) and returns the
item collection for that response page.

.PARAMETER BatchSize
Page size to request. Defaults to 1000.

.PARAMETER StopWhen
Optional scriptblock that receives three arguments (response, items, offset)
and returns $true when pagination should stop.

.OUTPUTS
Object[]
#>
function Invoke-LMPaginatedPostV4 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ScriptBlock]$InvokeRequest,

        [Parameter(Mandatory)]
        [ScriptBlock]$ExtractItems,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000,

        [ScriptBlock]$StopWhen
    )

    $offset = 0
    $results = @()

    while ($true) {
        $response = & $InvokeRequest $offset $BatchSize
        if ($null -eq $response) {
            if ($results.Count -eq 0) {
                return $null
            }
            break
        }

        $items = @(& $ExtractItems $response)
        if ($items.Count -eq 0) {
            break
        }

        $results += $items
        $offset += $items.Count

        if ($StopWhen -and (& $StopWhen $response $items $offset)) {
            break
        }

        if ($items.Count -lt $BatchSize) {
            break
        }
    }

    return $results
}
