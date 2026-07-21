function Request-EAIAccessToken {
    <#
    .SYNOPSIS
    Exchanges Edwin client credentials for a Bearer access token.

    .DESCRIPTION
    POSTs to /auth/token using OAuth2 client_credentials grant.
    Does not use Invoke-EAIRestMethod to avoid circular authentication.
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Required to store API access tokens securely')]
    param(
        [Parameter(Mandatory)]
        [String]$EdwinOrg,

        [Parameter(Mandatory)]
        [String]$ClientId,

        [Parameter(Mandatory)]
        [SecureString]$ClientSecret,

        [System.Management.Automation.PSCmdlet]$CallerPSCmdlet
    )

    $uri = "https://$EdwinOrg.dexda.ai/auth/token"
    $clientSecretPlain = [System.Net.NetworkCredential]::new('', $ClientSecret).Password
    $body = "grant_type=client_credentials&client_id=$([uri]::EscapeDataString($ClientId))&client_secret=$([uri]::EscapeDataString($clientSecretPlain))"

    try {
        $response = Invoke-RestMethod -Uri $uri -Method POST -Body $body -ContentType 'application/x-www-form-urlencoded' -TimeoutSec 30 -ErrorAction Stop

        if ([string]::IsNullOrWhiteSpace($response.access_token)) {
            throw 'Edwin token response did not include an access_token.'
        }

        $expiresAt = $null
        if ($null -ne $response.PSObject.Properties['expires_at'] -and $response.expires_at) {
            $expiresAt = [DateTimeOffset]::FromUnixTimeMilliseconds([long]$response.expires_at).UtcDateTime
        }
        else {
            $expiresIn = 1800
            if ($null -ne $response.PSObject.Properties['expires_in'] -and $response.expires_in) {
                $expiresIn = [int]$response.expires_in
            }

            $expiresAt = (Get-Date).ToUniversalTime().AddSeconds($expiresIn)
        }

        return [PSCustomObject]@{
            AccessToken = ($response.access_token | ConvertTo-SecureString -AsPlainText -Force)
            ExpiresAt   = $expiresAt
        }
    }
    catch {
        if ($_.Exception -is [EAIException] -or $_.FullyQualifiedErrorId -like 'EAI.*') {
            throw $_
        }

        $errorDetails = Get-EAIHttpErrorDetails -ErrorRecord $_
        $resolvedError = Resolve-EAIException -StatusCode $errorDetails.StatusCode -ResponseBody $errorDetails.Body

        if ($errorDetails.StatusCode -eq 401) {
            $traceIdSuffix = ''
            if (-not [string]::IsNullOrWhiteSpace($errorDetails.Body)) {
                try {
                    $parsed = $errorDetails.Body | ConvertFrom-Json -ErrorAction Stop
                    if ($null -ne $parsed.PSObject.Properties['id'] -and -not [string]::IsNullOrWhiteSpace([string]$parsed.id)) {
                        $traceIdSuffix = " (trace id: $($parsed.id))"
                    }
                }
                catch {
                }
            }

            $resolvedError.Message = "Invalid Edwin credentials for portal '$EdwinOrg'. Verify EdwinOrg, ClientId, and ClientSecret.$traceIdSuffix"
        }

        $errorRecord = New-EAIErrorRecord -ResolvedError $resolvedError -Uri $uri

        if ($CallerPSCmdlet) {
            $CallerPSCmdlet.ThrowTerminatingError($errorRecord)
        }

        throw $errorRecord
    }
}
