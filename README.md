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

## 7.4
### New Cmdlets:
 - **Export-LMDashboard**: Exports dashboard information from LogicMonitor to a JSON file. This is the same file you would get from performing an export from your LM portal. (requested via @AUrhino)

 ```powershell
#Export a dashboard to a JSON file
Export-LMDashboard -Id 123 -FilePath "C:\temp"
```

### Minor Changes:
 - All payload formating is now done through a centralized *Format-LMData* function. A bug was reported where trying to refresh properties to clear a resources custom property list would resulting in the empty customProperties payload getting stripped during formating. (reported via @aggie87).
 - An issue was discovered where rate limits could be hit without rate limit backoff being applied. As a result of this change we have over hauled the error handling in this version to ensure all cmdlets properly respect any *-ErrorAction* perferences you have specified.
   - While we do not anticipate any issues with these changes, they do touch pretty much every cmdlet in this module, please report any issues you encounter when using this version.
 - Increased integration testing coverage to +130 tests accross many of the different cmdlets in the suite.
 - This version of the module cleans up a lot of the tech debt aquired over the years and aims to make the module easier to maintain and for the community to contribute to moving forward.

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
