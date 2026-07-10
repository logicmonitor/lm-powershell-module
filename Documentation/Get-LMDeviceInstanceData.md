---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDeviceInstanceData
---

# Get-LMDeviceInstanceData

## SYNOPSIS

Retrieves data for LogicMonitor device instances.

## SYNTAX

### __AllParameterSets

```
Get-LMDeviceInstanceData [[-StartDate] <datetime>] [[-EndDate] <datetime>] [-Ids] <string[]>
 [[-AggregationType] <string>] [[-Period] <double>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDeviceInstanceData function retrieves monitoring data for specified device instances in LogicMonitor.
It supports data aggregation and time range filtering, with a maximum timeframe of 24 hours.

## EXAMPLES

### EXAMPLE 1

#Retrieve data for multiple instances with aggregation
Get-LMDeviceInstanceData -Ids "12345","67890" -AggregationType "average" -StartDate (Get-Date).AddHours(-12)

### EXAMPLE 2

#Retrieve raw data for a single instance
Get-LMDeviceInstanceData -Id "12345" -AggregationType "none"

## PARAMETERS

### -AggregationType

The type of aggregation to apply to the data.
Valid values are "first", "last", "min", "max", "sum", "average", "none".
Defaults to "none".

```yaml
Type: System.String
DefaultValue: none
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

### -EndDate

The end date for the data retrieval.
Defaults to current time if not specified.

```yaml
Type: System.DateTime
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

### -Ids

An array of device instance IDs for which to retrieve data.
This parameter is mandatory and can be specified using the Id alias.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Period

The period for data aggregation.
Defaults to 1 as this appears to be the only supported value.

```yaml
Type: System.Double
DefaultValue: 1
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

### -StartDate

The start date for the data retrieval.
Defaults to 24 hours ago if not specified.

```yaml
Type: System.DateTime
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns an array of data points for the specified device instances.

## NOTES

You must run Connect-LMAccount before running this command.
Maximum time range for data retrieval is 24 hours.

## RELATED LINKS

