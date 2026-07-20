<#
.SYNOPSIS
Retrieves the LogicMonitor portal version from API response headers.

.DESCRIPTION
The Get-LMPortalVersion function makes a lightweight API call to retrieve the portal version
from the x-server-version response header. The version is cached in $Script:LMAuth.Version
for the duration of the session to avoid repeated API calls.

.PARAMETER Force
Forces a fresh API call to retrieve the version, bypassing the cached value.

.EXAMPLE
$version = Get-LMPortalVersion
Write-Host "Portal version: $($version.RawVersion)"

.EXAMPLE
$version = Get-LMPortalVersion -Force
if ($version.Major -ge 231) { Write-Host "Feature supported" }

.NOTES
This is a private function used internally by the module.

.OUTPUTS
Returns a PSCustomObject with RawVersion (string), Major (int), and Minor (int) properties.
#>
function Get-LMPortalVersion {
    [CmdletBinding()]
    param (
        [Switch]$Force
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error 'Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.'
        return $null
    }

    # Return cached version if available and not forcing refresh
    if (-not $Force -and $Script:LMAuth.Version) {
        return $Script:LMAuth.Version
    }

    $resourcePath = '/alert/stat'
    $headers = New-LMHeader -Auth $Script:LMAuth -Method 'GET' -ResourcePath $resourcePath
    $uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)$resourcePath"

    # Remove internal tracking header before making request
    if ($headers[0].ContainsKey('__LMMethod')) {
        $headers[0].Remove('__LMMethod') | Out-Null
    }

    try {
        # Make request with response headers capture
        $null = Invoke-RestMethod -Uri $uri -Method 'GET' -Headers $headers[0] -WebSession $headers[1] -ResponseHeadersVariable responseHeaders -ErrorAction Stop

        # Extract version from x-server-version header
        $serverVersion = $null
        if ($responseHeaders -and $responseHeaders['x-server-version']) {
            $serverVersion = $responseHeaders['x-server-version']
            if ($serverVersion -is [array]) {
                $serverVersion = $serverVersion[0]
            }
        }

        if (-not $serverVersion) {
            Write-Warning 'Unable to retrieve portal version from response headers.'
            return $null
        }

        # Parse version string (format: "231-7")
        $versionParts = $serverVersion -split '-'
        $major = 0
        $minor = 0

        if ($versionParts.Count -ge 1) {
            [int]::TryParse($versionParts[0], [ref]$major) | Out-Null
        }
        if ($versionParts.Count -ge 2) {
            [int]::TryParse($versionParts[1], [ref]$minor) | Out-Null
        }

        $versionObject = [PSCustomObject]@{
            RawVersion = $serverVersion
            Major      = $major
            Minor      = $minor
        }

        # Cache the version in $Script:LMAuth
        $Script:LMAuth.Version = $versionObject

        return $versionObject
    }
    catch {
        Write-Error "Failed to retrieve portal version: $_"
        return $null
    }
}
