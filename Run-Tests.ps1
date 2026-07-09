<#
.SYNOPSIS
    Loads local Dev module builds and runs the Pester test suite.

.DESCRIPTION
    Imports Dev.Logic.Monitor.psd1 from this repository and Dev.Logic.Monitor.SE.psd1
    from the sibling Logic.Monitor.SE repository, then runs Invoke-Pester.

    Credentials are resolved in order:
      1. Explicit parameters
      2. LM_* environment variables (same names as GitHub Actions)
      3. Cached credentials from the Logic.Monitor secret vault (-CachedAccountName)

.PARAMETER Path
    Test file or directory to run. Defaults to ./Tests/

.PARAMETER SkipBuild
    Skip running ./Build.ps1 before loading modules.

.PARAMETER SEModulePath
    Path to the Logic.Monitor.SE repository. Defaults to ../Logic.Monitor.SE

.PARAMETER CachedAccountName
    Name of a cached Logic.Monitor vault entry to use for test credentials.

.PARAMETER AccessId
    LogicMonitor API access ID. Falls back to $env:LM_ACCESS_ID.

.PARAMETER AccessKey
    LogicMonitor API access key. Falls back to $env:LM_ACCESS_KEY.

.PARAMETER AccountName
    LogicMonitor portal subdomain. Falls back to $env:LM_PORTAL.

.PARAMETER BearerToken
    LogicMonitor bearer token. Falls back to $env:LM_BEARER_TOKEN.

.PARAMETER PreferredCollectorId
    Collector ID used by device and uptime tests. Defaults to 76.

.PARAMETER PassThru
    Return the Pester result object.

.EXAMPLE
    ./Run-Tests.ps1

.EXAMPLE
    ./Run-Tests.ps1 -CachedAccountName "dev-portal"

.EXAMPLE
    ./Run-Tests.ps1 -Path ./Tests/LMDevice.Tests.ps1 -SkipBuild
#>

[CmdletBinding()]
param(
    [string]$Path = (Join-Path $PSScriptRoot 'Tests'),
    [switch]$SkipBuild,
    [string]$SEModulePath = (Join-Path $PSScriptRoot '..' 'Logic.Monitor.SE'),
    [string]$CachedAccountName,
    [string]$AccessId,
    [string]$AccessKey,
    [string]$AccountName,
    [string]$BearerToken,
    [string]$PreferredCollectorId = '76',
    [switch]$PassThru
)

$ErrorActionPreference = 'Stop'

function Resolve-LMDevModulePath {
    param(
        [Parameter(Mandatory)]
        [string]$SearchPath,

        [string]$Label
    )

    $resolvedPath = Resolve-Path -Path $SearchPath -ErrorAction Stop
    $devModule = Get-ChildItem -Path $resolvedPath -Filter 'Dev.*.psd1' -File | Select-Object -First 1

    if (-not $devModule) {
        throw "No Dev module manifest (Dev.*.psd1) found in $resolvedPath for $Label."
    }

    return $devModule.FullName
}

function Resolve-LMTestCredentials {
    param(
        [string]$CachedAccountName,
        [string]$AccessId,
        [string]$AccessKey,
        [string]$AccountName,
        [string]$BearerToken
    )

    if ($AccessId -and $AccessKey -and $AccountName) {
        return [ordered]@{
            AccessId          = $AccessId
            AccessKey           = $AccessKey
            AccountName         = $AccountName
            BearerToken         = $BearerToken
            AuthType            = 'LMv1'
            CachedAccountName   = $null
            GovCloud            = $false
        }
    }

    if ($BearerToken -and $AccountName -and -not $AccessKey) {
        return [ordered]@{
            AccessId          = $AccessId
            AccessKey           = $null
            AccountName         = $AccountName
            BearerToken         = $BearerToken
            AuthType            = 'Bearer'
            CachedAccountName   = $null
            GovCloud            = $false
        }
    }

    if ($env:LM_ACCESS_ID -and $env:LM_ACCESS_KEY -and $env:LM_PORTAL) {
        return [ordered]@{
            AccessId          = $env:LM_ACCESS_ID
            AccessKey           = $env:LM_ACCESS_KEY
            AccountName         = $env:LM_PORTAL
            BearerToken         = if ($BearerToken) { $BearerToken } else { $env:LM_BEARER_TOKEN }
            AuthType            = 'LMv1'
            CachedAccountName   = $null
            GovCloud            = $false
        }
    }

    if (-not $CachedAccountName) {
        Write-Warning @"
No test credentials were provided. Integration tests that call Connect-LMAccount will fail.
Supply -AccessId/-AccessKey/-AccountName, set LM_ACCESS_ID/LM_ACCESS_KEY/LM_PORTAL, or use -CachedAccountName.
"@
        return [ordered]@{
            AccessId          = $null
            AccessKey           = $null
            AccountName         = $null
            BearerToken         = $BearerToken
            AuthType            = $null
            CachedAccountName   = $null
            GovCloud            = $false
        }
    }

    try {
        Get-SecretVault -Name Logic.Monitor -ErrorAction Stop | Out-Null
    }
    catch {
        throw "Cached account '$CachedAccountName' was requested but the Logic.Monitor secret vault is not configured."
    }

    $cachedAccount = Get-SecretInfo -Vault Logic.Monitor -Name $CachedAccountName -ErrorAction Stop
    if (-not $cachedAccount) {
        throw "Cached account '$CachedAccountName' was not found in the Logic.Monitor vault."
    }

    $credentialType = if ($cachedAccount.Metadata['Type']) { $cachedAccount.Metadata['Type'] } else { 'LMv1' }
    $secretValue = Get-Secret -Vault Logic.Monitor -Name $CachedAccountName -AsPlainText -ErrorAction Stop

    $resolved = [ordered]@{
        AccessId          = $cachedAccount.Metadata['Id']
        AccountName       = $cachedAccount.Metadata['Portal']
        BearerToken       = $null
        AccessKey           = $null
        AuthType            = $credentialType
        CachedAccountName   = $CachedAccountName
        GovCloud            = ($cachedAccount.Metadata['GovCloud'] -eq 'True')
    }

    if ($credentialType -eq 'Bearer') {
        $resolved.BearerToken = $secretValue
    }
    else {
        $resolved.AccessKey = $secretValue
    }

    if (-not $resolved.AccountName) {
        throw "Cached account '$CachedAccountName' is missing portal metadata."
    }

    if ($credentialType -eq 'LMv1' -and (-not $resolved.AccessId -or -not $resolved.AccessKey)) {
        throw "Cached account '$CachedAccountName' is missing LMv1 credential metadata."
    }

    return $resolved
}

if (-not (Get-Module -ListAvailable -Name Pester | Where-Object { $_.Version.Major -ge 5 })) {
    throw 'Pester 5.x is required. Install it with: Install-Module Pester -MinimumVersion 5.0.0 -Force'
}

if (-not $SkipBuild) {
    if (-not $env:BUILD_VERSION) {
        $env:BUILD_VERSION = '9.9.9'
    }

    Write-Host "Building module (BUILD_VERSION=$($env:BUILD_VERSION))..." -ForegroundColor Cyan
    & (Join-Path $PSScriptRoot 'Build.ps1')
}

$devModulePath = Resolve-LMDevModulePath -SearchPath $PSScriptRoot -Label 'Logic.Monitor'
$seDevModulePath = Resolve-LMDevModulePath -SearchPath $SEModulePath -Label 'Logic.Monitor.SE'

Write-Host "Importing $([IO.Path]::GetFileName($devModulePath))..." -ForegroundColor Cyan
Import-Module $devModulePath -Force

Write-Host "Importing $([IO.Path]::GetFileName($seDevModulePath))..." -ForegroundColor Cyan
Import-Module $seDevModulePath -Force

$credentials = Resolve-LMTestCredentials @PSBoundParameters

$pesterData = @{
    Module               = $devModulePath
    ModuleName           = [IO.Path]::GetFileNameWithoutExtension($devModulePath)
    PreferredCollectorId = $PreferredCollectorId
}

foreach ($key in @('AccessId', 'AccessKey', 'AccountName', 'BearerToken', 'CachedAccountName', 'AuthType', 'GovCloud')) {
    if ($null -ne $credentials[$key] -and $credentials[$key] -ne '') {
        $pesterData[$key] = $credentials[$key]
    }
}

if ($credentials.CachedAccountName) {
    Write-Host "Using cached account '$($credentials.CachedAccountName)' ($($credentials.AuthType)) for integration tests." -ForegroundColor Cyan
}

$testPath = Resolve-Path -Path $Path -ErrorAction Stop
Write-Host "Running Pester against $testPath..." -ForegroundColor Cyan

$container = New-PesterContainer -Path $testPath -Data $pesterData
$result = Invoke-Pester -Container $container -Output Detailed -PassThru

if ($PassThru) {
    return $result
}

if ($result.FailedCount -gt 0) {
    exit $result.FailedCount
}

exit 0
