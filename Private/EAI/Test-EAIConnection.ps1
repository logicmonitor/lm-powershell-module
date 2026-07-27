function Test-EAIConnection {
    <#
    .SYNOPSIS
    Validates Edwin credentials by requesting an OAuth2 access token.

    .DESCRIPTION
    POSTs client credentials to /auth/token. A successful token grant confirms
    that EdwinOrg, ClientId, and ClientSecret are valid.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$EdwinOrg,

        [Parameter(Mandatory)]
        [String]$ClientId,

        [Parameter(Mandatory)]
        [SecureString]$ClientSecret,

        [System.Management.Automation.PSCmdlet]$CallerPSCmdlet
    )

    return Request-EAIAccessToken -EdwinOrg $EdwinOrg -ClientId $ClientId -ClientSecret $ClientSecret -CallerPSCmdlet $CallerPSCmdlet
}
