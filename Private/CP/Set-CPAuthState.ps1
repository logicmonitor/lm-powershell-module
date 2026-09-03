function Set-CPAuthState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [SecureString]$BearerToken,

        [String]$AccountName,

        [String]$ApiBaseUrl = 'https://io.catchpoint.com/api',

        [ValidateSet('Bearer', 'Cached')]
        [String]$Type = 'Bearer',

        [Boolean]$Logging = $true
    )

    $Script:CPAuth = [PSCustomObject]@{
        AccountName = $AccountName
        BearerToken = $BearerToken
        PortalUrl   = $ApiBaseUrl.TrimEnd('/')
        Valid       = $true
        Type        = $Type
        Logging     = $Logging
    }
}
