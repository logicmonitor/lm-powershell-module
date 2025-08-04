#Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue -Recurse)
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue -Recurse)

#Dot source the files
Foreach ($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Plural aliases for backward compatibility +7.4
Set-Alias -Name Set-LMNormalizedProperties -Value Set-LMNormalizedProperty
Set-Alias -Name Remove-LMNormalizedProperties -Value Remove-LMNormalizedProperty
Set-Alias -Name New-LMNormalizedProperties -Value New-LMNormalizedProperty
Set-Alias -Name Import-LMRepositoryLogicModules -Value Import-LMRepositoryLogicModule
Set-Alias -Name Get-LMWebsiteGroupAlerts -Value Get-LMWebsiteGroupAlert
Set-Alias -Name Get-LMWebsiteAlerts -Value Get-LMWebsiteAlert
Set-Alias -Name Get-LMUsageMetrics -Value Get-LMUsageMetric
Set-Alias -Name Get-LMRepositoryLogicModules -Value Get-LMRepositoryLogicModule
Set-Alias -Name Get-LMNormalizedProperties -Value Get-LMNormalizedProperty
Set-Alias -Name Get-LMNetscanExecutionDevices -Value Get-LMNetscanExecutionDevice
Set-Alias -Name Get-LMIntegrationLogs -Value Get-LMIntegrationLog
Set-Alias -Name Get-LMDeviceNetflowPorts -Value Get-LMDeviceNetflowPort
Set-Alias -Name Get-LMDeviceNetflowFlows -Value Get-LMDeviceNetflowFlow
Set-Alias -Name Get-LMDeviceNetflowEndpoints -Value Get-LMDeviceNetflowEndpoint
Set-Alias -Name Get-LMDeviceGroupDevices -Value Get-LMDeviceGroupDevice
Set-Alias -Name Get-LMDeviceGroupGroups -Value Get-LMDeviceGroupGroup
Set-Alias -Name Get-LMDeviceGroupAlerts -Value Get-LMDeviceGroupAlert
Set-Alias -Name Get-LMDeviceDatasourceInstanceAlertRecipients -Value Get-LMDeviceDatasourceInstanceAlertRecipient
Set-Alias -Name Get-LMDeviceAlertSettings -Value Get-LMDeviceAlertSetting
Set-Alias -Name Get-LMDatasourceAssociatedDevices -Value Get-LMDatasourceAssociatedDevice
Set-Alias -Name Get-LMCostOptimizationRecommendations -Value Get-LMCostOptimizationRecommendation
Set-Alias -Name Get-LMCostOptimizationRecommendationCategories -Value Get-LMCostOptimizationRecommendationCategory
Set-Alias -Name Get-LMAuditLogs -Value Get-LMAuditLog
Set-Alias -Name Find-LMDashboardWidgets -Value Find-LMDashboardWidget

# Export both singular and plural names
$AllCmdlets = $Public | ForEach-Object { $_.BaseName }
$Plural = @(
    'Set-LMNormalizedProperties','Remove-LMNormalizedProperties','New-LMNormalizedProperties','Import-LMRepositoryLogicModules',
    'Get-LMWebsiteGroupAlerts','Get-LMWebsiteAlerts','Get-LMUsageMetrics','Get-LMRepositoryLogicModules','Get-LMNormalizedProperties',
    'Get-LMNetscanExecutionDevices','Get-LMIntegrationLogs','Get-LMDeviceNetflowPorts','Get-LMDeviceNetflowFlows','Get-LMDeviceNetflowEndpoints',
    'Get-LMDeviceGroupDevices','Get-LMDeviceGroupGroups','Get-LMDeviceGroupAlerts','Get-LMDeviceDatasourceInstanceAlertRecipients','Get-LMDeviceAlertSettings',
    'Get-LMDatasourceAssociatedDevices','Get-LMCostOptimizationRecommendations','Get-LMCostOptimizationRecommendationCategories',
    'Get-LMAuditLogs','Find-LMDashboardWidgets'
) | ForEach-Object { [string]$_ }
$Singular = $AllCmdlets | Where-Object { $Plural -notcontains $_ } | ForEach-Object { [string]$_ }

Export-ModuleMember -Function $Singular -Alias $Plural
