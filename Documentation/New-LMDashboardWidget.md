---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/22/2026
PlatyPS schema version: 2024-05-01
title: New-LMDashboardWidget
---

# New-LMDashboardWidget

## SYNOPSIS

Creates a new LogicMonitor dashboard widget.

## SYNTAX

### __AllParameterSets

```
New-LMDashboardWidget [-Widget] <Object> [-WhatIf] [-Confirm]
```

## DESCRIPTION

The New-LMDashboardWidget function creates a widget on a dashboard from
a raw widget configuration object.
Widget shape varies significantly by
type (cgraph, dynamicTable, bignumber, noc, deviceSLA, etc.) - this
cmdlet does not attempt to normalize that; pass the full object matching
what Get-LMDashboardWidget returns for the type you want (minus id/
lastUpdatedOn/lastUpdatedBy/userPermission, which the API sets).

## EXAMPLES

### EXAMPLE 1

$widget = @{
    name = "My Table"
    type = "dynamicTable"
    dashboardId = 123
    dataSourceId = 456
    columns = @(...)
    rows = @(@{label="##RESOURCENAME##"; groupFullPath="*"; deviceDisplayName="*"; instanceName="*"})
}
New-LMDashboardWidget -Widget $widget

## PARAMETERS

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

### -Widget

A PSCustomObject or hashtable containing the widget configuration,
matching the shape LogicMonitor's API expects for that widget's type
(see an existing widget of the same type via Get-LMDashboardWidget for
the exact shape to copy).

```yaml
Type: System.Object
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

## OUTPUTS

### Returns the created widget object.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

