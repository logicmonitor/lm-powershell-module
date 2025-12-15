---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMDeviceGroupDatasource

## SYNOPSIS
Updates a LogicMonitor device group datasource configuration.

## SYNTAX

### Name-dsName
```
Set-LMDeviceGroupDatasource -DatasourceName <String> -Name <String> [-StopMonitoring <Boolean>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsName
```
Set-LMDeviceGroupDatasource -DatasourceName <String> -Id <Int32> [-StopMonitoring <Boolean>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsId
```
Set-LMDeviceGroupDatasource -DatasourceId <Int32> -Name <String> [-StopMonitoring <Boolean>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsId
```
Set-LMDeviceGroupDatasource -DatasourceId <Int32> -Id <Int32> [-StopMonitoring <Boolean>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMDeviceGroupDatasource cmdlet modifies an existing device group datasource in LogicMonitor, allowing updates to monitoring state.
This cmdlet provides control over the "Enable" checkbox (stopMonitoring) for a datasource applied to a device group.
For alert settings use Set-LMDeviceGroupDatasourceAlertSetting.

## EXAMPLES

### EXAMPLE 1
```
#Disable monitoring for a datasource on a device group
Set-LMDeviceGroupDatasource -Id 15 -DatasourceId 790 -StopMonitoring $true
```

### EXAMPLE 2
```
#Enable monitoring using names
Set-LMDeviceGroupDatasource -Name "Production Servers" -DatasourceName "CPU" -StopMonitoring $false
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
Required when using the 'Id-dsId' or 'Id-dsName' parameter sets.

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
Required when using the 'Name-dsId' or 'Name-dsName' parameter sets.

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

### -StopMonitoring
Specifies whether to stop monitoring the datasource.
When set to $true, monitoring is disabled (unchecks the "Enable" checkbox).
When set to $false, monitoring is enabled (checks the "Enable" checkbox).

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns a LogicMonitor.DeviceGroupDatasource object containing the updated datasource configuration.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
