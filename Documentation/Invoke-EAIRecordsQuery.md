---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/27/2026
PlatyPS schema version: 2024-05-01
title: Invoke-EAIRecordsQuery
---

# Invoke-EAIRecordsQuery

## SYNOPSIS

Searches Edwin records using the UI Query API.

## SYNTAX

### Parameterized (Default)

```
Invoke-EAIRecordsQuery -RecordType <string> [-Field <string[]>] [-Filter <Object>]
 [-Timezone <string>] [-Order <Object>] [-OrderField <string>] [-OrderDirection <string>]
 [-Size <int>] [-ElasticQuery <Object>] [-AsResponse] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### RequestBody

```
Invoke-EAIRecordsQuery -RequestBody <Object> [-AsResponse] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Invoke-EAIRecordsQuery posts a filter-based search to POST /ui/query/records and returns matching
records for events, alerts, or insights.

Use -RequestBody to pass a complete JSON request when cmdlet parameters are insufficient.

Run Get-EAIQueryField to list common query field names for -Field, -OrderField, and filters.
Query field paths (for example meta.eventTimestamp) often differ from properties on returned records.

## EXAMPLES

### EXAMPLE 1

Invoke-EAIRecordsQuery -RecordType events

### EXAMPLE 2

Invoke-EAIRecordsQuery -RecordType events -Field '_id','cf.eventName','cf.eventSeverity'

### EXAMPLE 3

$filter = Build-EAIQueryFilter -PassThru
Invoke-EAIRecordsQuery -RecordType events -Field '_id','cf.eventName','cf.eventSeverity' -Filter $filter

### EXAMPLE 4

Invoke-EAIRecordsQuery -RecordType events `
    -Field '_id','cf.eventName' `
    -Filter (New-EAISdtFilterObject -Expression @{
        WITHIN = @(
            (New-EAISdtFilterFieldReference -Field 'cf.eventTime' -Type 'long')
            @{ unit = 'hour'; duration = 24 }
        )
    }) `
    -Size 25

### EXAMPLE 5

Invoke-EAIRecordsQuery -RecordType events -OrderField 'cf.eventName' -OrderDirection asc

### EXAMPLE 6

Invoke-EAIRecordsQuery -RequestBody (Get-Content ./query.json -Raw)

### EXAMPLE 7

Get-EAIQueryField -RecordType events -Usage Order

### EXAMPLE 8

Invoke-EAIRecordsQuery -RecordType events -AsResponse

## PARAMETERS

### -AsResponse

Returns the full API envelope (meta and results) instead of unwrapped record objects.

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

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -ElasticQuery

Optional raw OpenSearch query object (advanced).

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Parameterized
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Field

Optional field names to return (for example _id, cf.eventName).
When omitted, fields is sent as
null and the API returns all available source fields (same as the Edwin UI).

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Fields
ParameterSets:
- Name: Parameterized
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

Optional filterCondition object from Build-EAIQueryFilter or a manual expression.
When omitted, the Edwin UI default filter for the record type is used (last 24 hours and
standard insightType handling).

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Parameterized
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Order

Optional advanced sort clauses as hashtables or objects with field and type (asc or desc).
Cannot be combined with -OrderField or -OrderDirection.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Parameterized
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OrderDirection

Sort direction: asc or desc.
Defaults to desc when -OrderField is specified alone.
When neither order parameters are specified, results sort by the record-type timestamp field descending.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Parameterized
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OrderField

Field to sort by (for example meta.eventTimestamp).
Defaults to the record-type timestamp field
when -OrderDirection is specified alone.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Parameterized
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RecordType

Record table to query: events, alerts, or insights.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Parameterized
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RequestBody

Complete request object or JSON string.
When specified, other body parameters are ignored.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: RequestBody
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Size

Maximum records to return (1-200).
Omit to use the API default of 10.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Parameterized
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Timezone

IANA timezone for relative time filters.
Defaults to the local system timezone.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Parameterized
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

### You can pipe a filter object to override the UI default when -RecordType is specified.

### System.Object

## OUTPUTS

### By default

## NOTES

Use Connect-EAIAccount before running this command.
Requires query_records API scope on the Edwin credentials.

## RELATED LINKS

