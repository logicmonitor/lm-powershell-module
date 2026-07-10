---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Import-LMExchangeModule
---

# Import-LMExchangeModule

## SYNOPSIS

Imports an LM Exchange module into LogicMonitor.

## SYNTAX

### __AllParameterSets

```
Import-LMExchangeModule [-LMExchangeId] <string> [<CommonParameters>]
```

## DESCRIPTION

The Import-LMExchangeModule function imports a specified LM Exchange module into your LogicMonitor portal.

## EXAMPLES

### EXAMPLE 1

#Import an LM Exchange module
Import-LMExchangeModule -LMExchangeId "LM12345"

## PARAMETERS

### -LMExchangeId

The ID of the LM Exchange module to import.
This parameter is mandatory.

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

### Returns a success message if the import is successful.

### System.String

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

