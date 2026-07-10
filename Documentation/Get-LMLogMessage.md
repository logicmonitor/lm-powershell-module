---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMLogMessage
---

# Get-LMLogMessage

## SYNOPSIS

Retrieves log messages from LogicMonitor.

## SYNTAX

### Range-Async (Default)

```
Get-LMLogMessage [-Query <string>] [-Range <string>] [-BatchSize <int>] [-MaxPages <int>] [-Async]
 [<CommonParameters>]
```

### Date-Async

```
Get-LMLogMessage -StartDate <datetime> -EndDate <datetime> [-Query <string>] [-BatchSize <int>]
 [-MaxPages <int>] [-Async] [<CommonParameters>]
```

### Date-Sync

```
Get-LMLogMessage -StartDate <datetime> -EndDate <datetime> [-Query <string>] [-BatchSize <int>]
 [<CommonParameters>]
```

### Range-Sync

```
Get-LMLogMessage [-Query <string>] [-Range <string>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMLogMessage function retrieves log messages from LogicMonitor based on specified time ranges or date ranges.
It supports both synchronous and asynchronous queries with pagination control.

## EXAMPLES

### EXAMPLE 1

#Retrieve logs for a specific date range
Get-LMLogMessage -StartDate (Get-Date).AddDays(-1) -EndDate (Get-Date)

### EXAMPLE 2

#Retrieve logs asynchronously with a custom query
Get-LMLogMessage -Range "1hour" -Query "error" -Async

## PARAMETERS

### -Async

Switch to enable asynchronous query mode.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Range-Async
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Date-Async
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -BatchSize

The number of results to return per request.
Must be between 1 and 300.
Defaults to 300.

```yaml
Type: System.Int32
DefaultValue: 300
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

The end date for retrieving log messages.
Required for Date parameter sets.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Date-Async
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Date-Sync
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxPages

The maximum number of pages to retrieve in async mode.
Defaults to 10.

```yaml
Type: System.Int32
DefaultValue: 10
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Range-Async
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Date-Async
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Query

A query string to filter the log messages.

```yaml
Type: System.String
DefaultValue: ''
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

### -Range

The time range for retrieving log messages.
Valid values are "15min", "30min", "1hour", "3hour", "6hour", "12hour", "24hour", "3day", "7day", "1month".
Defaults to "15min".

```yaml
Type: System.String
DefaultValue: 15min
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Range-Async
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Range-Sync
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

The start date for retrieving log messages.
Required for Date parameter sets.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Date-Async
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Date-Sync
  Position: Named
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

### Returns LogicMonitor.LMLogs objects.

## NOTES

You must run Connect-LMAccount before running this command.
This command is reserver for internal use only.

## RELATED LINKS

