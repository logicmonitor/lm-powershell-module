function Join-EAIUri {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$PortalUrl,

        [Parameter(Mandatory)]
        [String]$ResourcePath
    )

    $base = $PortalUrl.TrimEnd('/')
    if (-not $ResourcePath.StartsWith('/')) {
        $ResourcePath = "/$ResourcePath"
    }

    return "$base$ResourcePath"
}
