---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMDeviceDatasourceInstanceGroup

## SYNOPSIS
Removes a LogicMonitor device datasource instance group.

## SYNTAX

### Id-dsName-GroupName (Default)
```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceName <String> -Id <Int32> -InstanceGroupName <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsName-GroupId
```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceName <String> -Name <String> -InstanceGroupId <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsName-GroupName
```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceName <String> -Name <String> -InstanceGroupName <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsName-GroupId
```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceName <String> -Id <Int32> -InstanceGroupId <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsId-GroupId
```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceId <Int32> -Name <String> -InstanceGroupId <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsId-GroupName
```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceId <Int32> -Name <String> -InstanceGroupName <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsId-GroupId
```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceId <Int32> -Id <Int32> -InstanceGroupId <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsId-GroupName
```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceId <Int32> -Id <Int32> -InstanceGroupName <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-HdsId-GroupId
```
Remove-LMDeviceDatasourceInstanceGroup -Id <Int32> -HdsId <String> -InstanceGroupId <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-HdsId-GroupName
```
Remove-LMDeviceDatasourceInstanceGroup -Id <Int32> -HdsId <String> -InstanceGroupName <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-HdsId-GroupId
```
Remove-LMDeviceDatasourceInstanceGroup -Name <String> -HdsId <String> -InstanceGroupId <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-HdsId-GroupName
```
Remove-LMDeviceDatasourceInstanceGroup -Name <String> -HdsId <String> -InstanceGroupName <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMDeviceDatasourceInstanceGroup function removes a LogicMonitor device datasource instance group based on the provided parameters.
It requires valid API credentials and a logged-in session.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceName "CPU" -Name "Server01" -InstanceGroupName "Group1"
Removes the instance group named "Group1" associated with the "CPU" datasource on the device named "Server01".
```

### EXAMPLE 2
```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceId 123 -Id 456 -InstanceGroupName "Group2"
Removes the instance group named "Group2" associated with the datasource ID 123 on the device ID 456.
```

## PARAMETERS

### -DatasourceName
Specifies the name of the datasource associated with the instance group.
This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

```yaml
Type: String
Parameter Sets: Id-dsName-GroupName, Name-dsName-GroupId, Name-dsName-GroupName, Id-dsName-GroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceId
Specifies the ID of the datasource associated with the instance group.
This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

```yaml
Type: Int32
Parameter Sets: Name-dsId-GroupId, Name-dsId-GroupName, Id-dsId-GroupId, Id-dsId-GroupName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Specifies the ID of the device associated with the instance group.
This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets.
This parameter can also be specified using the 'DeviceId' alias.

```yaml
Type: Int32
Parameter Sets: Id-dsName-GroupName, Id-dsName-GroupId, Id-dsId-GroupId, Id-dsId-GroupName, Id-HdsId-GroupId, Id-HdsId-GroupName
Aliases: DeviceId

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the device associated with the instance group.
This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets.
This parameter can also be specified using the 'DeviceName' alias.

```yaml
Type: String
Parameter Sets: Name-dsName-GroupId, Name-dsName-GroupName, Name-dsId-GroupId, Name-dsId-GroupName, Name-HdsId-GroupId, Name-HdsId-GroupName
Aliases: DeviceName

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HdsId
Specifies the ID of the host datasource associated with the instance group. This parameter is mandatory when using the 'Id-HdsId' or 'Name-HdsId' parameter sets.

```yaml
Type: String
Parameter Sets: Id-HdsId-GroupId, Id-HdsId-GroupName, Name-HdsId-GroupId, Name-HdsId-GroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceGroupName
Specifies the name of the instance group to be removed.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: Id-dsName-GroupName, Name-dsName-GroupName, Name-dsId-GroupName, Id-dsId-GroupName, Id-HdsId-GroupName, Name-HdsId-GroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceGroupId
Specifies the ID of the instance group to be removed. This parameter is mandatory.

```yaml
Type: String
Parameter Sets: Name-dsName-GroupId, Id-dsName-GroupId, Name-dsId-GroupId, Id-dsId-GroupId, Id-HdsId-GroupId, Name-HdsId-GroupId
Aliases:

Required: True
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

### None.
## OUTPUTS

### Returns a PSCustomObject containing the instance ID and a message confirming the successful removal of the instance group.
## NOTES

## RELATED LINKS
