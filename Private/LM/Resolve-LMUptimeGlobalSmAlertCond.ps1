function Resolve-LMUptimeGlobalSmAlertCond {

    [CmdletBinding()]
    param (
        [String]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    switch ($Value.ToLower()) {
        'all' { return 0 }
        'half' { return 1 }
        'morethanone' { return 2 }
        'any' { return 3 }
        default { throw "GlobalSmAlertCond must be one of: all, half, moreThanOne, any." }
    }
}

