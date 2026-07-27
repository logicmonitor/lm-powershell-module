function Test-EAIEventPayload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Event
    )

    $requiredCefFields = @(
        'event_ci',
        'event_object',
        'event_source',
        'event_name',
        'event_description',
        'event_severity',
        'event_time',
        'event_id',
        'source_record',
        'event_domain'
    )

    if ($Event -is [System.Collections.IDictionary]) {
        $eventObject = $Event
    }
    elseif ($Event -is [PSCustomObject]) {
        $eventObject = @{}
        foreach ($property in $Event.PSObject.Properties) {
            $eventObject[$property.Name] = $property.Value
        }
    }
    else {
        throw 'Each event must be a hashtable or PSCustomObject containing cef and enrichments properties.'
    }

    if (-not $eventObject.Contains('cef') -or $null -eq $eventObject['cef']) {
        throw 'Each event must include a cef property.'
    }

    $cef = $eventObject['cef']
    if ($cef -is [PSCustomObject]) {
        $cefHash = @{}
        foreach ($property in $cef.PSObject.Properties) {
            $cefHash[$property.Name] = $property.Value
        }
        $cef = $cefHash
    }

    if (-not $cef.Contains('class') -or [string]::IsNullOrWhiteSpace([string]$cef['class'])) {
        $cef['class'] = 'event'
    }

    if (-not $cef.Contains('version') -or [string]::IsNullOrWhiteSpace([string]$cef['version'])) {
        $cef['version'] = '1.1'
    }

    foreach ($field in $requiredCefFields) {
        if (-not $cef.Contains($field)) {
            throw "CEF payload is missing required field '$field'."
        }

        if ($field -eq 'event_domain') {
            continue
        }

        if ($null -eq $cef[$field] -or ([string]$cef[$field]).Length -eq 0) {
            throw "CEF payload field '$field' cannot be null or empty."
        }
    }

    $cef['event_severity'] = Get-EAISeverityValue -Value $cef['event_severity']
    $cef['event_time'] = Format-EAIEventTime -DateTime $cef['event_time']

    $optionalCefFields = @(
        'event_details',
        'event_ci_link',
        'event_name_link',
        'event_source_id',
        'event_source_id_link'
    )

    foreach ($field in $optionalCefFields) {
        if ($cef.Contains($field) -and ($null -eq $cef[$field] -or ([string]$cef[$field]).Length -eq 0)) {
            $cef.Remove($field) | Out-Null
        }
    }

    if (-not $eventObject.Contains('enrichments') -or $null -eq $eventObject['enrichments']) {
        $eventObject['enrichments'] = @{}
    }

    $eventObject['cef'] = $cef
    return [pscustomobject]$eventObject
}
