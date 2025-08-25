---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMDeviceGroupDatasourceAlertSetting

## SYNOPSIS
Updates alert settings for a LogicMonitor device group datasource.

## SYNTAX

### Name-dsName
```
Set-LMDeviceGroupDatasourceAlertSetting -DatasourceName <String> -Name <String> -DatapointName <String>
 [-DisableAlerting <Boolean>] [-AlertExpressionNote <String>] -AlertExpression <String>
 -AlertClearTransitionInterval <Int32> -AlertTransitionInterval <Int32> -AlertForNoData <Int32>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsName
```
Set-LMDeviceGroupDatasourceAlertSetting -DatasourceName <String> -Id <Int32> -DatapointName <String>
 [-DisableAlerting <Boolean>] [-AlertExpressionNote <String>] -AlertExpression <String>
 -AlertClearTransitionInterval <Int32> -AlertTransitionInterval <Int32> -AlertForNoData <Int32>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsId
```
Set-LMDeviceGroupDatasourceAlertSetting -DatasourceId <Int32> -Name <String> -DatapointName <String>
 [-DisableAlerting <Boolean>] [-AlertExpressionNote <String>] -AlertExpression <String>
 -AlertClearTransitionInterval <Int32> -AlertTransitionInterval <Int32> -AlertForNoData <Int32>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsId
```
Set-LMDeviceGroupDatasourceAlertSetting -DatasourceId <Int32> -Id <Int32> -DatapointName <String>
 [-DisableAlerting <Boolean>] [-AlertExpressionNote <String>] -AlertExpression <String>
 -AlertClearTransitionInterval <Int32> -AlertTransitionInterval <Int32> -AlertForNoData <Int32>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMDeviceGroupDatasourceAlertSetting function modifies alert settings for a specific device group datasource in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
90"
Updates the alert settings for the CPU Usage datapoint on the specified device group.
```

## PARAMETERS

### -DatasourceName
Specifies the name of the datasource.
Required when using the 'Id-dsName' or 'Name-dsName' parameter sets.

```yaml
Type: String
Parameter Sets: Name-dsName, Id-dsName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceId
Specifies the ID of the datasource.
Required when using the 'Id-dsId' or 'Name-dsId' parameter sets.

```yaml
Type: Int32
Parameter Sets: Name-dsId, Id-dsId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Specifies the ID of the device group.

```yaml
Type: Int32
Parameter Sets: Id-dsName, Id-dsId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the device group.

```yaml
Type: String
Parameter Sets: Name-dsName, Name-dsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatapointName
Specifies the name of the datapoint for which to configure alerts.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableAlerting
Specifies whether to disable alerting for this datasource.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertExpressionNote
Specifies a note for the alert expression.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertExpression
Specifies the alert expression in the format "(01:00 02:00) \> -100 timezone=America/New_York".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertClearTransitionInterval
Specifies the interval for alert clear transitions.
Must be between 0 and 60.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertTransitionInterval
Specifies the interval for alert transitions.
Must be between 0 and 60.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertForNoData
Specifies the alert level for no data conditions.
Must be between 1 and 4.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### Returns a LogicMonitor.DeviceGroupDatasourceAlertSetting object containing the updated alert settings.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
