function Test-EAIConnection {
    <#
    .SYNOPSIS
    Validates Edwin credentials by posting an empty event array.

    .DESCRIPTION
    Edwin has no dedicated health endpoint. POSTing an empty array to
    /integration/event/v1 returns HTTP 400 when credentials are valid and
    HTTP 401 when they are not.
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

    $uri = Join-EAIUri -PortalUrl "https://$EdwinOrg.dexda.ai" -ResourcePath '/integration/event/v1'
    $credential = [PSCredential]::new($ClientId, $ClientSecret)
    $headers = @{
        Accept         = 'application/json'
        'Content-Type' = 'application/json'
    }
    $useBasicAuthentication = $PSVersionTable.PSVersion.Major -ge 7

    $params = @{
        Uri         = $uri
        Method      = 'POST'
        Body        = '[]'
        Headers     = $headers
        TimeoutSec  = 30
        ErrorAction = 'Stop'
    }

    if ($useBasicAuthentication) {
        $params.Authentication = 'Basic'
        $params.Credential = $credential
    }
    else {
        $clientSecretPlain = [System.Net.NetworkCredential]::new('', $ClientSecret).Password
        $token = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("$ClientId`:$clientSecretPlain"))
        $params.Headers['Authorization'] = "Basic $token"
    }

    try {
        Invoke-RestMethod @params | Out-Null
        return
    }
    catch {
        $errorDetails = Get-EAIHttpErrorDetails -ErrorRecord $_

        if ($errorDetails.StatusCode -eq 400) {
            return
        }

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
