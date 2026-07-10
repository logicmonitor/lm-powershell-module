---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Set-LMDeviceGroupDatasource
---

# Set-LMDeviceGroupDatasource

## SYNOPSIS

Updates a LogicMonitor device group datasource configuration.

## SYNTAX

### Name-dsName

```
Set-LMDeviceGroupDatasource -DatasourceName <string> -Name <string> [-StopMonitoring <bool>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsName

```
Set-LMDeviceGroupDatasource -DatasourceName <string> -Id <int> [-StopMonitoring <bool>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Name-dsId

```
Set-LMDeviceGroupDatasource -DatasourceId <int> -Name <string> [-StopMonitoring <bool>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Id-dsId

```
Set-LMDeviceGroupDatasource -DatasourceId <int> -Id <int> [-StopMonitoring <bool>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Set-LMDeviceGroupDatasource cmdlet modifies an existing device group datasource in LogicMonitor, allowing updates to monitoring state.
This cmdlet provides control over the "Enable" checkbox (stopMonitoring) for a datasource applied to a device group.
For alert settings use Set-LMDeviceGroupDatasourceAlertSetting.

## EXAMPLES

### EXAMPLE 1

#Disable monitoring for a datasource on a device group
Set-LMDeviceGroupDatasource -Id 15 -DatasourceId 790 -StopMonitoring $true

### EXAMPLE 2

#Enable monitoring using names
Set-LMDeviceGroupDatasource -Name "Production Servers" -DatasourceName "CPU" -StopMonitoring $false

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

### -DatasourceId

Specifies the ID of the datasource.
Required when using the 'Id-dsId' or 'Name-dsId' parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DatasourceName

Specifies the name of the datasource.
Required when using the 'Id-dsName' or 'Name-dsName' parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

Specifies the ID of the device group.
Required when using the 'Id-dsId' or 'Id-dsName' parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

Specifies the name of the device group.
Required when using the 'Name-dsId' or 'Name-dsName' parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StopMonitoring

Specifies whether to stop monitoring the datasource.
When set to $true, monitoring is disabled (unchecks the "Enable" checkbox).
When set to $false, monitoring is enabled (checks the "Enable" checkbox).

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

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns a LogicMonitor.DeviceGroupDatasource object containing the updated datasource configuration.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

