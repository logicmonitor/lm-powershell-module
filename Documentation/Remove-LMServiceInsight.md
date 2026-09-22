---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/22/2026
PlatyPS schema version: 2024-05-01
title: Remove-LMServiceInsight
---

# Remove-LMServiceInsight

## SYNOPSIS

Removes a LogicMonitor Service Insight, and by default its companion
aggregate "Health" DataSource.

## SYNTAX

### __AllParameterSets

```
Remove-LMServiceInsight [-Id] <int> [[-HardDelete] <bool>] [[-DataSourceAction] <string>] [-WhatIf]
 [-Confirm]
```

## DESCRIPTION

Removes a Service Insight (a DeviceType 6 device) via Remove-LMDevice.
By default also finds and removes any DataSource whose appliesTo
targets this Service Insight specifically (system.deviceId ==
"<id>") — the companion DataSource New-LMServiceInsight creates — so
the two objects it creates together are also removed together.
Use
-DataSourceAction Keep to leave any linked DataSource in place, or
-DataSourceAction Skip to skip looking for one entirely.

Finding the linked DataSource is scoped to DataSources associated with
this device (Get-LMDeviceDatasourceList), not a full-portal scan, then
narrowed to the one(s) whose appliesTo specifically references this
device's id — DataSources that merely happen to also apply broadly to
this device (e.g.
a portal-wide DataSource) are left alone.

## EXAMPLES

### EXAMPLE 1

Remove-LMServiceInsight -Id 129189

### EXAMPLE 2

#Permanently delete, leave any linked Health datasource alone
Remove-LMServiceInsight -Id 129189 -HardDelete $true -DataSourceAction Keep

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DataSourceAction

What to do about a linked "Health" DataSource (one whose appliesTo
targets this Service Insight's device id):
- Remove (default): find and remove it too.
- Keep: leave it in place (it will no longer collect anything
  meaningful once the Service Insight device is gone, but stays in the
  portal).
- Skip: don't look for one at all.

```yaml
Type: System.String
DefaultValue: Remove
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -HardDelete

If set, permanently deletes the Service Insight device instead of
moving it to the Recycle Bin.
Defaults to $false (soft delete), matching
Remove-LMDevice's own default.

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

The ID of the Service Insight to remove.
Mandatory.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### You can pipe objects containing an Id property to this function.

### System.Int32

## OUTPUTS

### Returns a PSCustomObject with .Device and .Datasource removal results
(.Datasource is $null if none was found/removed).

## NOTES

You must run Connect-LMAccount before running this command.
See New-LMServiceInsight for creating one.

## RELATED LINKS

