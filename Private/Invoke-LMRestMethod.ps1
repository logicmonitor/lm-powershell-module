<#
.SYNOPSIS
Centralized wrapper for LogicMonitor REST API calls with built-in retry logic.

.DESCRIPTION
The Invoke-LMRestMethod function provides a robust wrapper around Invoke-RestMethod
that handles rate limiting, transient errors, and implements intelligent retry logic
with exponential backoff for improved reliability.

.PARAMETER Uri
The URI for the REST API endpoint.

.PARAMETER Method
The HTTP method to use (GET, POST, PATCH, PUT, DELETE).

.PARAMETER Headers
Hashtable containing HTTP headers for the request.

.PARAMETER WebSession
The web session object to use for the request.

.PARAMETER Body
The request body (typically JSON for LogicMonitor API).

.PARAMETER OutFile
The path to a file to save the response content to.

.PARAMETER MaxRetries
Maximum number of retry attempts. Default is 3.

.PARAMETER NoRetry
Switch to disable retry logic and fail immediately on any error.

.PARAMETER EnableDebugLogging
Switch to enable detailed debug logging for troubleshooting.

.EXAMPLE
$Response = Invoke-LMRestMethod -Uri $Uri -Method "GET" -Headers $Headers -WebSession $Session

.EXAMPLE
$Response = Invoke-LMRestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $JsonData -MaxRetries 5

.NOTES
This function automatically handles:
- Rate limiting (429 errors) with proper wait times
- Transient server errors (502, 503, 504) with exponential backoff
- Network timeouts and connectivity issues
- Authentication errors (401) without retry
- Client errors (4xx) without retry

.OUTPUTS
Returns the response object from the API call, or throws an exception for non-retryable errors.
#>

# Custom exception class for cleaner error output
class LMException : System.Exception {
    LMException([string]$message) : base($message) { }
    LMException([string]$message, [System.Exception]$innerException) : base($message, $innerException) { }
}

function Invoke-LMRestMethod {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$Uri,

        [Parameter(Mandatory)]
        [ValidateSet("GET", "POST", "PATCH", "PUT", "DELETE")]
        [String]$Method,

        [Parameter(Mandatory)]
        [Hashtable]$Headers,

        [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,

        [String]$Body,

        [String]$OutFile,

        [ValidateRange(1, 10)]
        [Int]$MaxRetries = 3,

        [Switch]$NoRetry,

        [Switch]$EnableDebugLogging
    )

    $retryCount = 0
    $success = $false

    while (-not $success -and $retryCount -le $MaxRetries) {
        try {
            # Build parameters for Invoke-RestMethod
            $params = @{
                Uri         = $Uri
                Method      = $Method
                Headers     = $Headers
                ErrorAction = 'Stop'
            }

            if ($WebSession) {
                $params.WebSession = $WebSession
            }
            if ($Body) {
                $params.Body = $Body
            }
            if ($OutFile) {
                $params.OutFile = $OutFile
            }

            # Log debug information if enabled
            if ($EnableDebugLogging) {
                Write-Debug "Attempt $($retryCount + 1): $Method $Uri"
                if ($Body -and $Body.Length -lt 1000) {
                    Write-Debug "Request Body: $Body"
                }
            }

            # Make the API call
            $Response = Invoke-RestMethod @params
            $success = $true

            if ($EnableDebugLogging) {
                Write-Debug "Request successful on attempt $($retryCount + 1)"
            }

            return $Response
        }
        catch {
            # Get detailed error information from Resolve-LMException
            $errorResult = Resolve-LMException -LMException $PSItem -EnableDebugLogging:$EnableDebugLogging

            # Check if we should retry
            $shouldRetry = $errorResult.ShouldRetry -and -not $NoRetry -and $retryCount -lt $MaxRetries

            if ($shouldRetry) {
                $retryCount++

                # Log retry attempt
                if ($EnableDebugLogging -or $VerbosePreference -ne 'SilentlyContinue') {
                    $waitTime = if ($errorResult.ErrorType -eq 'RateLimit') {
                        "already waited $($errorResult.WaitSeconds)s"
                    }
                    else {
                        $backoffSeconds = [Math]::Min(60, [Math]::Pow(2, $retryCount - 1))
                        "${backoffSeconds}s"
                    }
                    Write-Verbose "Request failed ($($errorResult.ErrorType)), retrying (attempt $retryCount of $MaxRetries) - wait time: $waitTime"
                }

                # For non-rate-limit errors, apply exponential backoff
                if ($errorResult.ErrorType -ne 'RateLimit') {
                    $backoffSeconds = [Math]::Min(60, [Math]::Pow(2, $retryCount - 1))
                    Start-Sleep -Seconds $backoffSeconds
                }

                # Continue to next iteration of the while loop
                continue
            }
            else {
                # Either no retry requested, non-retryable error, max retries exceeded, or NoRetry switch set
                if ($retryCount -eq $MaxRetries) {
                    $errorMessage = "Maximum retry attempts ($MaxRetries) exceeded. Last error: $($errorResult.Message)"
                    if ($EnableDebugLogging) {
                        Write-Debug $errorMessage
                    }
                    throw [LMException]::new($errorMessage)
                }
                elseif ($NoRetry) {
                    if ($EnableDebugLogging) {
                        Write-Debug "Retry disabled, failing immediately: $($errorResult.Message)"
                    }
                    throw [LMException]::new($errorResult.Message)
                }
                else {
                    # Non-retryable error
                    if ($EnableDebugLogging) {
                        Write-Debug "Non-retryable error ($($errorResult.ErrorType)): $($errorResult.Message)"
                    }
                    throw [LMException]::new($errorResult.Message)
                }
            }
        }
    }

    # This should never be reached, but just in case
    throw [LMException]::new("Unexpected error: retry loop completed without success or failure")
}