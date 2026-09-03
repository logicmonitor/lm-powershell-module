class CPException : System.Exception {
    CPException([string]$message) : base($message) { }
    CPException([string]$message, [System.Exception]$innerException) : base($message, $innerException) { }
}

function Format-CPErrorMessage {
    [CmdletBinding()]
    param(
        [String]$ResponseBody,

        [Nullable[int]]$StatusCode
    )

    if ([string]::IsNullOrWhiteSpace($ResponseBody)) {
        if ($StatusCode) {
            return "Catchpoint API request failed with HTTP status $StatusCode."
        }

        return 'Catchpoint API request failed.'
    }

    try {
        $parsed = $ResponseBody | ConvertFrom-Json -ErrorAction Stop
        $traceId = $null
        if ($null -ne $parsed.PSObject.Properties['traceId'] -and -not [string]::IsNullOrWhiteSpace([string]$parsed.traceId)) {
            $traceId = [string]$parsed.traceId
        }

        $errorMessages = @()
        if ($parsed.errors) {
            $errorMessages = @(
                $parsed.errors | ForEach-Object {
                    if ($null -ne $_.PSObject.Properties['message'] -and -not [string]::IsNullOrWhiteSpace([string]$_.message)) {
                        [string]$_.message
                    }
                    else {
                        [string]$_
                    }
                }
            )
        }

        $message = $null
        if ($null -ne $parsed.PSObject.Properties['message'] -and -not [string]::IsNullOrWhiteSpace([string]$parsed.message)) {
            $message = [string]$parsed.message
        }

        $code = if ($StatusCode) { $StatusCode } else { 'Error' }
        $formattedMessage = $null

        if ($errorMessages.Count -gt 0) {
            $details = $errorMessages -join '; '
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

function Resolve-CPException {
    [CmdletBinding()]
    param(
        [Nullable[int]]$StatusCode,

        [String]$ResponseBody
    )

    $message = Format-CPErrorMessage -ResponseBody $ResponseBody -StatusCode $StatusCode
    $result = [PSCustomObject]@{
        Message     = $message
        ErrorType   = 'ClientError'
        ErrorId     = 'CP.ClientError'
        Category    = [System.Management.Automation.ErrorCategory]::InvalidOperation
        ShouldRetry = $false
    }

    switch ($StatusCode) {
        400 {
            $result.ErrorType = 'ClientError'
            $result.ErrorId = 'CP.ClientError'
            $result.Category = [System.Management.Automation.ErrorCategory]::InvalidArgument
        }
        401 {
            $result.ErrorType = 'AuthenticationError'
            $result.ErrorId = 'CP.AuthenticationError'
            $result.Category = [System.Management.Automation.ErrorCategory]::AuthenticationError
            if ($message -notmatch 'Connect-CPAccount') {
                $result.Message = "$message Verify your BearerToken with Connect-CPAccount."
            }
        }
        403 {
            $result.ErrorType = 'AuthorizationError'
            $result.ErrorId = 'CP.AuthorizationError'
            $result.Category = [System.Management.Automation.ErrorCategory]::PermissionDenied
        }
        404 {
            $result.ErrorType = 'NotFoundError'
            $result.ErrorId = 'CP.NotFoundError'
            $result.Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
        }
        405 {
            $result.ErrorType = 'ClientError'
            $result.ErrorId = 'CP.MethodNotAllowed'
            $result.Category = [System.Management.Automation.ErrorCategory]::InvalidOperation
        }
        429 {
            $result.ErrorType = 'RateLimitError'
            $result.ErrorId = 'CP.RateLimitError'
            $result.Category = [System.Management.Automation.ErrorCategory]::LimitsExceeded
            $result.ShouldRetry = $true
        }
        { $_ -ge 500 } {
            $result.ErrorType = 'ServerError'
            $result.ErrorId = 'CP.ServerError'
            $result.Category = [System.Management.Automation.ErrorCategory]::ResourceUnavailable
            $result.ShouldRetry = $true
        }
    }

    return $result
}

function Get-CPHttpErrorDetails {
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

function New-CPErrorRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $ResolvedError,

        [Parameter(Mandatory)]
        [String]$Uri
    )

    return [System.Management.Automation.ErrorRecord]::new(
        [CPException]::new($ResolvedError.Message),
        $ResolvedError.ErrorId,
        $ResolvedError.Category,
        $Uri
    )
}

function Invoke-CPRestMethod {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Auth', Justification = 'Reserved for request helpers that share the Catchpoint auth object')]
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
    if ($headers.ContainsKey('__CPMethod')) {
        $headers.Remove('__CPMethod') | Out-Null
    }

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
            if ($_.Exception -is [CPException] -or $_.FullyQualifiedErrorId -like 'CP.*') {
                throw $_
            }

            $errorDetails = Get-CPHttpErrorDetails -ErrorRecord $_
            $resolvedError = Resolve-CPException -StatusCode $errorDetails.StatusCode -ResponseBody $errorDetails.Body
            $lastResolvedError = $resolvedError

            if ($resolvedError.ShouldRetry -and $attempt -lt $MaxRetries) {
                if ($EnableDebugLogging -or $VerbosePreference -ne 'SilentlyContinue') {
                    Write-Verbose "Catchpoint API request failed ($($resolvedError.ErrorType)), retrying (attempt $attempt of $MaxRetries)"
                }

                Start-Sleep -Seconds ($retryBackoff * $attempt)
                continue
            }

            if ($errorDetails.StatusCode -ge 400 -and $errorDetails.StatusCode -lt 500 -and $errorDetails.StatusCode -ne 429) {
                $errorRecord = New-CPErrorRecord -ResolvedError $resolvedError -Uri $Uri
                if ($CallerPSCmdlet) {
                    $CallerPSCmdlet.ThrowTerminatingError($errorRecord)
                }

                throw $errorRecord
            }

            if ($attempt -ge $MaxRetries) {
                break
            }

            if ($EnableDebugLogging -or $VerbosePreference -ne 'SilentlyContinue') {
                Write-Verbose "Catchpoint API request failed ($($resolvedError.ErrorType)), retrying (attempt $attempt of $MaxRetries)"
            }

            Start-Sleep -Seconds ($retryBackoff * $attempt)
        }
    }

    $finalResolvedError = if ($lastResolvedError) {
        $lastResolvedError
    }
    else {
        Resolve-CPException -StatusCode $null -ResponseBody 'Maximum Catchpoint API retry attempts exhausted.'
    }

    $finalError = New-CPErrorRecord -ResolvedError $finalResolvedError -Uri $Uri

    if ($CallerPSCmdlet) {
        $CallerPSCmdlet.ThrowTerminatingError($finalError)
    }

    throw $finalError
}
