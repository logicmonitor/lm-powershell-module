function Join-CPUri {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$PortalUrl,

        [Parameter(Mandatory)]
        [String]$ResourcePath,

        [String]$QueryString
    )

    $base = $PortalUrl.TrimEnd('/')
    if (-not $ResourcePath.StartsWith('/')) {
        $ResourcePath = "/$ResourcePath"
    }

    $uri = "$base$ResourcePath"
    if (-not [string]::IsNullOrWhiteSpace($QueryString)) {
        $uri = "${uri}?$($QueryString.TrimStart('?'))"
    }

    return $uri
}
