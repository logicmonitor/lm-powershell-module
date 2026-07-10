---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Invoke-LMNetScan
---

# Invoke-LMNetScan

## SYNOPSIS

Invokes a NetScan task in LogicMonitor.

## SYNTAX

### __AllParameterSets

```
Invoke-LMNetScan [-Id] <string> [<CommonParameters>]
```

## DESCRIPTION

The Invoke-LMNetScan function schedules execution of a specified NetScan task in LogicMonitor.

## EXAMPLES

### EXAMPLE 1

#Execute a NetScan
Invoke-LMNetScan -Id "12345"

## PARAMETERS

### -Id

The ID of the NetScan to execute.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
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

### Returns a success message if the NetScan is scheduled successfully.

### System.String

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

