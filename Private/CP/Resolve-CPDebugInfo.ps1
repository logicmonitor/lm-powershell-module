function Resolve-CPDebugInfo {
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

    if ($Headers.ContainsKey('__CPMethod')) {
        $httpMethod = $Headers['__CPMethod']
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
        $httpMethod = if ($Payload) { 'POST' } else { 'GET' }
    }

    Write-Debug '============ Catchpoint API Debug Info =============='
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

    $sensitiveHeaders = @('Authorization', 'accessKey', 'bearerToken', 'cookie', 'X-CSRF-Token')
    $headerInfo = $Headers.GetEnumerator() | Where-Object { $_.Key -ne '__CPMethod' } | ForEach-Object {
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
        Write-Debug "Request Payload: $Payload"
    }
    else {
        Write-Debug "Request Payload: None ($httpMethod request)"
    }

    Write-Debug '========================================================'
}
