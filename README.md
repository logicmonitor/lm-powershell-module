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

## 7.2.2
### Updated Cmdlets:
 - **Get-LMAlert**: Starting with portal version 222 you can now add the parameter -customColumns to your bulk alert requests to return up to 5 additional properties under the customColumn key. Previously this was limited to direct **/alert/alerts/$id** but has been opened up to all alert queries.

 ```powershell
 Get-LMAlert -customColumns "system.hostStatus,custom.prop,other.prop"
 ```

### New Cmdlets:
 - **Get-LMCostOptimizationRecommendations**: Cmdlet to the current recommendations available in Cost Optimization. When using filters, consult the LM API docs for allowed filter fields as not all fields support filtering at this time.

```powershell
#Retrieve cost optimization recommendations using a filter
Get-LMCostOptimizationRecommendations -Filter 'recommendationCategory -eq "Underutilized AWS EC2 instances"'
```

 - **Get-LMCostOptimizationRecommendationCategories**: Cmdlet to list the available categories available for recommendations. This cmdlet does not currently support filtering.

 - **Get-LMService**: Ease of use cmdlet to return service resource info. Currently Get-LMDevice returns these resources but a separate cmdlet has been created to easily distinguished between a device and service. All the same parameters supported in *Get-LMDevice* are supported with this cmdlet.

 - **Get-LMServiceMember**: Cmdlet to return members assigned to a service. Supports service retrieval by id, displayName and name.

 - **New-Recipient**: Utility cmdlet to assist in properly formating recipient arrays for use with *LMRecipientGroup cmdlets. See example for usage.

 - **New-RecipientGroup**: Cmdlet to create new recipient groups. Use the New-Recipient utility cmdlet to properly construct your recipient list.

 - **Set-RecipientGroup**: Cmdlet to update specified recipient groups. Supports pipeline input.

 - **Remove-RecipientGroup**: Cmdlet to remove specified recipient groups. Supports pipeline input.

```powershell
#This example creates a new LogicMonitor recipient group named "MyRecipientGroup" with a description and recipients built using the New-LMRecipient function.
$recipients = @(
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'email'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'sms'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'voice'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'smsemail'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method '<name_of_existing_integration>'
    New-LMRecipient -Type 'ARBITRARY' -Addr 'someone@other.com' -Method 'email'
    New-LMRecipient -Type 'GROUP' -Addr 'Helpdesk'
)
New-LMRecipientGroup -Name "MyRecipientGroup" -Description "This is a test recipient group" -Recipients $recipients

#This example updates a LogicMonitor recipient group named "MyRecipientGroupUpdated" with a description and recipients built using the New-LMRecipient function.
$recipients = @(
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'email'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'sms'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'voice'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'smsemail'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method '<name_of_existing_integration>'
    New-LMRecipient -Type 'ARBITRARY' -Addr 'someone@other.com' -Method 'email'
    New-LMRecipient -Type 'GROUP' -Addr 'Helpdesk'
)
Set-LMRecipientGroup -Id "1234567890" -NewName "MyRecipientGroupUpdated" -Description "This is a test recipient group updated" -Recipients $recipients
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
