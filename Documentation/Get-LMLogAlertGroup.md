---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMLogAlertGroup
---

# Get-LMLogAlertGroup

## SYNOPSIS

Retrieves log alert groups from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMLogAlertGroup [<CommonParameters>]
```

### Id

```
Get-LMLogAlertGroup [-Id <int>] [<CommonParameters>]
```

### Name

```
Get-LMLogAlertGroup [-Name <string>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMLogAlertGroup function retrieves log alert group (log pipeline) configurations from LogicMonitor.
It can retrieve all groups, a specific group by ID or name, or filter results client-side by name.

## EXAMPLES

### EXAMPLE 1

Get-LMLogAlertGroup

### EXAMPLE 2

Get-LMLogAlertGroup -Name "Production Logs"

## PARAMETERS

### -Id

The ID of the specific log alert group to retrieve.

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

The name of the specific log alert group to retrieve.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns LogicMonitor.LogAlertGroup objects.

## NOTES

You must run Connect-LMAccount before running this command.
Log alert groups manage log pipeline configuration.
This cmdlet does not retrieve active log alert instances;
use Get-LMAlert -Type logAlert for active alerts.

## RELATED LINKS

