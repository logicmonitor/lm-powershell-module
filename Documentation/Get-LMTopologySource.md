---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMTopologySource
---

# Get-LMTopologySource

## SYNOPSIS

Retrieves topology sources from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMTopologySource [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMTopologySource [-Id <int>] [-BatchSize <int>] [<CommonParameters>]
```

### Name

```
Get-LMTopologySource [-Name <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMTopologySource [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMTopologySource function retrieves topology source configurations from LogicMonitor.
It can retrieve all sources, a specific source by ID or name, or filter the results.

## EXAMPLES

### EXAMPLE 1

#Retrieve all topology sources
Get-LMTopologySource

### EXAMPLE 2

#Retrieve a specific topology source by name
Get-LMTopologySource -Name "Network-Discovery"

## PARAMETERS

### -BatchSize

The number of results to return per request.
Must be between 1 and 1000.
Defaults to 1000.

```yaml
Type: System.Int32
DefaultValue: 1000
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

### -Filter

A filter object to apply when retrieving topology sources.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter
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

The ID of the specific topology source to retrieve.

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

The name of the specific topology source to retrieve.

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

### Returns LogicMonitor.Topologysource objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

