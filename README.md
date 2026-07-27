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

# Edwin (EdwinAI) Usage

Edwin cmdlets use a separate OAuth2 session from LogicMonitor portal authentication. Run **Connect-EAIAccount** before any other `*-EAI*` command. LogicMonitor alerts are already sent to Edwin natively; use these cmdlets for third-party event ingestion, Edwin SDT management, and record search.

Credentials require the appropriate Edwin API scopes (for example `event_write`, `sdt_read`, `sdt_write`, `query_records`, `query_record`). Edwin cached accounts share the same SecretManagement vault as LM credentials and are stored with `Metadata.Type = 'EAI'`.

```powershell
# Connect with OAuth2 client credentials
Connect-EAIAccount -EdwinOrg "myorg" -ClientId "client-id" -ClientSecret "client-secret"

# Or use a cached Edwin account
New-EAICachedAccount -EdwinOrg "myorg" -ClientId "client-id" -ClientSecret "client-secret"
Connect-EAIAccount -CachedAccountName "myorg-edwin"

# Check connection status and disconnect when finished
Get-EAIAccountStatus
Disconnect-EAIAccount
```

### Authentication & cached credentials

```powershell
Get-EAICachedAccount
Get-EAICachedAccount -CachedAccountName "myorg-edwin"
Remove-EAICachedAccount -CachedAccountName "myorg-edwin"
```

### Event ingestion

```powershell
# Build and send a CEF event
$event = New-EAIEvent -EventCi "server01" -EventObject "disk" -EventSource "VendorX" `
    -EventName "Disk full" -EventDescription "Disk usage exceeded 90%" -Severity Major `
    -SourceRecord @{ host = "server01" }
Send-EAIEvents -Events $event

# Convert third-party objects and pipe to Send-EAIEvents
$data | Convert-EAIEvent -PropertyMap @{
    event_ci = 'HostName'
    event_name = 'AlertTitle'
    event_description = 'Details'
    event_object = 'Component'
    event_severity = 'Severity'
    event_source = { 'VendorX' }
} | ForEach-Object { Send-EAIEvents -Events $_ }
```

### Edwin SDT (scheduled downtime)

```powershell
# List schedules and instances
Get-EAISdt
Get-EAISdt -Id '6d18821f-8f3c-48ca-8331-3e4c8d77cac3'
Get-EAISdt -Id $id | Get-EAISdtInstance

# Build a filter and create a schedule
$filter = Build-EAISdtFilter -PassThru
New-EAISdt -Name "Weekly window" -Duration 60 -SdtType Weekly -WeekDay Monday -Filter $filter
New-EAISdt -ScheduleWizard

# Update a schedule
Set-EAISdt -Id $id -Enabled:$false
Set-EAISdt -ScheduleWizard

# Override a single instance (skip or reschedule)
$instances = Get-EAISdt -Id $id | Get-EAISdtInstance
$instances | Where-Object { $_.instanceId -like '*2026-07-22T16:00:00.000Z*' } |
    New-EAISdtOverride -Skip -Summary 'Holiday'
Remove-EAISdtOverride -InstanceId '97038d1b-648a-4718-b287-33726ed49624:2026-07-22T16:00:00.000Z'
Set-EAISdtOverride -ScheduleId $id -Clear
```

### Edwin record query

```powershell
# Discover query fields and build a filter
Get-EAIQueryField -RecordType events -Usage Order
$filter = Build-EAIQueryFilter -PassThru

# Search and retrieve individual records
Invoke-EAIRecordsQuery -RecordType events -Field '_id','cf.eventName','cf.eventSeverity' -Filter $filter
$record = Invoke-EAIRecordsQuery -RecordType events -Field '_id' -Size 1 | Select-Object -First 1
Get-EAIQueryRecord -RecordType events -RecordId $record._id
```

Full Edwin cmdlet reference: [https://logicmonitor.github.io/lm-powershell-module-docs/documentation/edwin/connect-eaiaccount/](https://logicmonitor.github.io/lm-powershell-module-docs/documentation/edwin/connect-eaiaccount/)

# Change List
## 7.9.6
### New Cmdlets — Edwin (EdwinAI)
- **Authentication**: `Connect-EAIAccount`, `Disconnect-EAIAccount`, `Get-EAIAccountStatus`
- **Cached credentials**: `New-EAICachedAccount`, `Get-EAICachedAccount`, `Remove-EAICachedAccount`
- **Event ingestion**: `New-EAIEvent`, `Convert-EAIEvent`, `Send-EAIEvents`
- **Edwin SDT**: `Get-EAISdt`, `Get-EAISdtInstance`, `New-EAISdt`, `Set-EAISdt`, `Build-EAISdtFilter`, `New-EAISdtOverride`, `Set-EAISdtOverride`, `Remove-EAISdtOverride`
- **Record query**: `Build-EAIQueryFilter`, `Get-EAIQueryField`, `Invoke-EAIRecordsQuery`, `Get-EAIQueryRecord`

### Updated Cmdlets
- **Get-LMAPIToken**: When `-Type` is `*` (default), now queries both LMv1 and Bearer token endpoints. The API only returns LMv1 tokens when `type` is omitted, so a second request with `type=bearer` is required to return all token types.

### Bug Fixes & Changes
- **Connect-LMAccount**: Cached credential selection now excludes Edwin (EAI) entries stored in the shared SecretManagement vault, so `Connect-LMAccount -UseCachedCredential` only lists LM portal accounts.
- **Connect-EAIAccount**: Validates credentials with an OAuth token grant on connect. Use `-SkipCredValidation` to skip local field checks and the remote probe.
- **Module layout**: Public cmdlets are organized under `Public/LM/` and `Public/EAI/`. Cmdlet names and behavior are unchanged; only internal file paths differ.

[Previous Release Notes](RELEASENOTES.md)

# License
Copyright, 2026, LogicMonitor, Inc.

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
