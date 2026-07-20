function Get-EAISeverityValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Value,

        [Hashtable]$SeverityMap
    )

    if ($null -eq $Value) {
        return 1
    }

    if ($Value -is [int] -or $Value -is [long] -or $Value -is [decimal]) {
        return [int]$Value
    }

    $normalized = [string]$Value
    if ($normalized -match '^\d+$') {
        return [int]$normalized
    }

    $defaultSeverityMap = @{
        'critical'      = 5
        'major'         = 4
        'minor'         = 3
        'warning'       = 2
        'indeterminate' = 1
        'clear'         = 0
    }

    if ($SeverityMap) {
        foreach ($entry in $SeverityMap.GetEnumerator()) {
            $targetSeverity = switch ($entry.Key.ToString().ToLowerInvariant()) {
                'critical' { 5 }
                'major' { 4 }
                'minor' { 3 }
                'warning' { 2 }
                'indeterminate' { 1 }
                'clear' { 0 }
                default { [int]$entry.Key }
            }

            foreach ($alias in @($entry.Value)) {
                if ([string]$alias -eq $normalized) {
                    return $targetSeverity
                }
            }
        }
    }

    $lower = $normalized.ToLowerInvariant()
    if ($defaultSeverityMap.ContainsKey($lower)) {
        return $defaultSeverityMap[$lower]
    }

    return 1
}

function Convert-EAIEventCore {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject,

        [Parameter(Mandatory)]
        [Hashtable]$PropertyMap,

        [Hashtable]$SeverityMap,

        [String]$DefaultEventSource
    )

    process {
        $cef = [ordered]@{}
        $enrichments = [ordered]@{}

        foreach ($entry in $PropertyMap.GetEnumerator()) {
            $targetField = $entry.Key
            $mapping = $entry.Value
            $resolvedValue = $null

            if ($mapping -is [scriptblock]) {
                $resolvedValue = & $mapping $InputObject
            }
            elseif ($mapping -is [string] -and $mapping.StartsWith('enrichment:')) {
                $enrichmentKey = $mapping.Substring('enrichment:'.Length)
                if ($InputObject -is [System.Collections.IDictionary]) {
                    $resolvedValue = $InputObject[$enrichmentKey]
                }
                else {
                    $resolvedValue = $InputObject.$enrichmentKey
                }

                if ($null -ne $resolvedValue -and $resolvedValue -ne '') {
                    $enrichments[$targetField] = $resolvedValue
                }
                continue
            }
            elseif ($mapping -is [string]) {
                if ($InputObject -is [System.Collections.IDictionary]) {
                    $resolvedValue = $InputObject[$mapping]
                }
                else {
                    $resolvedValue = $InputObject.$mapping
                }
            }
            else {
                $resolvedValue = $mapping
            }

            if ($targetField -eq 'event_severity') {
                $resolvedValue = Get-EAISeverityValue -Value $resolvedValue -SeverityMap $SeverityMap
            }

            if ($null -ne $resolvedValue -and $resolvedValue -ne '') {
                $cef[$targetField] = $resolvedValue
            }
        }

        if (-not $cef.Contains('event_source') -and $DefaultEventSource) {
            $cef['event_source'] = $DefaultEventSource
        }

        if (-not $cef.Contains('event_id')) {
            $cef['event_id'] = [guid]::NewGuid().ToString()
        }

        if (-not $cef.Contains('event_time')) {
            $cef['event_time'] = Format-EAIEventTime -DateTime (Get-Date)
        }

        if (-not $cef.Contains('event_severity')) {
            $cef['event_severity'] = 1
        }

        if (-not $cef.Contains('event_domain')) {
            $cef['event_domain'] = ''
        }

        if (-not $cef.Contains('source_record')) {
            if ($InputObject -is [System.Collections.IDictionary]) {
                $cef['source_record'] = [ordered]@{}
                foreach ($key in $InputObject.Keys) {
                    $cef['source_record'][$key] = $InputObject[$key]
                }
            }
            else {
                $cef['source_record'] = $InputObject
            }
        }

        $cef['class'] = 'event'
        $cef['version'] = '1.1'

        [PSCustomObject]@{
            cef         = [pscustomobject]$cef
            enrichments = [pscustomobject]$enrichments
        }
    }
}
