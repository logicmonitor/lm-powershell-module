---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Set-LMDeviceGroupDatasourceAlertSetting
---

# Set-LMDeviceGroupDatasourceAlertSetting

## SYNOPSIS

Updates alert settings for a LogicMonitor device group datasource.

## SYNTAX

### Name-dsName

```
Set-LMDeviceGroupDatasourceAlertSetting -DatasourceName <string> -Name <string>
 -DatapointName <string> -AlertExpression <string> -AlertClearTransitionInterval <int>
 -AlertTransitionInterval <int> -AlertForNoData <int> [-DisableAlerting <bool>]
 [-AlertExpressionNote <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsName

```
Set-LMDeviceGroupDatasourceAlertSetting -DatasourceName <string> -Id <int> -DatapointName <string>
 -AlertExpression <string> -AlertClearTransitionInterval <int> -AlertTransitionInterval <int>
 -AlertForNoData <int> [-DisableAlerting <bool>] [-AlertExpressionNote <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Name-dsId

```
Set-LMDeviceGroupDatasourceAlertSetting -DatasourceId <int> -Name <string> -DatapointName <string>
 -AlertExpression <string> -AlertClearTransitionInterval <int> -AlertTransitionInterval <int>
 -AlertForNoData <int> [-DisableAlerting <bool>] [-AlertExpressionNote <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Id-dsId

```
Set-LMDeviceGroupDatasourceAlertSetting -DatasourceId <int> -Id <int> -DatapointName <string>
 -AlertExpression <string> -AlertClearTransitionInterval <int> -AlertTransitionInterval <int>
 -AlertForNoData <int> [-DisableAlerting <bool>] [-AlertExpressionNote <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Set-LMDeviceGroupDatasourceAlertSetting function modifies alert settings for a specific device group datasource in LogicMonitor.

## EXAMPLES

### EXAMPLE 1

90"
Updates the alert settings for the CPU Usage datapoint on the specified device group.

## PARAMETERS

### -AlertClearTransitionInterval

Specifies the interval for alert clear transitions.
Must be between 0 and 60.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AlertExpression

Specifies the alert expression in the format "(01:00 02:00) > -100 timezone=America/New_York".

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AlertExpressionNote

Specifies a note for the alert expression.

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

### -AlertForNoData

Specifies the alert level for no data conditions.
Must be between 1 and 4.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AlertTransitionInterval

Specifies the interval for alert transitions.
Must be between 0 and 60.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
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

### -DatapointName

Specifies the name of the datapoint for which to configure alerts.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
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

### -DisableAlerting

Specifies whether to disable alerting for this datasource.

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

### -Id

Specifies the ID of the device group.

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

## OUTPUTS

### Returns a LogicMonitor.DeviceGroupDatasourceAlertSetting object containing the updated alert settings.

## NOTES

This function requires a valid LogicMonitor API authentication.

## RELATED LINKS

