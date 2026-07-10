---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMAlertRule
---

# Get-LMAlertRule

## SYNOPSIS

Retrieves alert rules from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMAlertRule [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMAlertRule [-Id <int>] [-BatchSize <int>] [<CommonParameters>]
```

### Name

```
Get-LMAlertRule [-Name <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMAlertRule [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMAlertRule function retrieves alert rules from LogicMonitor based on specified criteria.
It can return a single rule by ID or name, or multiple rules using filters.

## EXAMPLES

### EXAMPLE 1

#Retrieve an alert rule by ID
Get-LMAlertRule -Id 123

### EXAMPLE 2

#Retrieve an alert rule by name
Get-LMAlertRule -Name "High CPU Usage"

### EXAMPLE 3

#Retrieve alert rules using a filter
Get-LMAlertRule -Filter $filterObject

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

A filter object to apply when retrieving alert rules.
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

The ID of the alert rule to retrieve.
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

The name of the alert rule to retrieve.
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

### Returns LogicMonitor.AlertRule objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

