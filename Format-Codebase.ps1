
param (
    [string]$DirectoryPath = "./Public"
)

# Ensure PSScriptAnalyzer is installed
if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Error "PSScriptAnalyzer module is not installed. Install it using: Install-Module -Name PSScriptAnalyzer -Scope CurrentUser"
    exit 1
}

# $Settings = @{
#     IncludeDefaultRules = $true
#     IncludeRules        = @(
#         'PSPlaceOpenBrace',
#         'PSPlaceCloseBrace',
#         'PSUseConsistentWhitespace'
#     )
#     Rules               = @{
#         PSPlaceOpenBrace          = @{
#             Enable             = $true
#             OnSameLine         = $true
#             NewLineAfter       = $true
#             IgnoreOneLineBlock = $true
#         }
#         PSPlaceCloseBrace         = @{
#             Enable             = $false
#             NewLineAfter       = $false
#             IgnoreOneLineBlock = $true
#         }
#         PSUseConsistentWhitespace = @{
#             Enable          = $true
#             CheckOpenBrace  = $true
#             CheckInnerBrace = $true
#             CheckPipe       = $true
#             CheckParameter  = $true
#         }
#     }
# }

$scriptFiles = Get-ChildItem -Path $DirectoryPath -Include @("*.ps1") -Recurse

foreach ($file in $scriptFiles) {
    $relativePath = $file.FullName -replace $DirectoryPath, ''

    Write-Host "Formatting file: $relativePath"

    $content = Get-Content -Path $file.FullName -Raw
    $formattedContent = Invoke-Formatter -ScriptDefinition $content

    Set-Content -Path $file.FullName -Value $formattedContent -NoNewline
}