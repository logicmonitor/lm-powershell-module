<#
.SYNOPSIS
Safely determines whether an API response is paginated.

.DESCRIPTION
The Test-LMResponseHasPagination function checks if a response object includes
the standard LogicMonitor pagination properties (`total` and optionally `items`)
without throwing when the response is null or property access would fail.

.PARAMETER Response
The API response object to inspect.

.OUTPUTS
System.Boolean
#>
function Test-LMResponseHasPagination {
    [CmdletBinding()]
    param (
        [AllowNull()]
        [Object]$Response
    )

    if ($null -eq $Response) {
        return $false
    }

    try {
        $totalProperty = $Response.psobject.Properties["total"]
        if (-not [bool]$totalProperty) {
            return $false
        }

        $parsedTotal = 0
        if (-not [int]::TryParse([string]$totalProperty.Value, [ref]$parsedTotal)) {
            return $false
        }

        return $parsedTotal -ge 0
    }
    catch {
        return $false
    }
}
