---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMLogAlert
---

# Get-LMLogAlert

## SYNOPSIS

Retrieves log alert processors from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMLogAlert [<CommonParameters>]
```

### Id

```
Get-LMLogAlert [-Id <int>] [<CommonParameters>]
```

### Name

```
Get-LMLogAlert [-Name <string>] [<CommonParameters>]
```

### PipelineId

```
Get-LMLogAlert [-PipelineId <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMLogAlert function retrieves log alert processor configurations from LogicMonitor.
It can retrieve all processors, a specific processor by ID or name, or filter by parent pipeline ID.

## EXAMPLES

### EXAMPLE 1

Get-LMLogAlert

### EXAMPLE 2

Get-LMLogAlert -PipelineId 10

### EXAMPLE 3

Get-LMLogAlert -Name "High Error Rate"

## PARAMETERS

### -Id

The ID of the specific log alert processor to retrieve.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the specific log alert processor to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PipelineId

The ID of the parent log alert group (pipeline) to filter processors by.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PipelineId
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

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns LogicMonitor.LogAlert objects.

## NOTES

You must run Connect-LMAccount before running this command.
Log alerts are processor rules within a log pipeline.
This cmdlet does not retrieve active log alert instances;
use Get-LMAlert -Type logAlert for active alerts.

## RELATED LINKS

