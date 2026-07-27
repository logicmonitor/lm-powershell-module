<#
.SYNOPSIS
Writes debug information for Edwin API requests.

.DESCRIPTION
The Resolve-EAIDebugInfo function provides debug information for Edwin API requests including
command context, formatted parameters, URL details, secure header display, and formatted payload data.

.PARAMETER Url
The URL that was invoked for the API request.

.PARAMETER Headers
The headers hashtable used in the request.

.PARAMETER Command
The PowerShell command invocation context (typically $MyInvocation).

.PARAMETER Payload
The request payload (typically JSON string).

.EXAMPLE
Resolve-EAIDebugInfo -Url "https://myorg.dexda.ai/integration/event/v1" -Headers $Headers -Command $MyInvocation -Payload $JsonData
#>
function Resolve-EAIDebugInfo {
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

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'
    $httpMethod = $null

    if ($Headers.ContainsKey('__EAIMethod')) {
        $httpMethod = $Headers['__EAIMethod']
        $Headers.Remove('__EAIMethod') | Out-Null
    }

    if (-not $httpMethod) {
        $commandName = $Command.MyCommand.Name
        switch -Regex ($commandName) {
            '^(Get|Find|Search|Test|Resolve|Format|Measure|Show)-' { $httpMethod = 'GET'; break }
            '^(Remove|Uninstall|Disconnect|Stop|Clear|Delete)-' { $httpMethod = 'DELETE'; break }
            '^(Set|Update|Enable|Disable|Rename|Move|Merge|Patch|Edit)-' { $httpMethod = 'PATCH'; break }
            '^(New|Add|Copy|Send|Import|Invoke|Start|Publish|Submit|Approve|Convert)-' { $httpMethod = 'POST'; break }
        }
    }

    if (-not $httpMethod) {
        if ($Headers.ContainsKey('Content-Type') -and $Payload) {
            $httpMethod = 'POST'
        }
        elseif ($Payload) {
            $httpMethod = 'POST'
        }
        else {
            $httpMethod = 'GET'
        }
    }

    Write-Debug '============ Edwin API Debug Info =============='
    Write-Debug "Command: $($Command.MyCommand) | Method: $httpMethod | Timestamp: $timestamp"

    if ($Command.BoundParameters.Count -gt 0) {
        $paramList = $Command.BoundParameters.GetEnumerator() | ForEach-Object {
            $value = if ($_.Value -is [Array]) { "[$($_.Value -join ', ')]" }
            elseif ($_.Value -is [Hashtable]) { "{$($_.Value.Keys -join ', ')}" }
            else { $_.Value }
            "$($_.Key): $value"
        }
        Write-Debug "Parameters: $($paramList -join ' | ')"
    }

    $uriObj = [System.Uri]$Url
    Write-Debug "Endpoint: $($uriObj.PathAndQuery)"
    Write-Debug "Portal: $($uriObj.Host)"

    $sensitiveHeaders = @('Authorization', 'accessKey', 'bearerToken', 'cookie', 'X-CSRF-Token', 'client_secret', 'client_id')
    $headerInfo = $Headers.GetEnumerator() | ForEach-Object {
        $value = if ($sensitiveHeaders -contains $_.Key) {
            if ($_.Value.Length -gt 25) {
                $_.Value.Substring(0, 25) + '...'
            }
            else {
                $_.Value
            }
        }
        else {
            $_.Value
        }
        "$($_.Key): $value"
    }
    Write-Debug "Headers: $($headerInfo -join ' | ')"

    if ($Payload) {
        try {
            $jsonObj = $Payload | ConvertFrom-Json
            $sensitiveFields = @('password', 'accessKey', 'token', 'secret', 'apiKey', 'bearerToken', 'client_secret', 'client_id', 'clientSecret', 'clientId')

            function Redact-EAISensitiveData {
                param($Object)

                if ($Object -is [PSCustomObject]) {
                    $Object.PSObject.Properties | ForEach-Object {
                        if ($sensitiveFields -contains $_.Name) {
                            $_.Value = '[REDACTED]'
                        }
                        elseif ($_.Value -is [PSCustomObject] -or $_.Value -is [Array]) {
                            Redact-EAISensitiveData $_.Value
                        }
                    }
                }
                elseif ($Object -is [Array]) {
                    for ($i = 0; $i -lt $Object.Count; $i++) {
                        if ($Object[$i] -is [PSCustomObject] -or $Object[$i] -is [Array]) {
                            Redact-EAISensitiveData $Object[$i]
                        }
                    }
                }
            }

            Redact-EAISensitiveData $jsonObj

            $jsonString = ConvertTo-Json -InputObject $jsonObj -Depth 10
            $formattedPayload = $jsonString -split "`r?`n" | ForEach-Object { "    $_" }

            Write-Debug 'Request Payload:'
            $formattedPayload | ForEach-Object { Write-Debug $_ }
        }
        catch {
            Write-Debug "Request Payload (Raw): $Payload"
        }
    }
    else {
        Write-Debug "Request Payload: None ($httpMethod request)"
    }

    Write-Debug '========================================================'
}
