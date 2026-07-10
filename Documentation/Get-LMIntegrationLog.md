---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMIntegrationLog
---

# Get-LMIntegrationLog

## SYNOPSIS

Retrieves integration audit logs from LogicMonitor.

## SYNTAX

### Range (Default)

```
Get-LMIntegrationLog [-SearchString <string>] [-StartDate <datetime>] [-EndDate <datetime>]
 [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMIntegrationLog [-Id <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMIntegrationLog [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMIntegrationLogs function retrieves integration audit logs from LogicMonitor.
It supports retrieving logs by ID, date range, search string, or filter criteria.

## EXAMPLES

### EXAMPLE 1

#Retrieve logs for the last 30 days
Get-LMIntegrationLog

### EXAMPLE 2

#Retrieve logs with a specific search string and date range
Get-LMIntegrationLog -SearchString "error" -StartDate (Get-Date).AddDays(-7)

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

### -EndDate

The end date for retrieving logs.
Defaults to current time if not specified.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Range
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

A filter object to apply when retrieving logs.

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

The specific integration log ID to retrieve.

```yaml
Type: System.String
DefaultValue: ''
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

### -SearchString

A string to search for within the integration logs.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Range
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StartDate

The start date for retrieving logs.
Defaults to 30 days ago if not specified.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Range
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

### Returns LogicMonitor.IntegrationLog objects.

## NOTES

You must run Connect-LMAccount before running this command.
There is a 10,000 record query limitation for this endpoint.

## RELATED LINKS

