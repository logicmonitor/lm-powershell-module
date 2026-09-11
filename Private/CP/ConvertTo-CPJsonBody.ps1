function ConvertTo-CPJsonBody {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $InputObject
    )

    if ($InputObject -is [string]) {
        return $InputObject
    }

    return ($InputObject | ConvertTo-Json -Depth 20 -Compress)
}
