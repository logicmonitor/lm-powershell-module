---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/27/2026
PlatyPS schema version: 2024-05-01
title: Build-EAIQueryFilter
---

# Build-EAIQueryFilter

## SYNOPSIS

Builds a filter expression for Edwin record queries.

## SYNTAX

### __AllParameterSets

```
Build-EAIQueryFilter [[-ExistingFilter] <Object>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

Build-EAIQueryFilter interactively creates a filterCondition schema version 4 object for use with
Invoke-EAIRecordsQuery and other Edwin UI Query cmdlets.

The completed filter is saved to the global `$EAIQueryFilter` variable.
The same filter DSL is used
for SDT schedules and record queries.

## EXAMPLES

### EXAMPLE 1

Build-EAIQueryFilter

### EXAMPLE 2

$filter = Build-EAIQueryFilter -PassThru
Invoke-EAIRecordsQuery -RecordType events -Field '_id','cf.eventName' -Filter $filter

### EXAMPLE 3

Build-EAIQueryFilter -ExistingFilter $filter

## PARAMETERS

### -ExistingFilter

Optional current filter to keep or replace when refining a query.

```yaml
Type: System.Object
DefaultValue: ''
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

### -PassThru

Returns the filter object instead of only saving it to `$EAIQueryFilter`.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns an Edwin filter object when using -PassThru.

## NOTES

Use Connect-EAIAccount before running Edwin query cmdlets.
Requires query_records scope on the credentials used for Invoke-EAIRecordsQuery.

## RELATED LINKS

