function Test-CPConnection {
    <#
    .SYNOPSIS
    Validates a Catchpoint REST API v2 bearer token.

    .DESCRIPTION
    GETs /v2/products with the supplied bearer token. A successful response
    confirms the token is accepted by the Catchpoint API.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [SecureString]$BearerToken,

        [Parameter(Mandatory)]
        [String]$ApiBaseUrl,

        [System.Management.Automation.PSCmdlet]$CallerPSCmdlet
    )

    $auth = [PSCustomObject]@{
        BearerToken = $BearerToken
        PortalUrl   = $ApiBaseUrl
    }
    $uri = Join-CPUri -PortalUrl $ApiBaseUrl -ResourcePath '/v2/products'
    $headers = New-CPHeader -Auth $auth -Method GET
    if ($headers.ContainsKey('__CPMethod')) {
        $headers.Remove('__CPMethod') | Out-Null
    }

    try {
        $null = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        return $true
    }
    catch {
        if ($_.Exception -is [CPException] -or $_.FullyQualifiedErrorId -like 'CP.*') {
            throw $_
        }

        $errorDetails = Get-CPHttpErrorDetails -ErrorRecord $_
        $resolvedError = Resolve-CPException -StatusCode $errorDetails.StatusCode -ResponseBody $errorDetails.Body

        if ($errorDetails.StatusCode -eq 401) {
            $traceIdSuffix = ''
            if (-not [string]::IsNullOrWhiteSpace($errorDetails.Body)) {
                try {
                    $parsed = $errorDetails.Body | ConvertFrom-Json -ErrorAction Stop
                    if ($null -ne $parsed.PSObject.Properties['traceId'] -and -not [string]::IsNullOrWhiteSpace([string]$parsed.traceId)) {
                        $traceIdSuffix = " (trace id: $($parsed.traceId))"
                    }
                }
                catch {
                }
            }

            $resolvedError.Message = "Invalid Catchpoint credentials. Verify the BearerToken from the Catchpoint portal API settings.$traceIdSuffix"
        }

        $errorRecord = New-CPErrorRecord -ResolvedError $resolvedError -Uri $uri

        if ($CallerPSCmdlet) {
            $CallerPSCmdlet.ThrowTerminatingError($errorRecord)
        }

        throw $errorRecord
    }
}
