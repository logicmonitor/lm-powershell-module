function ConvertTo-LMCustomPropertyArray {
    [CmdletBinding()]
    param (
        [Object]$Properties
    )

    $customProperties = @()

    if (-not $Properties) {
        return @()
    }

    if ($Properties -is [Hashtable] -or $Properties -is [System.Collections.IDictionary]) {
        foreach ($key in ($Properties.Keys | Sort-Object)) {
            if ($null -eq $key -or [string]::IsNullOrWhiteSpace([string]$key)) {
                continue
            }

            $customProperties += @{
                name  = [string]$key
                value = $Properties[$key]
            }
        }
        if ($customProperties.Count -eq 0) { return @() }
        return ,$customProperties
    }

    if ($Properties -is [System.Collections.IEnumerable] -and -not ($Properties -is [string])) {
        foreach ($item in $Properties) {
            if (-not $item) { continue }

            $name = $null
            $value = $null

            if ($item -is [Hashtable] -or $item -is [System.Collections.IDictionary]) {
                $name = $item['name']
                $value = $item['value']
            }
            elseif ($item -is [PSCustomObject]) {
                $name = $item.name
                $value = $item.value
            }

            if ([string]::IsNullOrWhiteSpace([string]$name)) { continue }

            $customProperties += @{
                name  = [string]$name
                value = $value
            }
        }

        if ($customProperties.Count -eq 0) { return @() }
        return ,$customProperties
    }

    throw "Unsupported property format. Provide a hashtable or an array of name/value objects."
}

