---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Find-LMDashboardWidget
---

# Find-LMDashboardWidget

## SYNOPSIS

Find list of dashboard widgets containing mention of specified datasources

## SYNTAX

### __AllParameterSets

```
Find-LMDashboardWidget [-DatasourceNames] <string[]> [[-GroupPathSearchString] <string>]
 [<CommonParameters>]
```

## DESCRIPTION

Find list of dashboard widgets containing mention of specified datasources

## EXAMPLES

### EXAMPLE 1

Find-LMDashboardWidget -DatasourceNames @("SNMP_NETWORK_INTERFACES","VMWARE_VCETNER_VM_PERFORMANCE")

## PARAMETERS

### -DatasourceNames

Array of datasource names to search for in dashboard widgets.
Can also use the alias DatasourceName.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- DatasourceName
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GroupPathSearchString

Wildcard search string to filter dashboards by group path.
Defaults to "*" (all dashboards).

```yaml
Type: System.String
DefaultValue: '*'
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

### DatasourceNames in an array. You can also pipe datasource names to this widget.

### System.String[]

## OUTPUTS

## NOTES

Created groups will be placed in a main group called Azure Resources by Subscription in the parent group specified by the -ParentGroupId parameter

## RELATED LINKS

