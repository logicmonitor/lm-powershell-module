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
## 7.9.4
### Bug Fixes
- **Connect-LMAccount / New-LMCachedAccount / Get-LMCachedAccount**: Fixed an issue where cached credentials did not work for FedRAMP (GovCloud) portals on `lmgov.us`. `New-LMCachedAccount` now supports `-GovCloud` to persist the portal type in cached metadata, `Connect-LMAccount` restores that setting when connecting via `-UseCachedCredential` or `-CachedAccountName`, and `Get-LMCachedAccount` now includes a `GovCloud` property. Existing FedRAMP cached entries must be re-cached with `-GovCloud -OverwriteExisting $true`.

### Migration Example (FedRAMP / GovCloud cached credentials)
```powershell
# Review existing cached accounts and confirm GovCloud is not set
Get-LMCachedAccount

# Re-cache FedRAMP credentials with GovCloud enabled (overwrite the existing entry)
New-LMCachedAccount -AccessId "lm_access_id" -AccessKey "lm_access_key" -AccountName "agency" -CachedAccountName "agency-fedramp" -GovCloud -OverwriteExisting $true

# Verify GovCloud is now stored in metadata
Get-LMCachedAccount -CachedAccountName "agency-fedramp"

# Connect using the updated cached credential
Connect-LMAccount -CachedAccountName "agency-fedramp"
```

[Previous Release Notes](RELEASENOTES.md)

# License
Copyright, 2024, LogicMonitor, Inc.

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
