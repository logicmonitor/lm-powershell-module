function Get-EAIBearerToken {
    <#
    .SYNOPSIS
    Returns a valid Bearer token, refreshing when needed.

    .DESCRIPTION
    Returns the cached access token when it expires more than 60 seconds from now.
    Otherwise requests a new token and updates auth state.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject]$Auth,

        [Switch]$ForceRefresh,

        [System.Management.Automation.PSCmdlet]$CallerPSCmdlet
    )

    $refreshBufferSeconds = 60
    $now = (Get-Date).ToUniversalTime()

    if (-not $ForceRefresh -and $Auth.AccessToken -and $Auth.TokenExpiresAt) {
        if ($now.AddSeconds($refreshBufferSeconds) -lt $Auth.TokenExpiresAt) {
            return [System.Net.NetworkCredential]::new('', $Auth.AccessToken).Password
        }
    }

    $tokenResult = Request-EAIAccessToken -EdwinOrg $Auth.EdwinOrg -ClientId $Auth.ClientId -ClientSecret $Auth.ClientSecret -CallerPSCmdlet $CallerPSCmdlet

    $Auth.AccessToken = $tokenResult.AccessToken
    $Auth.TokenExpiresAt = $tokenResult.ExpiresAt

    if ($Script:EAIAuth -and $Script:EAIAuth -eq $Auth) {
        $Script:EAIAuth.AccessToken = $tokenResult.AccessToken
        $Script:EAIAuth.TokenExpiresAt = $tokenResult.ExpiresAt
    }

    return [System.Net.NetworkCredential]::new('', $tokenResult.AccessToken).Password
}
