function New-CPQueryString {
    [CmdletBinding()]
    param(
        [Hashtable]$Parameters
    )

    if (-not $Parameters -or $Parameters.Count -eq 0) {
        return ''
    }

    $parts = foreach ($key in ($Parameters.Keys | Sort-Object)) {
        $value = $Parameters[$key]
        if ($null -eq $value) {
            continue
        }

        if ($value -is [string] -and [string]::IsNullOrWhiteSpace($value)) {
            continue
        }

        if ($value -is [System.Collections.IEnumerable] -and $value -isnot [string]) {
            $items = @($value | Where-Object { $null -ne $_ -and -not [string]::IsNullOrWhiteSpace([string]$_) })
            if ($items.Count -eq 0) {
                continue
            }

            $value = $items -join ','
        }
        elseif ($value -is [bool]) {
            $value = if ($value) { 'true' } else { 'false' }
        }

        $encodedKey = [System.Uri]::EscapeDataString([string]$key)
        $encodedValue = [System.Uri]::EscapeDataString([string]$value)
        "${encodedKey}=${encodedValue}"
    }

    return ($parts -join '&')
}
