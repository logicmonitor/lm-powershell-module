class EAIException : System.Exception {
    EAIException([string]$message) : base($message) { }
    EAIException([string]$message, [System.Exception]$innerException) : base($message, $innerException) { }
}

function Format-EAIErrorMessage {
    [CmdletBinding()]
    param(
        [String]$ResponseBody,

        [Nullable[int]]$StatusCode
    )

    if ([string]::IsNullOrWhiteSpace($ResponseBody)) {
        if ($StatusCode) {
            return "Edwin API request failed with HTTP status $StatusCode."
        }

        return 'Edwin API request failed.'
    }

    try {
        $parsed = $ResponseBody | ConvertFrom-Json -ErrorAction Stop
        $code = if ($null -ne $parsed.PSObject.Properties['code']) { $parsed.code }
        elseif ($null -ne $parsed.PSObject.Properties['status_code']) { $parsed.status_code }
        elseif ($StatusCode) { $StatusCode }
        else { 'Error' }

        $message = if ($null -ne $parsed.PSObject.Properties['message']) { [string]$parsed.message } else { $null }
        $traceId = if ($null -ne $parsed.PSObject.Properties['id'] -and -not [string]::IsNullOrWhiteSpace([string]$parsed.id)) {
            [string]$parsed.id
        }
        else {
            $null
        }

        $formattedMessage = $null

        if ($parsed.errors) {
            $details = if ($parsed.errors -is [System.Array]) {
                ($parsed.errors | ForEach-Object { [string]$_ }) -join '; '
            }
            else {
                [string]$parsed.errors
            }

            if ($message) {
                $formattedMessage = "${code}: ${message} [$details]"
            }
            else {
                $formattedMessage = "${code}: $details"
            }
        }
        elseif ($message) {
            $formattedMessage = "${code}: ${message}"
        }

        if ($formattedMessage) {
            if ($traceId) {
                $formattedMessage = "$formattedMessage (trace id: $traceId)"
            }

            return $formattedMessage
        }
    }
    catch {
        return $ResponseBody
    }

    return $ResponseBody
}

function Resolve-EAIException {
    [CmdletBinding()]
    param(
        [Nullable[int]]$StatusCode,

        [String]$ResponseBody
    )

    $message = Format-EAIErrorMessage -ResponseBody $ResponseBody -StatusCode $StatusCode
    $result = [PSCustomObject]@{
        Message     = $message
        ErrorType   = 'ClientError'
        ErrorId     = 'EAI.ClientError'
        Category    = [System.Management.Automation.ErrorCategory]::InvalidOperation
        ShouldRetry = $false
    }

    switch ($StatusCode) {
        401 {
            $result.ErrorType = 'AuthenticationError'
            $result.ErrorId = 'EAI.AuthenticationError'
            $result.Category = [System.Management.Automation.ErrorCategory]::AuthenticationError
            if ($message -notmatch 'Connect-EAIAccount') {
                $result.Message = "$message Verify your EdwinOrg, ClientId, and ClientSecret with Connect-EAIAccount."
            }
        }
        403 {
            $result.ErrorType = 'AuthorizationError'
            $result.ErrorId = 'EAI.AuthorizationError'
            $result.Category = [System.Management.Automation.ErrorCategory]::PermissionDenied
        }
        422 {
            $result.ErrorType = 'PayloadValidationError'
            $result.ErrorId = 'EAI.PayloadValidationError'
            $result.Category = [System.Management.Automation.ErrorCategory]::InvalidData
        }
        { $_ -ge 500 } {
            $result.ErrorType = 'ServerError'
            $result.ErrorId = 'EAI.ServerError'
            $result.Category = [System.Management.Automation.ErrorCategory]::ResourceUnavailable
            $result.ShouldRetry = $true
        }
    }

    return $result
}

function Get-EAIHttpErrorDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )

    $statusCode = $null
    $responseBody = $null

    if ($ErrorRecord.ErrorDetails -and $ErrorRecord.ErrorDetails.Message) {
        $responseBody = $ErrorRecord.ErrorDetails.Message
    }

    $response = $ErrorRecord.Exception.Response
    if ($response) {
        if ($response -is [System.Net.Http.HttpResponseMessage]) {
            $statusCode = [int]$response.StatusCode
            if (-not $responseBody -and $response.Content) {
                $responseBody = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
            }
        }
        elseif ($response -is [System.Net.HttpWebResponse]) {
            $statusCode = [int]$response.StatusCode
            if (-not $responseBody) {
                $reader = [System.IO.StreamReader]::new($response.GetResponseStream())
                try {
                    $responseBody = $reader.ReadToEnd()
                }
                finally {
                    $reader.Dispose()
                }
            }
        }
        else {
            try {
                $statusCode = [int]$response.StatusCode
            }
            catch {
                $statusCode = $null
            }
        }
    }

    if (-not $responseBody) {
        $responseBody = $ErrorRecord.Exception.Message
    }

    return [PSCustomObject]@{
        StatusCode = $statusCode
        Body       = $responseBody
    }
}

function New-EAIErrorRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $ResolvedError,

        [Parameter(Mandatory)]
        [String]$Uri
    )

    return [System.Management.Automation.ErrorRecord]::new(
        [EAIException]::new($ResolvedError.Message),
        $ResolvedError.ErrorId,
        $ResolvedError.Category,
        $Uri
    )
}

function Invoke-EAIRestMethod {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$Uri,

        [Parameter(Mandatory)]
        [ValidateSet('GET', 'POST', 'PATCH', 'PUT', 'DELETE')]
        [String]$Method,

        [Parameter(Mandatory)]
        [Hashtable]$Headers,

        [Parameter(Mandatory)]
        [PSCustomObject]$Auth,

        [String]$Body,

        [ValidateRange(1, 10)]
        [Int]$MaxRetries = 3,

        [Switch]$EnableDebugLogging,

        [System.Management.Automation.PSCmdlet]$CallerPSCmdlet
    )

    $headers = @{} + $Headers
    if ($headers.ContainsKey('__EAIMethod')) {
        $headers.Remove('__EAIMethod') | Out-Null
    }

    if ($headers.ContainsKey('Authorization')) {
        $headers.Remove('Authorization') | Out-Null
    }

    $credential = [PSCredential]::new($Auth.ClientId, $Auth.ClientSecret)
    $useBasicAuthentication = $PSVersionTable.PSVersion.Major -ge 7
    $retryBackoff = 5
    $attempt = 0
    $lastResolvedError = $null

    while ($attempt -lt $MaxRetries) {
        $attempt++
        try {
            $params = @{
                Uri         = $Uri
                Method      = $Method
                Headers     = $headers
                TimeoutSec  = 30
                ErrorAction = 'Stop'
            }

            if ($useBasicAuthentication) {
                $params.Authentication = 'Basic'
                $params.Credential = $credential
            }
            else {
                $clientSecret = [System.Net.NetworkCredential]::new('', $Auth.ClientSecret).Password
                $token = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("$($Auth.ClientId):$clientSecret"))
                $params.Headers['Authorization'] = "Basic $token"
            }

            if ($Body) {
                $params.Body = $Body
            }

            if ($EnableDebugLogging) {
                Write-Debug "Attempt ${attempt}: $Method $Uri"
                if ($Body -and $Body.Length -lt 1000) {
                    Write-Debug "Request Body: $Body"
                }
            }

            $response = Invoke-RestMethod @params

            if ($EnableDebugLogging) {
                Write-Debug "Request successful on attempt $attempt"
            }

            return $response
        }
        catch {
            if ($_.Exception -is [EAIException] -or $_.FullyQualifiedErrorId -like 'EAI.*') {
                throw $_
            }

            $errorDetails = Get-EAIHttpErrorDetails -ErrorRecord $_
            $resolvedError = Resolve-EAIException -StatusCode $errorDetails.StatusCode -ResponseBody $errorDetails.Body
            $lastResolvedError = $resolvedError

            if ($resolvedError.ShouldRetry -and $attempt -lt $MaxRetries) {
                if ($EnableDebugLogging -or $VerbosePreference -ne 'SilentlyContinue') {
                    Write-Verbose "Edwin API request failed ($($resolvedError.ErrorType)), retrying (attempt $attempt of $MaxRetries)"
                }

                Start-Sleep -Seconds ($retryBackoff * $attempt)
                continue
            }

            if ($errorDetails.StatusCode -ge 400 -and $errorDetails.StatusCode -lt 500) {
                $errorRecord = New-EAIErrorRecord -ResolvedError $resolvedError -Uri $Uri
                if ($CallerPSCmdlet) {
                    $CallerPSCmdlet.ThrowTerminatingError($errorRecord)
                }

                throw $errorRecord
            }

            if ($attempt -ge $MaxRetries) {
                break
            }

            if ($EnableDebugLogging -or $VerbosePreference -ne 'SilentlyContinue') {
                Write-Verbose "Edwin API request failed ($($resolvedError.ErrorType)), retrying (attempt $attempt of $MaxRetries)"
            }

            Start-Sleep -Seconds ($retryBackoff * $attempt)
        }
    }

    $finalResolvedError = if ($lastResolvedError) {
        $lastResolvedError
    }
    else {
        Resolve-EAIException -StatusCode $null -ResponseBody 'Maximum Edwin API retry attempts exhausted.'
    }

    $finalError = New-EAIErrorRecord -ResolvedError $finalResolvedError -Uri $Uri

    if ($CallerPSCmdlet) {
        $CallerPSCmdlet.ThrowTerminatingError($finalError)
    }

    throw $finalError
}
