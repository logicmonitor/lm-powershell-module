---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMAlert
---

# Get-LMAlert

## SYNOPSIS

Retrieves alerts from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMAlert [-Severity <string>] [-Type <string>] [-ClearedAlerts <bool>]
 [-CustomColumns <string[]>] [-BatchSize <int>] [-Sort <string>] [<CommonParameters>]
```

### Range

```
Get-LMAlert [-StartDate <datetime>] [-EndDate <datetime>] [-Severity <string>] [-Type <string>]
 [-ClearedAlerts <bool>] [-CustomColumns <string[]>] [-BatchSize <int>] [-Sort <string>]
 [<CommonParameters>]
```

### Id

```
Get-LMAlert -Id <string> [-Severity <string>] [-Type <string>] [-ClearedAlerts <bool>]
 [-CustomColumns <string[]>] [-BatchSize <int>] [-Sort <string>] [<CommonParameters>]
```

### Filter

```
Get-LMAlert [-Severity <string>] [-Type <string>] [-ClearedAlerts <bool>] [-Filter <Object>]
 [-CustomColumns <string[]>] [-BatchSize <int>] [-Sort <string>] [<CommonParameters>]
```

### FilterWizard

```
Get-LMAlert [-Severity <string>] [-Type <string>] [-ClearedAlerts <bool>] [-FilterWizard]
 [-CustomColumns <string[]>] [-BatchSize <int>] [-Sort <string>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMAlert function retrieves alerts from LogicMonitor based on specified criteria.
It supports filtering by date range, severity, type, and cleared status.

## EXAMPLES

### EXAMPLE 1

#Retrieve alerts from the last 7 days
Get-LMAlert -StartDate (Get-Date).AddDays(-7) -Severity "Error"

### EXAMPLE 2

#Retrieve a specific alert with custom columns
Get-LMAlert -Id 12345 -CustomColumns "Column1","Column2"

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

### -ClearedAlerts

Whether to include cleared alerts.
Defaults to $false.

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -CustomColumns

Array of custom column names to include in the results.

```yaml
Type: System.String[]
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

### -EndDate

The end date for retrieving alerts.
Defaults to current time.

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

A filter object to apply when retrieving alerts.
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

### -FilterWizard

Switch to use the filter wizard interface.
Part of a mutually exclusive parameter set.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: FilterWizard
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

The specific alert ID to retrieve.
This parameter is part of a mutually exclusive parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Severity

The severity level to filter alerts by.
Valid values are "*", "Warning", "Error", "Critical".
Defaults to "*".

```yaml
Type: System.String
DefaultValue: '*'
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

### -Sort

The field to sort results by.
Defaults to "+resourceId".

```yaml
Type: System.String
DefaultValue: +resourceId
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

### -StartDate

The start date for retrieving alerts.
Defaults to 0 (beginning of time).

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

### -Type

The type of alerts to retrieve.
Valid values are "*", "websiteAlert", "dataSourceAlert", "eventAlert", "logAlert".
Defaults to "*".

```yaml
Type: System.String
DefaultValue: '*'
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

### Returns LogicMonitor.Alert objects.

## NOTES

You must run Connect-LMAccount before running this command.
Maximum of 10000 alerts can be retrieved in a single query.

## RELATED LINKS

