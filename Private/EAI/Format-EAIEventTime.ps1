function Format-EAIEventTime {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        $DateTime
    )

    if ($DateTime -is [string]) {
        if ($DateTime -match '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{5}Z$') {
            return $DateTime
        }

        $DateTime = [datetime]::Parse(
            $DateTime,
            [System.Globalization.CultureInfo]::InvariantCulture,
            [System.Globalization.DateTimeStyles]::RoundtripKind
        )
    }

    $utc = $DateTime.ToUniversalTime()
    $fractional = $utc.ToString('ffffff').Substring(0, 5)

    return '{0}.{1}Z' -f $utc.ToString('yyyy-MM-ddTHH:mm:ss'), $fractional
}
