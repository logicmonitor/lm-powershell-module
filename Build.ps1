$Global:ErrorActionPreference = 'Stop'
$Global:VerbosePreference = 'SilentlyContinue'

$buildVersion = $env:BUILD_VERSION
$manifestPath = "./Logic.Monitor.psd1"
$publicFuncFolderPath = './Public'

# Exclude patterns for functions to not export (e.g., work-in-progress features)
$excludePatterns = @('*LMUptime*')

$ps1xmlFiles = Get-ChildItem -Path ./ -Filter *.ps1xml
Foreach ($ps1xml in $ps1xmlFiles) {
    [xml]$xml = Get-Content -Path $ps1xml.FullName
    $null = $xml.Schemas.Add($null, 'https://raw.githubusercontent.com/PowerShell/PowerShell/master/src/Schemas/Format.xsd')
    $null = $xml.Schemas.Add($null, 'https://raw.githubusercontent.com/PowerShell/PowerShell/master/src/Schemas/Types.xsd')
    $xml.Validate( { Throw "File '$($ps1xml.Name)' schema error: $($_.Message)" })
}

If (!(Get-PackageProvider | Where-Object { $_.Name -eq 'NuGet' })) {
    Install-PackageProvider -Name NuGet -Force | Out-Null
}
Import-PackageProvider -Name NuGet -Force | Out-Null

If ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

If (!(Get-Module Microsoft.PowerShell.SecretManagement -ListAvailable)) {
    Install-Module Microsoft.PowerShell.SecretManagement -Force -Confirm:$false
}
If (!(Get-Module Microsoft.PowerShell.SecretStore -ListAvailable)) {
    Install-Module Microsoft.PowerShell.SecretStore -Force -Confirm:$false
}
If (!(Get-Module PwshSpectreConsole -ListAvailable)) {
    Install-Module PwshSpectreConsole -Force -Confirm:$false
}

$manifestContent = (Get-Content -Path $manifestPath -Raw) -replace '<ModuleVersion>', $buildVersion

If (Test-Path -Path $publicFuncFolderPath) {
    $allFunctions = Get-ChildItem -Path $publicFuncFolderPath -Filter '*.ps1'
    
    # Apply exclusion patterns
    $filteredFunctions = $allFunctions
    foreach ($pattern in $excludePatterns) {
        $filteredFunctions = $filteredFunctions | Where-Object { $_.Name -notlike $pattern }
    }
    
    $publicFunctionNames = $filteredFunctions | Select-Object -ExpandProperty BaseName
    
    if ($publicFunctionNames) {
        $funcStrings = "'$($publicFunctionNames -join "','")'"
    }
    else {
        $funcStrings = $null
    }
}
Else {
    $funcStrings = $null
}

$manifestContent = $manifestContent -replace "'<FunctionsToExport>'", $funcStrings
$manifestContent | Set-Content -Path $manifestPath
