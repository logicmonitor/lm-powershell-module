<#
.SYNOPSIS
Function to write debug information for LogicMonitor API requests.

.DESCRIPTION
The Resolve-LMDebugInfo function provides comprehensive debug information for LogicMonitor API requests including
command context, formatted parameters, URL details, secure header display, and formatted payload data.

.PARAMETER Url
The URL that was invoked for the API request.

.PARAMETER Headers
The headers hashtable used in the request.

.PARAMETER Command
The PowerShell command invocation context (typically $MyInvocation).

.PARAMETER Payload
The request payload (typically JSON string or null for GET/DELETE operations).

.EXAMPLE
Resolve-LMDebugInfo -Url "https://portal.logicmonitor.com/santaba/rest/device/devices" -Headers $Headers -Command $MyInvocation -Payload $JsonData

.NOTES
Sensitive headers (accessKey, bearerToken, JSESSIONID) are automatically redacted for security.
#>

function Resolve-LMDebugInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Url,

        [Parameter(Mandatory)]
        [Hashtable]$Headers,

        [Parameter(Mandatory)]
        [System.Management.Automation.InvocationInfo]$Command,

        [String]$Payload
    )

    # Add timestamp for correlation
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

    $HttpMethod = $null

    if ($Headers.ContainsKey('__LMMethod')) {
        $HttpMethod = $Headers['__LMMethod']
        $Headers.Remove('__LMMethod') | Out-Null
    }

    if (-not $HttpMethod) {
        $CommandName = $Command.MyCommand.Name
        switch -Regex ($CommandName) {
            '^(Get|Find|Search|Test|Resolve|Format|Measure|Show)-' { $HttpMethod = 'GET'; break }
            '^(Remove|Uninstall|Disconnect|Stop|Clear|Delete)-' { $HttpMethod = 'DELETE'; break }
            '^(Set|Update|Enable|Disable|Rename|Move|Merge|Patch|Edit)-' { $HttpMethod = 'PATCH'; break }
            '^(New|Add|Copy|Send|Import|Invoke|Start|Publish|Submit|Approve)-' { $HttpMethod = 'POST'; break }
        }
    }

    if (-not $HttpMethod) {
        if ($Headers.ContainsKey('Content-Type') -and $Payload) {
            if ($Payload -match '".*":\s*null|".*":\s*""') { $HttpMethod = 'PATCH' }
            else { $HttpMethod = 'POST' }
        }
        elseif ($Payload) {
            $HttpMethod = 'POST'
        }
        else {
            $HttpMethod = 'GET'
        }
    }

    Write-Debug "============ LogicMonitor API Debug Info =============="
    Write-Debug "Command: $($Command.MyCommand) | Method: $HttpMethod | Timestamp: $Timestamp"

    # Format bound parameters
    if ($Command.BoundParameters.Count -gt 0) {
        $ParamList = $Command.BoundParameters.GetEnumerator() | ForEach-Object {
            $Value = if ($_.Value -is [Array]) { "[$($_.Value -join ', ')]" }
            elseif ($_.Value -is [Hashtable]) { "{$($_.Value.Keys -join ', ')}" }
            else { $_.Value }
            "$($_.Key): $Value"
        }
        Write-Debug "Parameters: $($ParamList -join ' | ')"
    }

    # Parse and display URL components
    $UriObj = [System.Uri]$Url
    Write-Debug "Endpoint: $($UriObj.PathAndQuery)"
    Write-Debug "Portal: $($UriObj.Host)"

    # Display headers with partial redaction for identification
    $SensitiveHeaders = @('accessKey', 'bearerToken', 'cookie', 'X-CSRF-Token')
    $HeaderInfo = $Headers.GetEnumerator() | ForEach-Object {
        $Value = if ($SensitiveHeaders -contains $_.Key) {
            if ($_.Value.Length -gt 25) {
                $_.Value.Substring(0, 25) + "..."
            }
            else {
                $_.Value
            }
        }
        else {
            $_.Value
        }
        "$($_.Key): $Value"
    }
    Write-Debug "Headers: $($HeaderInfo -join ' | ')"

    # Format and display payload with JSON pretty-printing
    if ($Payload) {
        try {
            # Parse JSON and redact sensitive fields
            $JsonObj = $Payload | ConvertFrom-Json
            $SensitiveFields = @('password', 'accessKey', 'token', 'secret', 'apiKey', 'bearerToken')

            # Recursively redact sensitive fields
            function RedactSensitiveData($Object) {
                if ($Object -is [PSCustomObject]) {
                    $Object.PSObject.Properties | ForEach-Object {
                        if ($SensitiveFields -contains $_.Name) {
                            $_.Value = "[REDACTED]"
                        }
                        elseif ($_.Value -is [PSCustomObject] -or $_.Value -is [Array]) {
                            $_.Value = RedactSensitiveData $_.Value
                        }
                    }
                }
                elseif ($Object -is [Array]) {
                    for ($i = 0; $i -lt $Object.Count; $i++) {
                        $Object[$i] = RedactSensitiveData $Object[$i]
                    }
                }
                return $Object
            }

            $RedactedObj = RedactSensitiveData $JsonObj
            $FormattedPayload = $RedactedObj | ConvertTo-Json -Depth 10 |
                ForEach-Object { $_ -split "`n" | ForEach-Object { "    $_" } }
            Write-Debug "Request Payload:"
            $FormattedPayload | ForEach-Object { Write-Debug $_ }
        }
        catch {
            # Fallback to simple string display if JSON parsing fails
            Write-Debug "Request Payload (Raw): $Payload"
        }
    }
    else {
        Write-Debug "Request Payload: None ($HttpMethod request)"
    }

    Write-Debug "========================================================"
}