function Get-CPBearerToken {
    <#
    .SYNOPSIS
    Returns the Catchpoint REST API v2 bearer token from the current auth state.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject]$Auth
    )

    if (-not $Auth.BearerToken) {
        throw 'Catchpoint auth state is missing a BearerToken. Use Connect-CPAccount and try again.'
    }

    return [System.Net.NetworkCredential]::new('', $Auth.BearerToken).Password
}
