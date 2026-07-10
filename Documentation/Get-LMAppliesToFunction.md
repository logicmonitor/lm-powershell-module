---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMAppliesToFunction
---

# Get-LMAppliesToFunction

## SYNOPSIS

Retrieves AppliesTo functions from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMAppliesToFunction [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMAppliesToFunction [-Id <int>] [-BatchSize <int>] [<CommonParameters>]
```

### Name

```
Get-LMAppliesToFunction [-Name <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMAppliesToFunction [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMAppliesToFunction function retrieves AppliesTo functions from LogicMonitor based on specified criteria.
These functions are used in LogicModule configurations to determine which devices they apply to.

## EXAMPLES

### EXAMPLE 1

#Retrieve an AppliesTo function by ID
Get-LMAppliesToFunction -Id 123

### EXAMPLE 2

#Retrieve an AppliesTo function by name
Get-LMAppliesToFunction -Name "MyFunction"

### EXAMPLE 3

#Retrieve AppliesTo functions using a filter
Get-LMAppliesToFunction -Filter $filterObject

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

A filter object to apply when retrieving functions.
Part of a mutually exclusive parameter set.

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

The ID of the AppliesTo function to retrieve.
Part of a mutually exclusive parameter set.

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

The name of the AppliesTo function to retrieve.
Part of a mutually exclusive parameter set.

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

### Returns LogicMonitor.AppliesToFunction objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

