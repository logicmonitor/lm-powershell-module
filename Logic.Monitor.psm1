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

# Plural function wrappers for backward compatibility +7.4
function Set-LMNormalizedProperties      { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Set-LMNormalizedProperty @Args }
function Remove-LMNormalizedProperties   { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Remove-LMNormalizedProperty @Args }
function New-LMNormalizedProperties      { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) New-LMNormalizedProperty @Args }
function Import-LMRepositoryLogicModules { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Import-LMRepositoryLogicModule @Args }
function Get-LMWebsiteGroupAlerts        { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMWebsiteGroupAlert @Args }
function Get-LMWebsiteAlerts             { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMWebsiteAlert @Args }
function Get-LMUsageMetrics              { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMUsageMetric @Args }
function Get-LMRepositoryLogicModules    { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMRepositoryLogicModule @Args }
function Get-LMNormalizedProperties      { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMNormalizedProperty @Args }
function Get-LMNetscanExecutionDevices   { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMNetscanExecutionDevice @Args }
function Get-LMIntegrationLogs           { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMIntegrationLog @Args }
function Get-LMDeviceNetflowPorts        { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMDeviceNetflowPort @Args }
function Get-LMDeviceNetflowFlows        { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMDeviceNetflowFlow @Args }
function Get-LMDeviceNetflowEndpoints    { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMDeviceNetflowEndpoint @Args }
function Get-LMDeviceGroupDevices        { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMDeviceGroupDevice @Args }
function Get-LMDeviceGroupAlerts         { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMDeviceGroupAlert @Args }
function Get-LMDeviceDatasourceInstanceAlertRecipients { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMDeviceDatasourceInstanceAlertRecipient @Args }
function Get-LMDeviceAlertSettings       { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMDeviceAlertSetting @Args }
function Get-LMDatasourceAssociatedDevices { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMDatasourceAssociatedDevice @Args }
function Get-LMCostOptimizationRecommendations { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMCostOptimizationRecommendation @Args }
function Get-LMCostOptimizationRecommendationCategories { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMCostOptimizationRecommendationCategory @Args }
function Get-LMAuditLogs                 { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Get-LMAuditLog @Args }
function Find-LMDashboardWidgets         { [CmdletBinding()] param([Parameter(ValueFromRemainingArguments = $true)][Object[]]$Args) Find-LMDashboardWidget @Args }

# Export both singular and plural names
$AllCmdlets = $Public | ForEach-Object { $_.BaseName }
$Plural = @(
    'Set-LMNormalizedProperties','Remove-LMNormalizedProperties','New-LMNormalizedProperties','Import-LMRepositoryLogicModules',
    'Get-LMWebsiteGroupAlerts','Get-LMWebsiteAlerts','Get-LMUsageMetrics','Get-LMRepositoryLogicModules','Get-LMNormalizedProperties',
    'Get-LMNetscanExecutionDevices','Get-LMIntegrationLogs','Get-LMDeviceNetflowPorts','Get-LMDeviceNetflowFlows','Get-LMDeviceNetflowEndpoints',
    'Get-LMDeviceGroupDevices','Get-LMDeviceGroupAlerts','Get-LMDeviceDatasourceInstanceAlertRecipients','Get-LMDeviceAlertSettings',
    'Get-LMDatasourceAssociatedDevices','Get-LMCostOptimizationRecommendations','Get-LMCostOptimizationRecommendationCategories',
    'Get-LMAuditLogs','Find-LMDashboardWidgets'
) | ForEach-Object { [string]$_ }
$Singular = $AllCmdlets | Where-Object { $Plural -notcontains $_ } | ForEach-Object { [string]$_ }

Export-ModuleMember -Function ($Singular + $Plural)
