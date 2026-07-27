<#
.SYNOPSIS
    Enhanced function to handle exceptions that occur during LogicMonitor API requests.

.DESCRIPTION
    The Resolve-LMException function provides comprehensive error handling for LogicMonitor API requests,
    including rate limiting, transient errors, authentication issues, and network problems.
    Returns structured information about whether the request should be retried.

.PARAMETER LMException
    The exception object that is thrown during the API request.

.PARAMETER EnableDebugLogging
    Switch to enable detailed debug logging for troubleshooting.

.EXAMPLE
    $result = Resolve-LMException -LMException $exception
    if ($result.ShouldRetry) {
        # Retry logic here
    }

.NOTES
    Returns a structured object with the following properties:
    - ShouldRetry: Boolean indicating if the request should be retried
    - WaitSeconds: Number of seconds to wait before retry (if applicable)
    - ErrorType: Classification of the error (RateLimit, ServerError, etc.)
    - StatusCode: HTTP status code (if available)
    - Message: Human-readable error message

.OUTPUTS
    Returns a PSCustomObject with retry and error information.
#>
function Resolve-LMException {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.ErrorRecord]$LMException,

        [Switch]$EnableDebugLogging
    )

    # Initialize return object
    $result = [PSCustomObject]@{
        ShouldRetry = $false
        WaitSeconds = 0
        ErrorType   = 'Unknown'
        StatusCode  = $null
        Message     = ''
    }

    # Debug logging
    if ($EnableDebugLogging) {
        $debugInfo = @{
            Timestamp     = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            ExceptionType = $LMException.Exception.GetType().FullName
            Message       = $LMException.Exception.Message
        }

        if ($LMException.Exception.Response) {
            $debugInfo.StatusCode = $LMException.Exception.Response.StatusCode.value__
        }

        Write-Debug "Exception Details: $($debugInfo | ConvertTo-Json -Compress)"
    }

    # Check if we have a response object (HTTP error vs network error)
    if (-not $LMException.Exception.Response) {
        # Network-level error (timeout, DNS resolution, connection refused, etc.)
        $result.ShouldRetry = $true
        $result.WaitSeconds = 0  # Let caller handle backoff
        $result.ErrorType = 'NetworkError'
        $result.Message = $LMException.Exception.Message

        if ($EnableDebugLogging) {
            Write-Debug "Network error detected: $($result.Message)"
        }

        return $result
    }

    # HTTP response available - check status code
    $statusCode = $LMException.Exception.Response.StatusCode.value__
    $result.StatusCode = $statusCode

    switch ($statusCode) {
        429 {
            # Rate Limit Exceeded
            $result.ErrorType = 'RateLimit'
            $result.ShouldRetry = $true

            try {
                $headers = $LMException.Exception.Response.Headers
                $rateLimitWindow = if ($headers['x-rate-limit-window']) { [int]$headers['x-rate-limit-window'] } else { 60 }
                $rateLimitSize = $headers['x-rate-limit-limit']

                $result.WaitSeconds = $rateLimitWindow
                $result.Message = "Rate limit exceeded ($rateLimitSize requests per $rateLimitWindow seconds)"

                Write-Warning "$($result.Message). Waiting $rateLimitWindow seconds before retry..."
                Start-Sleep -Seconds $rateLimitWindow

                if ($EnableDebugLogging) {
                    Write-Debug "Rate limit handled - waited $rateLimitWindow seconds"
                }
            }
            catch {
                # Fallback if headers are missing or malformed
                $result.WaitSeconds = 60
                $result.Message = "Rate limit exceeded (using default 60s wait)"

                Write-Warning "Rate limit detected but unable to parse headers. Waiting 60 seconds..."
                Start-Sleep -Seconds 60

                if ($EnableDebugLogging) {
                    Write-Debug "Rate limit fallback - waited 60 seconds"
                }
            }

            return $result
        }

        { $_ -in @(502, 503, 504) } {
            # Bad Gateway, Service Unavailable, Gateway Timeout
            $result.ShouldRetry = $true
            $result.WaitSeconds = 0  # Let caller handle exponential backoff
            $result.ErrorType = 'ServerError'
            $result.Message = "Server temporarily unavailable (HTTP $statusCode)"

            if ($EnableDebugLogging) {
                Write-Debug "Transient server error detected: $($result.Message)"
            }

            return $result
        }

        { $_ -ge 500 } {
            # Other server errors (500, 505, etc.)
            $result.ShouldRetry = $false
            $result.ErrorType = 'ServerError'
            $result.Message = "Server error (HTTP $statusCode)"

            # Try to get more specific error message
            $errorMessage = Get-LMExceptionMessage -LMException $LMException
            if ($errorMessage) {
                $result.Message = $errorMessage
            }

            # Error writing is now handled in Invoke-LMRestMethod
            return $result
        }

        401 {
            # Unauthorized
            $result.ShouldRetry = $false
            $result.ErrorType = 'AuthenticationError'
            $result.Message = 'Authentication failed. Please check your API credentials and try connecting again.'

            # Error writing is now handled in Invoke-LMRestMethod
            return $result
        }

        403 {
            # Forbidden
            $result.ShouldRetry = $false
            $result.ErrorType = 'AuthorizationError'
            $result.Message = 'Access denied. Your API credentials do not have sufficient permissions for this operation.'

            # Error writing is now handled in Invoke-LMRestMethod
            return $result
        }

        404 {
            # Not Found - for GET operations, this might be expected behavior
            $result.ShouldRetry = $false
            $result.ErrorType = 'NotFound'

            # Try to get specific error message from response
            $errorMessage = Get-LMExceptionMessage -LMException $LMException
            $result.Message = if ($errorMessage) { $errorMessage } else { "Resource not found (HTTP 404)" }

            # Error writing is now handled in Invoke-LMRestMethod
            return $result
        }

        { $_ -in @(400, 405, 409, 422) } {
            # Bad Request, Method Not Allowed, Conflict, Unprocessable Entity
            $result.ShouldRetry = $false
            $result.ErrorType = 'ClientError'

            # Try to get specific error message from response
            $errorMessage = Get-LMExceptionMessage -LMException $LMException
            $result.Message = if ($errorMessage) { $errorMessage } else { "Client error (HTTP $statusCode)" }

            # Error writing is now handled in Invoke-LMRestMethod
            return $result
        }

        default {
            # Unexpected status code
            $result.ShouldRetry = $false
            $result.ErrorType = 'UnknownError'

            $errorMessage = Get-LMExceptionMessage -LMException $LMException
            $result.Message = if ($errorMessage) { $errorMessage } else { "Unexpected error (HTTP $statusCode)" }

            # Error writing is now handled in Invoke-LMRestMethod
            return $result
        }
    }
}

# Helper function to extract error messages from LogicMonitor API responses
function Get-LMExceptionMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord]$LMException
    )

    try {
        if ($LMException.ErrorDetails.Message) {
            $errorDetails = $LMException.ErrorDetails.Message | ConvertFrom-Json -ErrorAction Stop
            $errorMessage = if ($errorDetails.errorMessage) { 
                $errorDetails.errorMessage 
            }
            elseif ($errorDetails.message) { 
                $errorDetails.message 
            }
            elseif ($errorDetails.error) { 
                $errorDetails.error 
            }
            else { 
                $null 
            }

            if ($errorMessage) {
                # Sanitize error message to remove potential sensitive data
                $sanitized = $errorMessage -replace '(?i)(key|token|password|secret|credential)=[^&\s]+', '$1=***REDACTED***'
                return $sanitized
            }
        }
    }
    catch {
        # JSON parsing failed, try to use raw message
        if ($LMException.ErrorDetails.Message) {
            $sanitized = $LMException.ErrorDetails.Message -replace '(?i)(key|token|password|secret|credential)=[^&\s]+', '$1=***REDACTED***'
            return $sanitized
        }
    }

    # Final fallback to exception message
    if ($LMException.Exception.Message) {
        $sanitized = $LMException.Exception.Message -replace '(?i)(key|token|password|secret|credential)=[^&\s]+', '$1=***REDACTED***'
        return $sanitized
    }

    return $null
}
