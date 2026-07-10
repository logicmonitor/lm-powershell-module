---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMRecentlyDeleted
---

# Get-LMRecentlyDeleted

## SYNOPSIS

Retrieves recently deleted resources from the LogicMonitor recycle bin.

## SYNTAX

### __AllParameterSets

```
Get-LMRecentlyDeleted [[-ResourceType] <string>] [[-DeletedAfter] <datetime>]
 [[-DeletedBefore] <datetime>] [[-DeletedBy] <string>] [[-BatchSize] <int>] [[-Sort] <string>]
 [<CommonParameters>]
```

## DESCRIPTION

The Get-LMRecentlyDeleted function queries the LogicMonitor recycle bin for deleted resources
within a configurable time range.
Results can be filtered by resource type and deleted-by user,
and support paging through the API using size, offset, and sort parameters.

## EXAMPLES

### EXAMPLE 1

Get-LMRecentlyDeleted -ResourceType device -DeletedBy "lmsupport"

Retrieves every device deleted by the user lmsupport over the past seven days.

### EXAMPLE 2

Get-LMRecentlyDeleted -DeletedAfter (Get-Date).AddDays(-1) -DeletedBefore (Get-Date) -BatchSize 100 -Sort "+deletedOn"

Retrieves deleted resources from the past 24 hours in ascending order of deletion time.

## PARAMETERS

### -BatchSize

The number of records to request per API call (1-1000).
Defaults to 1000.

```yaml
Type: System.Int32
DefaultValue: 1000
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DeletedAfter

The earliest deletion timestamp (inclusive) to return.
Defaults to seven days prior when not specified.

```yaml
Type: System.Nullable`1[System.DateTime]
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

### -DeletedBefore

The latest deletion timestamp (exclusive) to return.
Defaults to the current time when not specified.

```yaml
Type: System.Nullable`1[System.DateTime]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DeletedBy

Limits results to items deleted by the specified user principal.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ResourceType

Limits results to a specific resource type.
Accepted values are All, device, and deviceGroup.
Defaults to All.

```yaml
Type: System.String
DefaultValue: All
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

### -Sort

Sort expression passed to the API.
Defaults to -deletedOn.

```yaml
Type: System.String
DefaultValue: -deletedOn
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
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

## OUTPUTS

## NOTES

You must establish a session with Connect-LMAccount prior to calling this function.

## RELATED LINKS

