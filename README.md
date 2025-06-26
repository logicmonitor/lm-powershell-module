[![Build PSGallery Release](https://github.com/logicmonitor/lm-powershell-module/actions/workflows/main.yml/badge.svg?event=release)](https://github.com/logicmonitor/lm-powershell-module/actions/workflows/main.yml)\
[![Test Current Build on PowerShell Core 7.4.1](https://github.com/logicmonitor/lm-powershell-module/actions/workflows/test.yml/badge.svg)](https://github.com/logicmonitor/lm-powershell-module/actions/workflows/test.yml)\
[![Test Current Build on Windows Powershell 5.1](https://github.com/logicmonitor/lm-powershell-module/actions/workflows/test-win.yml/badge.svg)](https://github.com/logicmonitor/lm-powershell-module/actions/workflows/test-win.yml)

# General

PowerShell module for accessing the LogicMonitor REST API.

This project is also published in the PowerShell Gallery at https://www.powershellgallery.com/packages/Logic.Monitor/.

Check out the full Logic.Monitor module documenation at: [https://logicmonitor.github.io/lm-powershell-module-docs/](https://logicmonitor.github.io/lm-powershell-module-docs/)


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

# Change List

## 7.3.1
### Introducing Automation Cmdlets:

This version of the Logic.Monitor module brings the first of many "automation" cmdlets that utilize the core API cmdlets to perform scripted actions within a LogicMonitor portal. These initial cmdlets have been asked for by the community and we are happy to be able to include them directly in the core Logic.Monitor powershell module. As always, please provide feedback and feature requests for automation/cmdlets you would like to see added in the future.

- **Invoke-LMDeviceDedupe**: Identifies and removes duplicate devices based on sysname or IP address matching. Helps clean up portals with duplicate device entries.
  ```powershell
  # List duplicates in a specific device group
  Invoke-LMDeviceDedupe -ListDuplicates -DeviceGroupId 8
  
  # Remove duplicates from entire portal
  Invoke-LMDeviceDedupe -RemoveDuplicates
  ```

- **Import-LMDevicesFromCSV**: Bulk imports devices from CSV file with support for custom properties and automatic device group creation.
  ```powershell
  # Import devices from CSV file
  Import-LMDevicesFromCSV -FilePath "C:\Devices.csv" -CollectorId 1234
  
  # Generate example CSV template
  Import-LMDevicesFromCSV -GenerateExampleCSV
  ```

- **Import-LMDeviceGroupsFromCSV**: Bulk imports device groups from CSV file with support for properties and AppliesTo logic.
  ```powershell
  # Import device groups from CSV
  Import-LMDeviceGroupsFromCSV -FilePath "C:\Groups.csv" -PassThru
  
  # Generate example CSV template
  Import-LMDeviceGroupsFromCSV -GenerateExampleCSV
  ```

- **Find-LMDashboardWidgets**: Searches all dashboard widgets for references to specific datasources. Useful for impact analysis before datasource changes.
  ```powershell
  # Find widgets using specific datasources
  Find-LMDashboardWidgets -DatasourceNames @("SNMP_NETWORK_INTERFACES","VMWARE_VCENTER_VM_PERFORMANCE")
  ```

- **Copy-LMDevicePropertyToGroup**: Copies custom properties from a device to device groups. Excludes sensitive credential properties.
  ```powershell
  # Copy properties from device to groups
  Copy-LMDevicePropertyToGroup -SourceDeviceId 123 -TargetGroupId 456,457 -PropertyNames "location","department"
  ```

- **Copy-LMDevicePropertyToDevice**: Copies custom properties between devices. Excludes sensitive credential properties.
  ```powershell
  # Copy properties between devices
  Copy-LMDevicePropertyToDevice -SourceDeviceId 123 -TargetDeviceId 456,457 -PropertyNames "location","department"
  ```


### Major Changes in v7:
 - **API Headers**: Updated all API request headers to use a custom User-Agent (Logic.Monitor-PowerShell-Module/Version) for usage reporting on versions deployed.

### Documentation Overhaul
We're excited to announce our new comprehensive documentation site at [https://logicmonitor.github.io/lm-powershell-module-docs/](https://logicmonitor.github.io/lm-powershell-module-docs/). The site includes:
- Detailed command reference information
- Code examples and snippets
- Best practices guides

### New Filter Wizard
Introducing the Filter Wizard, a new interactive tool to help build complex filters:
- Visual filter construction
- Support for all filter operators
- Real-time filter preview
- Available through `Build-LMFilter` or `-FilterWizard` parameter

```powershell
# Use the standalone filter builder
Build-LMFilter

# Use built-in filter wizard parameter
Get-LMDeviceGroup -FilterWizard
```
![Filter Wizard Example](https://logicmonitor.github.io/lm-powershell-module-docs/_astro/LMFilter.4g625cq9_1boMAv.webp)

[Previous Release Notes](RELEASENOTES.md)

# License
Copyright, 2024, LogicMonitor, Inc.

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
