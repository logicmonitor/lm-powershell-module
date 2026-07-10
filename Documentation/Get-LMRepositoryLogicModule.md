---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMRepositoryLogicModule
---

# Get-LMRepositoryLogicModule

## SYNOPSIS

Retrieves LogicModules from the LogicMonitor repository.

## SYNTAX

### __AllParameterSets

```
Get-LMRepositoryLogicModule [[-Type] <string>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMRepositoryLogicModule function retrieves LogicModules from the LogicMonitor repository.
It supports retrieving different types of modules including datasources, property rules, event sources, topology sources, and config sources.

## EXAMPLES

### EXAMPLE 1

#Retrieve all datasource modules
Get-LMRepositoryLogicModule

### EXAMPLE 2

#Retrieve all event source modules
Get-LMRepositoryLogicModule -Type "eventsource"

## PARAMETERS

### -Type

The type of LogicModule to retrieve.
Valid values are "datasource", "propertyrules", "eventsource", "topologysource", "configsource".
Defaults to "datasource".

```yaml
Type: System.String
DefaultValue: datasource
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
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

### Returns LogicMonitor.RepositoryLogicModules objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

