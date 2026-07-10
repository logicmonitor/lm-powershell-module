---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDashboardWidget
---

# Get-LMDashboardWidget

## SYNOPSIS

Retrieves dashboard widgets from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMDashboardWidget [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMDashboardWidget [-Id <int>] [-BatchSize <int>] [<CommonParameters>]
```

### Name

```
Get-LMDashboardWidget [-Name <string>] [-BatchSize <int>] [<CommonParameters>]
```

### DashboardId

```
Get-LMDashboardWidget [-DashboardId <string>] [-BatchSize <int>] [<CommonParameters>]
```

### DashboardName

```
Get-LMDashboardWidget [-DashboardName <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMDashboardWidget [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDashboardWidget function retrieves widget information from LogicMonitor dashboards.
It can return widgets by ID, name, or by their associated dashboard.

## EXAMPLES

### EXAMPLE 1

#Retrieve a widget by ID
Get-LMDashboardWidget -Id 123

### EXAMPLE 2

#Retrieve widgets from a specific dashboard
Get-LMDashboardWidget -DashboardName "Production Overview"

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

### -DashboardId

The ID of the dashboard to retrieve widgets from.
Part of a mutually exclusive parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DashboardId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DashboardName

The name of the dashboard to retrieve widgets from.
Part of a mutually exclusive parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DashboardName
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

A filter object to apply when retrieving widgets.
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

The ID of the widget to retrieve.
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

The name of the widget to retrieve.
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

### Returns LogicMonitor.DashboardWidget objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

