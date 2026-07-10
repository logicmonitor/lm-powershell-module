---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Import-LMRepositoryLogicModule
---

# Import-LMRepositoryLogicModule

## SYNOPSIS

Imports LogicMonitor repository logic modules.

## SYNTAX

### __AllParameterSets

```
Import-LMRepositoryLogicModule [-Type] <string> [-LogicModuleNames] <string[]> [<CommonParameters>]
```

## DESCRIPTION

The Import-LMRepositoryLogicModule function imports specified logic modules from the LogicMonitor repository into your portal.

## EXAMPLES

### EXAMPLE 1

#Import specific datasources
Import-LMRepositoryLogicModule -Type "datasources" -LogicModuleNames "DataSource1", "DataSource2"

## PARAMETERS

### -LogicModuleNames

An array of logic module names to import.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Name
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Type

The type of logic modules to import.
Valid values are "datasources", "propertyrules", "eventsources", "topologysources", "configsources".

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

### System.String[]

## OUTPUTS

### Returns a success message with the names of imported modules.

### System.String

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

