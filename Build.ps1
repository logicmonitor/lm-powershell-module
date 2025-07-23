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

# Add this before you build $funcStrings
$wrapperFunctionNames = @(
    'Set-LMNormalizedProperties','Remove-LMNormalizedProperties','New-LMNormalizedProperties','Import-LMRepositoryLogicModules',
    'Get-LMWebsiteGroupAlerts','Get-LMWebsiteAlerts','Get-LMUsageMetrics','Get-LMRepositoryLogicModules','Get-LMNormalizedProperties',
    'Get-LMNetscanExecutionDevices','Get-LMIntegrationLogs','Get-LMDeviceNetflowPorts','Get-LMDeviceNetflowFlows','Get-LMDeviceNetflowEndpoints',
    'Get-LMDeviceGroupDevices','Get-LMDeviceGroupAlerts','Get-LMDeviceDatasourceInstanceAlertRecipients','Get-LMDeviceAlertSettings',
    'Get-LMDatasourceAssociatedDevices','Get-LMCostOptimizationRecommendations','Get-LMCostOptimizationRecommendationCategories',
    'Get-LMAuditLogs','Find-LMDashboardWidgets'
)

# Export function names and wrapper functions
If ((Test-Path -Path $publicFuncFolderPath) -and ($publicFunctionNames = Get-ChildItem -Path $publicFuncFolderPath -Filter '*.ps1' | Select-Object -ExpandProperty BaseName)) {
    $allFunctionNames = $publicFunctionNames + $wrapperFunctionNames
    $funcStrings = "'$($allFunctionNames -join "','")'"
} else {
    $funcStrings = $null
}

$manifestContent = $manifestContent -replace "'<FunctionsToExport>'", $funcStrings
$manifestContent | Set-Content -Path $manifestPath
