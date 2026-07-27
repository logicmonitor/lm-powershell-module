---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/27/2026
PlatyPS schema version: 2024-05-01
title: Get-EAIQueryRecord
---

# Get-EAIQueryRecord

## SYNOPSIS

Retrieves a single Edwin record by type and ID.

## SYNTAX

### __AllParameterSets

```
Get-EAIQueryRecord [-RecordType] <string> [-RecordId] <string> [-AsResponse] [<CommonParameters>]
```

## DESCRIPTION

Get-EAIQueryRecord fetches one record via GET /ui/query/record/{recordType}/{recordId}.
Record IDs may contain slash characters; the cmdlet URL-encodes the path segment automatically.

## EXAMPLES

### EXAMPLE 1

Get-EAIQueryRecord -RecordType events -RecordId 'LNDP-RTRPRD001_event_name_1537191059903'

### EXAMPLE 2

$record = Invoke-EAIRecordsQuery -RecordType events -Field '_id' -Size 1 | Select-Object -First 1
Get-EAIQueryRecord -RecordType events -RecordId $record._id

### EXAMPLE 3

Get-EAIQueryRecord -RecordType events -RecordId 'eventId/12345abc'

## PARAMETERS

### -AsResponse

Returns the full API envelope (meta and results) instead of a single record object.

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

### -RecordId

Record identifier (often the _id value from a records search).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RecordType

Record table: events, alerts, or insights.

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

### By default

## NOTES

Use Connect-EAIAccount before running this command.
Requires query_record API scope on the Edwin credentials.

## RELATED LINKS

