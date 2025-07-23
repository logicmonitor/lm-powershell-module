$Global:ErrorActionPreference = 'Stop'
$Global:VerbosePreference = 'SilentlyContinue'

$buildVersion = $env:BUILD_VERSION
$manifestPath = "./Logic.Monitor.psd1"
$publicFuncFolderPath = './Public'

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

If ((Test-Path -Path $publicFuncFolderPath) -and ($publicFunctionNames = Get-ChildItem -Path $publicFuncFolderPath -Filter '*.ps1' | Select-Object -ExpandProperty BaseName)) {
    $funcStrings = "'$($publicFunctionNames -join "','")'"
}
Else {
    $funcStrings = $null
}

$manifestContent = $manifestContent -replace "'<FunctionsToExport>'", $funcStrings
$manifestContent | Set-Content -Path $manifestPath
