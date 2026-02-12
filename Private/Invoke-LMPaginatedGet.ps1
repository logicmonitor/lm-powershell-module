<#
.SYNOPSIS
Centralized pagination runner for LogicMonitor GET requests.

.DESCRIPTION
Invoke-LMPaginatedGet centralizes common pagination behavior used by many
Get-LM cmdlets. It executes a caller-supplied request scriptblock for each
offset, safely handles null responses, and aggregates paged items.
Callers should capture `$PSCmdlet` before invoking this helper and pass that
captured reference to `Invoke-LMRestMethod -CallerPSCmdlet` inside InvokeRequest.

.PARAMETER InvokeRequest
A scriptblock that accepts two arguments: offset and batch size, and returns
the API response for that page.

.PARAMETER BatchSize
The page size to request. Defaults to 1000.

.PARAMETER SingleObjectWhenNotPaged
When set, a non-paged response is returned directly as a single object.
Otherwise, a non-paged response is returned as a single-item array.

.PARAMETER NormalizeEmptyToArray
When set, paged responses with no items return @() instead of $null.

.PARAMETER ExtractResponse
Optional scriptblock that can transform nested response shapes before pagination
logic is evaluated. The scriptblock receives one argument: the raw response.

.PARAMETER MaxItems
Optional cap on total items to retrieve. When reached, pagination stops and
$MaxItemsWarningMessage is written as a warning if supplied.

.PARAMETER MaxItemsWarningMessage
Warning message to emit when MaxItems cap is reached. Ignored if MaxItems is not set.

.OUTPUTS
Object
#>
function Invoke-LMPaginatedGet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ScriptBlock]$InvokeRequest,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000,

        [Switch]$SingleObjectWhenNotPaged,

        [Switch]$NormalizeEmptyToArray,

        [ScriptBlock]$ExtractResponse,

        [Int]$MaxItems = 0,

        [String]$MaxItemsWarningMessage
    )

    $offset = 0
    $results = @()

    while ($true) {
        $response = & $InvokeRequest $offset $BatchSize
        if ($ExtractResponse) {
            $response = & $ExtractResponse $response
        }

        if ($null -eq $response) {
            return $null
        }

        if (!(Test-LMResponseHasPagination -Response $response)) {
            if ($SingleObjectWhenNotPaged) {
                return $response
            }
            return @($response)
        }

        $items = @($response.Items)
        if ($items.Count -eq 0 -and $NormalizeEmptyToArray) {
            return @()
        }
        if ($items.Count -eq 0) {
            # Avoid infinite loops when an endpoint reports pagination but no items.
            return $results
        }

        if ($MaxItems -gt 0) {
            $remaining = $MaxItems - $results.Count
            if ($remaining -le 0) {
                if ($MaxItemsWarningMessage) {
                    Write-Warning $MaxItemsWarningMessage
                }
                break
            }

            if ($items.Count -ge $remaining) {
                $results += $items[0..($remaining - 1)]
                if ($MaxItemsWarningMessage) {
                    Write-Warning $MaxItemsWarningMessage
                }
                break
            }
        }

        $results += $items
        $offset += $items.Count

        if ($offset -ge [int]$response.Total) {
            break
        }
    }

    return $results
}
