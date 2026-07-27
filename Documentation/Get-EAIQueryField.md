---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/27/2026
PlatyPS schema version: 2024-05-01
title: Get-EAIQueryField
---

# Get-EAIQueryField

## SYNOPSIS

Lists common Edwin query field names for filters, sorting, and field projection.

## SYNTAX

### __AllParameterSets

```
Get-EAIQueryField [[-RecordType] <string>] [[-Usage] <string>] [<CommonParameters>]
```

## DESCRIPTION

Get-EAIQueryField returns the query-path field names used by Invoke-EAIRecordsQuery,
Build-EAIQueryFilter, and related Edwin UI Query APIs.
These names often differ from
properties on objects returned by the API (for example meta.eventTimestamp vs cf.eventTime).

Use this cmdlet to discover valid -OrderField, -Field, and filter field references before
building queries.

## EXAMPLES

### EXAMPLE 1

Get-EAIQueryField

### EXAMPLE 2

Get-EAIQueryField -RecordType events -Usage Order

### EXAMPLE 3

Get-EAIQueryField -RecordType alerts -Usage Filter | Format-Table Field, Label, Type

## PARAMETERS

### -RecordType

Optional record table filter: events, alerts, or insights.

```yaml
Type: System.String
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

### -Usage

Optional usage filter: Filter, Order, or Return (field projection).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
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

### Returns Edwin.Query.Field objects describing each catalog entry.

## NOTES

Use Connect-EAIAccount before running Edwin query cmdlets.
The catalog lists commonly used fields; the API may support additional custom fields.

## RELATED LINKS

