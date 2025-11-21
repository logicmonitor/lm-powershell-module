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

## 7.7.2
### Hotfixes
- **Send-LMWebhookMessage**: Fixed payload formatting when sending webhook messages to LM Logs:
  - JSON strings are now automatically detected and parsed into structured data, preventing escaped JSON in payloads
  - Plain text messages are properly encapsulated in a `message` property for consistent parsing
  - Removed unnecessary payload wrapping that caused ingestion issues
- **Resolve-LMDebugInfo**: Fix bug where BearerTokens were not being obfuscated when running commands with the -Debug parameter.

```powershell
#Sends multiple PSCustomObject events with additional properties merged into each payload.
$events = @(
    [PSCustomObject]@{ eventType = "login"; user = "john.doe"; status = "success" }
    [PSCustomObject]@{ eventType = "logout"; user = "jane.smith"; status = "success" }
)
Send-LMWebhookMessage -SourceName "AuthEvents" -Messages $events -Properties @{ source = "AD"; region = "us-east-1" }

#Sends a hashtable as a structured event and returns the result with status information.
$event = @{
    eventType = "deployment"
    version = "1.2.3"
    environment = "production"
    timestamp = (Get-Date).ToString("o")
}
Send-LMWebhookMessage -SourceName "Deployments" -Messages @($event) -PassThru
```

## 7.7.1
### Hotfixes
- Fix bug with **ConvertTo-LMUpdateDevice** when trying to migrate Websites using an packet count of 50.
- Add missing parameter descriptions to 17 cmdlets.
- Automate future help/doc generation when a new release is published.

## 7.7.0

### New Cmdlets
- **Get-LMRecentlyDeleted**: Retrieve recycle-bin entries with optional date, resource type, and deleted-by filters.
- **Restore-LMRecentlyDeleted**: Batch restore recycle-bin items by recycle identifier.
- **Remove-LMRecentlyDeleted**: Permanently delete recycle-bin entries in bulk.
- **Get-LMIntegration**: Retrieve integration configurations from LogicMonitor.
- **Remove-LMIntegration**: Remove integrations by ID or name.
- **Remove-LMEscalationChain**: Remove escalation chains by ID or name.
- **Invoke-LMReportExecution**: Trigger on-demand execution of LogicMonitor reports with optional admin impersonation and custom email recipients.
- **Get-LMReportExecutionTask**: Check the status and retrieve results of previously triggered report executions.
- **Invoke-LMAPIRequest**: Universal API request cmdlet for advanced users to access any LogicMonitor API endpoint with custom payloads while leveraging module authentication, retry logic, and debug utilities.
- **Import-LMLogicModuleFromFile**: Import LogicModules using the new XML and JSON import endpoints with enhanced features including field preservation and conflict handling options. Supports datasources, configsources, eventsources, batchjobs, logsources, oids, topologysources, functions, and diagnosticsources.

### Updated Cmdlets
- **Update-LogicMonitorModule**: Hardened for non-blocking version checks; failures are logged via `Write-Verbose` and never terminate connecting cmdlets.
- **Export-LMDeviceData**: CSV exports now expand datapoints into individual rows and JSON exports capture deeper datapoint structures.
- **Set-LMWebsite**: Added `alertExpr` alias for `SSLAlertThresholds` parameter for improved API compatibility. Updated synopsis to reflect enhanced parameter validation.
- **New-LMWebsite**: Added `alertExpr` alias for `SSLAlertThresholds` parameter for improved API compatibility.
- **Format-LMFilter**: Enhanced filter string escaping to properly handle special characters like parentheses, dollar signs, ampersands, and brackets in filter expressions.
- **Import-LMLogicModule**: Marked as deprecated with warnings. Users should migrate to `Import-LMLogicModuleFromFile` for access to newer API endpoints and features.

### Bug Fixes
- **Add-ObjectTypeInfo**: Fixed "Cannot bind argument to parameter 'InputObject' because it is null" error by adding `[AllowNull()]` attribute to handle successful but null API responses.
- **Resolve-LMDebugInfo**: Improved HTTP method detection logic to correctly identify request types (GET, POST, PATCH, DELETE) based on cmdlet naming conventions and headers, fixing incorrect debug output.
- **Invoke-LMRestMethod**: Added cleanup of internal `__LMMethod` diagnostic header before dispatching requests to prevent API errors.

### Examples
```powershell
# Retrieve all recently deleted devices for the past seven days
Get-LMRecentlyDeleted -ResourceType device -DeletedBy "lmsupport" -Verbose

# Restore a previously deleted device and confirm the operation
Get-LMRecentlyDeleted -ResourceType device | Select-Object -First 1 -ExpandProperty id | Restore-LMRecentlyDeleted -Confirm:$false

# Permanently remove stale recycle-bin entries
Get-LMRecentlyDeleted -DeletedAfter (Get-Date).AddMonths(-1) | Select-Object -ExpandProperty id | Remove-LMRecentlyDeleted -Confirm:$false

# Export device datapoints to CSV with flattened datapoint rows
Export-LMDeviceData -DeviceId 12345 -StartDate (Get-Date).AddHours(-6) -ExportFormat csv -ExportPath "C:\\Exports"

# Retrieve all integrations
Get-LMIntegration

# Remove an integration by name
Remove-LMIntegration -Name "Slack-Integration"

# Remove an escalation chain by ID
Remove-LMEscalationChain -Id 123

# Trigger a report execution and check its status
$task = Invoke-LMReportExecution -Name "Monthly Availability" -WithAdminId 101 -ReceiveEmails "ops@example.com"
Get-LMReportExecutionTask -ReportName "Monthly Availability" -TaskId $task.taskId

# Use the universal API request cmdlet for endpoints
Invoke-LMAPIRequest -ResourcePath "/setting/integrations" -Method GET -QueryParams @{ size = 500 }

# Create a device with full control
$customData = @{
    name = "1.1.1.1"
    displayName = "Custom Device"
    preferredCollectorId = 76
    deviceType = 0
    customProperties = @(
        @{name="propname";value="value"}
    )
}
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method POST -Data $customData -Version 3

# Import a LogicModule from file with the new endpoint
Import-LMLogicModuleFromFile -FilePath "C:\LogicModules\datasource.json" -Type datasources -Format json

# Import with conflict handling and field preservation
Import-LMLogicModuleFromFile -FilePath "C:\LogicModules\datasource.json" -Type datasources -Format json -HandleConflict FORCE_OVERWRITE -FieldsToPreserve NAME

# Import from file data variable
$fileContent = Get-Content -Path "C:\LogicModules\eventsource.xml" -Raw
Import-LMLogicModuleFromFile -File $fileContent -Type eventsources -Format xml
```


---

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
