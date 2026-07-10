---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Set-LMLogPartition
---

# Set-LMLogPartition

## SYNOPSIS

Updates a LogicMonitor Log Partition configuration.

## SYNTAX

### Id (Default)

```
Set-LMLogPartition [-Id <int>] [-Description <string>] [-Retention <int>] [-Sku <string>]
 [-Status <string>] [-ContractIntervalHours <int>] [-AutoRestartOnRenewal <bool>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### IdUsageLimit

```
Set-LMLogPartition -Id <int> -UsageLimit <string> -StopIngestionOnLimit <bool>
 [-Description <string>] [-Retention <int>] [-Sku <string>] [-Status <string>]
 [-ContractIntervalHours <int>] [-AutoRestartOnRenewal <bool>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### NameUsageLimit

```
Set-LMLogPartition -Name <string> -UsageLimit <string> -StopIngestionOnLimit <bool>
 [-Description <string>] [-Retention <int>] [-Sku <string>] [-Status <string>]
 [-ContractIntervalHours <int>] [-AutoRestartOnRenewal <bool>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name

```
Set-LMLogPartition -Name <string> [-Description <string>] [-Retention <int>] [-Sku <string>]
 [-Status <string>] [-ContractIntervalHours <int>] [-AutoRestartOnRenewal <bool>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Set-LMLogPartition function modifies an existing log partition in LogicMonitor.

## EXAMPLES

### EXAMPLE 1

Set-LMLogPartition -Id 123 -Description "New description" -Retention 30 -Status "active"
Updates the log partition with ID 123 with a new description, retention, and status.

### EXAMPLE 2

Set-LMLogPartition -Id 123 -UsageLimit "100GB" -StopIngestionOnLimit $true -AutoRestartOnRenewal $true
Updates usage limit controls for the log partition with ID 123.

## PARAMETERS

### -AutoRestartOnRenewal

When true, ingestion automatically restarts on contract renewal.

```yaml
Type: System.Boolean
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

### -ContractIntervalHours

The contract interval in hours.
0 = monthly (1st of next month), 24 = daily, 168 = weekly (next Monday), or a custom hour value.

```yaml
Type: System.Int32
DefaultValue: 0
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

### -Description

Specifies the new description for the log partition.

```yaml
Type: System.String
DefaultValue: ''
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

### -Id

Specifies the ID of the log partition to modify.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: IdUsageLimit
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
- Name: Id
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

Specifies the current name of the log partition.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NameUsageLimit
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Retention

Specifies the new retention for the log partition.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
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

### -Sku

Specifies the new sku for the log partition.

```yaml
Type: System.String
DefaultValue: ''
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

### -Status

Specifies the new status for the log partition.
Possible values are "active" or "inactive".

```yaml
Type: System.String
DefaultValue: ''
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

### -StopIngestionOnLimit

When true, ingestion stops when the usage limit is exceeded.
Use with the UsageLimit parameter set together with UsageLimit.

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NameUsageLimit
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdUsageLimit
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UsageLimit

The usage limit for the log partition contract, for example 100GB.
Use with the UsageLimit parameter set together with StopIngestionOnLimit.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NameUsageLimit
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdUsageLimit
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
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

## OUTPUTS

### Returns a LogicMonitor.LogPartition object containing the updated log partition information.

## NOTES

This function requires a valid LogicMonitor API authentication.

## RELATED LINKS

