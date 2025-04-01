[![Build PSGallery Release](https://github.com/logicmonitor/lm-powershell-module/actions/workflows/main.yml/badge.svg?event=release)](https://github.com/logicmonitor/lm-powershell-module/actions/workflows/main.yml)\
[![Test Current Build on PowerShell Core 7.4.1](https://github.com/logicmonitor/lm-powershell-module/actions/workflows/test.yml/badge.svg)](https://github.com/logicmonitor/lm-powershell-module/actions/workflows/test.yml)\
[![Test Current Build on Windows Powershell 5.1](https://github.com/logicmonitor/lm-powershell-module/actions/workflows/test-win.yml/badge.svg)](https://github.com/logicmonitor/lm-powershell-module/actions/workflows/test-win.yml)

# General

PowerShell module for accessing the LogicMonitor REST API.

This project is also published in the PowerShell Gallery at https://www.powershellgallery.com/packages/Logic.Monitor/.


**Community Contribution Notice**: This PowerShell module is an open-source project created and maintained by LogicMonitor users. While not an official LogicMonitor product, it's designed by people who use and understand the platform.

The module is freely available for everyone to use, modify, and improve. We welcome your feedback and contributions! If you have ideas or encounter any issues, please share them through GitHub issues or pull requests.

Many community members rely on this module in their daily operations. Though we can't offer formal support guarantees, our collaborative community strives to address questions and continuously enhance functionality.

We hope you find this tool valuable for your LogicMonitor workflows!

# Installation

- From PowerShell Gallery:

```powershell
Install-Module -Name "Logic.Monitor"
```

# Upgrading

- New releases are published often, to ensure you have the latest version you can run:

```powershell
Update-Module -Name "Logic.Monitor"
```

# General Usage

Before you can use on module commands you will need to be connected to a LM portal. To connect your LM portal use the **Connect-LMAccount** command:

```powershell
Connect-LMAccount -AccessId "lm_access_id" -AccessKey "lm_access_key" -AccountName "lm_portal_prefix_name"
```

Once connected you can then run an appropriate command, a full list of commands available can be found using:

```powershell
Get-Command -Module "Logic.Monitor"
```

To disconnect from an account simply run the Disconnect-LMAccount command:

```powershell
Disconnect-LMAccount
```

To cache credentials for multiple portals you can use the command New-LMCachedAccount, once a credential has been cached you can reference it when connecting to an lm portal using the -UserCachedCredentials switch in Connect-LMAccount.

Cached credentials are stored in a LocalVault using **Microsoft's SecretManagement** module. If its your first time using SecretManagement you will be prompted to set up a password for accessing your cached accounts in the LocalVault using this method.

```powershell
New-LMCachedAccount -AccessId "lm_access_id" -AccessKey "lm_access_key" -AccountName "lm_portal_prefix_name"
Connect-LMAccount -UseCachedCredential

#Example output when using cached credentials
#Selection Number | Portal Name
#0) portalname
#1) portalnamesandbox
#Enter the number for the cached credential you wish to use: 1
#Connected to LM portal portalnamesandbox using account
```

# Examples

Most Get commands can pull info by id or name to allow for easier retrieval without needing to know the specific resource id. The name parameters in get commands can also accept wildcard values. All responses will return objects in list view so for readability you may want to pipe the output to **Format-Table**.

Get list of devices:

```powershell
#Get all devices
Get-LMDevice

#Get device via id
Get-LMDevice -Id 1

#Get device via hostname
Get-LMDevice -Name device.example.com

#Get device via displayname/wildcard
Get-LMDevice -DisplayName "corp*"
```

When modifying or removing a device you can use the Name parameter instead of id but wildcard values cannot be used.

Modify a device:

```powershell
#Change device Name,DisplayName,Description,Link and set collector assignment
Set-LMDevice -Id 1 -DisplayName "New Device Name" -NewName "device.example.com" -Description "Critical Device" -Link "http://device.example.com" -PreferredCollectorId 1

#Add/Update custom properties to a resource and disable alerting
Set-LMDevice -Id 1 -Properties @{propname1="value1";propname2="value2"} -DisableAlerting $true
```

Remove a device:

```powershell
#Remove device by hostname
Remove-LMDevice -Name "device.example.com" -HardDelete $false

```

Send LM Log Message:

```powershell
Send-LMLogMessage -Message "Hello World!" -resourceMapping @{"system.displayname"="LM-COLL"} -Metadata @{"extra-data"="value";"extra-data2"="value2"}
```

Add a new user to LogicMonitor:
```powershell
New-LMUser -RoleNames @("administrator") -Password "changeme" -FirstName John -LastName Doe -Email jdoe@example.com -Username jdoe@example.com -ForcePasswordChange $true -Phone "5558675309"
```

Generate new API Token:
```powershell
New-LMAPIToken -Username jdoe@example.com -Note "Used for K8s"
```

### **Using the -Filter parameter**: 
The -Filter parameter has been overhauled to provide more options and flexibility in generating more complex server side filtering options. Previously -Filter only took in a hashtable of properties to perform an equal comparison against, this was very limited compared to the additional filtering options available in LM APIv3. As a result of the update **4.2** you can now use the following operators when construction the filter string. Additionally the old hashtable method of filtering is still supported for backwards compatibility but may be removed in a future update:

| Operator      | Description           |
|---------------|-------------          |
|-eq	        |Equal                  |
|-ne            |Not equal              |
|-gt	        |Greater than           |
|-lt	        |Less than              |
|-ge            |Greater than or equal  |
|-le            |Less than or equal     |
|-contains	    |Contain                |
|-notcontains   |Does not contain       |
|-and	        |Comparison *and* operator   |
|-or            |Comparison *or* operator   |

**Notes**: When creating your own custom filters, consider the following items:

**Text values**: Enclose the text in single quotation marks (for example, 'Value' or 'Value with spaces'):

```powershell
-Filter "displayName -eq 'MyNameHere'"
```

**Variables**: Enclose variables that need to be expanded in single quotation marks:

```powershell
-Filter "username -eq '$User'"
```

**Integer values**: You don't need to enclose integers (for example, 500). You can often enclose integers in single quotation marks but is not required:

```powershell
-Filter "id -eq 7"
```

**System values**: Enclose system values (for example, \$true, \$false, or \$null) in single quotation marks:

```powershell
-Filter "disableAlerting -eq '$true'"
```

**Field names**: Field names in the LM API are case sensitive, ensure you use the proper casing when creating a custom filter (ex displayName). Using incorrect casing can result in unexpected results being returned. Also reference LM APIv3 swagger guide for details on which fields are supported for filtering.

Additional Filter Examples:
```powershell
#Device Hostname contains UDM and aleting is disabled
Get-LMDevice -Filter "disableAlerting -eq '$true' -and name -contains 'UDM'"

#User email address either contains steve or is null
Get-LMUser -Filter "email -contains 'steve' -or email -ne '$null'"

#Get active alerts where the instance name is Kubernetes_Scheduler and the Alert Rule is labeled Critical
Get-LMAlert -Filter "instanceName -eq 'Kubernetes_Scheduler' -and rule -eq 'Critical'"
```

**Note:** Using the -Name parameter to target a resource during a Set/Remove command will perform an initial get request for you automatically to retrieve the required id. When performing a large amount of changes using id is the preferred method to avoid excessive lookups and avoid any potential API throttling.

# Additional Code Examples and Documentation

- [Code Snippet Library](EXAMPLES.md)
- [Command Documentation](/Documentation)

# Available Commands:

Connect-LMAccount\
\
Copy-LMDashboard\
Copy-LMDevice\
Copy-LMReport\
\
Disconnect-LMAccount\
\
Export-LMDeviceConfigBackup\
Export-LMDeviceData\
Export-LMLogicModule\
\
Get-LMAccessGroup\
Get-LMAccountStatus\
Get-LMAlert\
Get-LMAlertRule\
Get-LMAPIToken\
Get-LMAppliesToFunction\
Get-LMAuditLogs\
Get-LMAWSAccountId\
Get-LMCachedAccount\
Get-LMCollector\
Get-LMCollectorDebugResult\
Get-LMCollectorGroup\
Get-LMCollectorInstaller\
Get-LMCollectorVersions\
Get-LMConfigSource\
Get-LMConfigsourceUpdateHistory\
Get-LMDashboard\
Get-LMDashboardGroup\
Get-LMDashboardWidget\
Get-LMDatasource\
Get-LMDatasourceAssociatedDevices\
Get-LMDatasourceGraph\
Get-LMDatasourceMetadata\
Get-LMDatasourceOverviewGraph\
Get-LMDatasourceUpdateHistory\
Get-LMDevice\
Get-LMDeviceAlerts\
Get-LMDeviceAlertSettings\
Get-LMDeviceConfigSourceData\
Get-LMDeviceData\
Get-LMDeviceDatasourceInstance\
Get-LMDeviceDatasourceInstanceAlertRecipients\
Get-LMDeviceDatasourceInstanceAlertSetting\
Get-LMDeviceDatasourceInstanceGroup\
Get-LMDeviceDataSourceList\
Get-LMDeviceEventSourceList\
Get-LMDeviceGroup\
Get-LMDeviceGroupAlerts\
Get-LMDeviceGroupDatasourceAlertSetting\
Get-LMDeviceGroupDatasourceList\
Get-LMDeviceGroupDevices\
Get-LMDeviceGroupGroups\
Get-LMDeviceGroupProperty\
Get-LMDeviceGroupSDT\
Get-LMDeviceGroupSDTHistory\
Get-LMDeviceInstanceData\
Get-LMDeviceInstanceList\
Get-LMDeviceNetflowEndpoints\
Get-LMDeviceNetflowFlows\
Get-LMDeviceNetflowPorts\
Get-LMDeviceProperty\
Get-LMDeviceSDT\
Get-LMDeviceSDTHistory\
Get-LMEscalationChain\
Get-LMEventSource\
Get-LMIntegrationLogs\
Get-LMLogSource\
Get-LMNetscan\
Get-LMNetscanExecution\
Get-LMNetscanExecutionDevices\
Get-LMNetscanGroup\
Get-LMOpsNote\
Get-LMPortalInfo\
Get-LMPropertySource\
Get-LMRecipientGroup\
Get-LMReport\
Get-LMReportGroup\
Get-LMRepositoryLogicModules\
Get-LMRole\
Get-LMSDT\
Get-LMSysOIDMap
Get-LMTopologyMap\
Get-LMTopologyMapData\
Get-LMTopologySource\
Get-LMUnmonitoredDevice\
Get-LMUsageMetrics\
Get-LMUser\
Get-LMUserGroup\
Get-LMWebsite\
Get-LMWebsiteAlerts\
Get-LMWebsiteCheckpoint\
Get-LMWebsiteData\
Get-LMWebsiteGroup\
Get-LMWebsiteGroupAlerts\
Get-LMWebsiteGroupSDT\
Get-LMWebsiteGroupSDTHistory\
Get-LMWebsiteProperty\
Get-LMWebsiteSDT\
Get-LMWebsiteSDTHistory\
Get-LMNormalizedProperties\
Get-LMLogMessage\
\
Import-LMDashboard\
Import-LMExchangeModule\
Import-LMLogicModule\
Import-LMRepositoryLogicModules\
\
Invoke-LMActiveDiscovery\
Invoke-LMAWSAccountTest\
Invoke-LMAzureAccountTest\
Invoke-LMAzureSubscriptionDiscovery\
Invoke-LMCloudGroupNetScan\
Invoke-LMCollectorDebugCommand\
Invoke-LMDeviceConfigSourceCollection\
Invoke-LMGCPAccountTest\
Invoke-LMNetScan\
Invoke-LMUserLogoff\
\
New-LMAccessGroup\
New-LMAccessGroupMapping\
New-LMAlertAck\
New-LMAlertEscalation\
New-LMAlertNote\
New-LMAPIToken\
New-LMAPIUser\
New-LMAppliesToFunction\
New-LMCachedAccount\
New-LMCollector\
New-LMCollectorGroup\
New-LMDashboardGroup\
New-LMDatasourceGraph\
New-LMDatasourceOverviewGraph\
New-LMDevice\
New-LMDeviceDatasourceInstance\
New-LMDeviceDatasourceInstanceGroup\
New-LMDeviceDatasourceInstanceSDT\
New-LMDeviceDatasourceSDT\
New-LMDeviceGroup\
New-LMDeviceGroupSDT\
New-LMDeviceProperty\
New-LMDeviceSDT\
New-LMEnhancedNetscan\
New-LMNetscan\
New-LMNetscanGroup\
New-LMNormalizedProperties\
New-LMOpsNote\
New-LMPushMetricDataPoint\
New-LMPushMetricInstance\
New-LMReportGroup\
New-LMRole\
New-LMUser\
New-LMWebsite\
New-LMWebsiteGroup\
\
Remove-LMAccessGroup\
Remove-LMAPIToken\
Remove-LMAppliesToFunction\
Remove-LMCachedAccount\
Remove-LMCollectorGroup\
Remove-LMConfigsource\
Remove-LMDashboard\
Remove-LMDashboardGroup\
Remove-LMDashboardWidget\
Remove-LMDatasource\
Remove-LMDevice\
Remove-LMDeviceDatasourceInstance\
Remove-LMDeviceDatasourceInstanceGroup\
Remove-LMDeviceGroup\
Remove-LMDeviceProperty\
Remove-LMLogsource\
Remove-LMNetscan\
Remove-LMNetscanGroup\
Remove-LMNormalizedProperties\
Remove-LMOpsNote\
Remove-LMPropertysource\
Remove-LMReport\
Remove-LMReportGroup\
Remove-LMRole\
Remove-LMSDT\
Remove-LMTopologysource\
Remove-LMUnmonitoredDevice\
Remove-LMUser\
Remove-LMWebsite\
Remove-LMWebsiteGroup\
Remove-LMNormalizedProperties\
\
Send-LMLogMessage\
Send-LMPushMetric\
\
Set-LMAccessGroup\
Set-LMAPIToken\
Set-LMAppliesToFunction\
Set-LMCollector\
Set-LMCollectorConfig\
Set-LMCollectorGroup\
Set-LMConfigsource\
Set-LMDatasource\
Set-LMDevice\
Set-LMDeviceDatasourceInstance\
Set-LMDeviceDatasourceInstanceAlertSetting\
Set-LMDeviceGroup\
Set-LMDeviceGroupDatasourceAlertSetting\
Set-LMDeviceProperty\
Set-LMNetScan\
Set-LMNetscanGroup\
Set-LMNewUserMessage\
Set-LMNormalizedProperties\
Set-LMOpsNote\
Set-LMPortalInfo\
Set-LMPropertysource\
Set-LMPushModuleDeviceProperty\
Set-LMPushModuleInstanceProperty\
Set-LMReportGroup\
Set-LMRole\
Set-LMSDT\
Set-LMTopologysource\
Set-LMUnmonitoredDevice\
Set-LMUser\
Set-LMUserdata\
Set-LMWebsite\
Set-LMWebsiteGroup\
Set-LMNormalizedProperties\
\
Test-LMAppliesToQuery\
\
**Note**: Some commands accept pipeline input, see `Get-Command <cmdlet-name> -Module Logic.Monitor` for details.

# Change List

## Important Update: Logic.Monitor PowerShell Module Transition

We are excited to announce a significant update to the Logic.Monitor PowerShell module. Starting with version 6.0, the module will be relocating to a new repository within the LogicMonitor GitHub organization. The new repository will be named `lm-powershell-module`.

This change aims to enhance visibility within the community and to foster a more centralized and collaborative environment for feedback and contributions. As a community-driven open source project, we believe this move will allow for more robust development and support, benefiting all users.

## What This Means for You:
- The new repository location will be active with the release of version 6.0.
- Users are encouraged to start using the new repository for all future updates, issue tracking, and contributions.

## Action Required:
- Please update your bookmarks and local environments to point to the new repository: [https://github.com/LogicMonitor/lm-powershell-module](https://github.com/LogicMonitor/lm-powershell-module)
- Subscribe to the repository to stay updated with the latest releases and discussions.

We appreciate your continued support and enthusiasm for the Logic.Monitor PowerShell module. Your contributions and feedback are vital to the success of this project, and we look forward to seeing how the module evolves with your participation.

## 6.6
### Updated Cmdlets:
 - **Get-LMSysOIDMap**: Added cmdlet to query and retrieve sysOIDMap details.
 - **Export-LMLogicModule**: Updated to support the export of appliesToFunctions(functions) and SysOIDMaps(oids).
 - **Import-LMLogicModule**: Updated to support the import of appliesToFunctions(functions) and SysOIDMaps(oids) exported using *Export-LMLogicModule*.

 - **Set-LMPropertySource**: Updated to support tag modification. Use -Tags as an array of tags when updating a propertysource. There is also a -TagsMethod property that allows you to control the behavior when setting tags. **Add** will add specified tags to the existing list of tags on the module, and **Refresh** will replace the existing tags with the ones specified in the command. The default behavior is **Refresh**.
 - **Set-LMDataSource**: Updated to support tag modification. Use -Tags as an array of tags when updating a datasource. There is also a -TagsMethod property that allows you to control the behavior when setting tags. **Add** will add specified tags to the existing list of tags on the module, and **Refresh** will replace the existing tags with the ones specified in the command. The default behavior is **Refresh**.
 - **Set-LMConfigSource**: Updated to support tag modification. Use -Tags as an array of tags when updating a configsource. There is also a -TagsMethod property that allows you to control the behavior when setting tags. **Add** will add specified tags to the existing list of tags on the module, and **Refresh** will replace the existing tags with the ones specified in the command. The default behavior is **Refresh**.

 ```
 #Replace all existing tags with tag1 and tag2
 Set-LMDatasource -Id 123 -Tags @("tag1","tag2") -TagsMethod Refresh

 #Add tag1 and tag2 to the existing setting of tags
 Set-LMDatasource -Id 123 -Tags @("tag1","tag2") -TagsMethod Add
 ```


[Previous Release Notes](RELEASENOTES.md)

# License
Copyright, 2024, LogicMonitor, Inc.

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
