---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: ConvertTo-LMUptimeDevice
---

# ConvertTo-LMUptimeDevice

## SYNOPSIS

Migrates LogicMonitor website checks to LM Uptime devices.

## SYNTAX

### __AllParameterSets

```
ConvertTo-LMUptimeDevice [-Website] <psobject> [[-NamePrefix] <string>] [[-NameSuffix] <string>]
 [-TargetHostGroupIds] <string[]> [-DisableSourceAlerting] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

ConvertTo-LMUptimeDevice consumes objects returned by Get-LMWebsite, translates their
configuration into the v3 Uptime payload shape, and provisions new Uptime devices by invoking
New-LMUptimeDevice.
The cmdlet preserves alerting behaviour, polling thresholds, locations,
and scripted web steps whenever possible.

## EXAMPLES

### EXAMPLE 1

Get-LMWebsite -Name "logicmonitor.com" | ConvertTo-LMUptimeDevice -NameSuffix "-uptime"

Migrates the logicmonitor.com website check to an Uptime device with a "-uptime" suffix.

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

### -DisableSourceAlerting

When specified, disables alerting on the source website after the Uptime device is created successfully.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
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

### -NamePrefix

Optional string prefixed to the generated Uptime device name.

```yaml
Type: System.String
DefaultValue: ''
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

### -NameSuffix

Optional string appended to the generated Uptime device name.

```yaml
Type: System.String
DefaultValue: ''
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

### -TargetHostGroupIds

Explicit host group identifiers for the new device.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Website

Website object returned by Get-LMWebsite.
Accepts pipeline input.

```yaml
Type: System.Management.Automation.PSObject
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
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

### PSObject. Website objects returned by Get-LMWebsite can be piped to this cmdlet.

### System.Management.Automation.PSObject

## OUTPUTS

### LogicMonitor.LMUptimeDevice

## NOTES

You must run Connect-LMAccount prior to execution.
The cmdlet honours -WhatIf/-Confirm
through ShouldProcess.

## RELATED LINKS

- [Get-LMWebsite]()
- [New-LMUptimeDevice]()
- [Get-LMUptimeDevice]()
