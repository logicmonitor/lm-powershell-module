---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMDeviceDatasourceInstance

## SYNOPSIS
Updates a LogicMonitor device datasource instance configuration.

## SYNTAX

### Name-dsName
```
Set-LMDeviceDatasourceInstance [-DisplayName <String>] [-WildValue <String>] [-WildValue2 <String>]
 [-Description <String>] [-Properties <Hashtable>] [-PropertiesMethod <String>] [-StopMonitoring <Boolean>]
 [-DisableAlerting <Boolean>] [-InstanceGroupId <String>] -InstanceId <String> -DatasourceName <String>
 -Name <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsName
```
Set-LMDeviceDatasourceInstance [-DisplayName <String>] [-WildValue <String>] [-WildValue2 <String>]
 [-Description <String>] [-Properties <Hashtable>] [-PropertiesMethod <String>] [-StopMonitoring <Boolean>]
 [-DisableAlerting <Boolean>] [-InstanceGroupId <String>] -InstanceId <String> -DatasourceName <String>
 -Id <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsId
```
Set-LMDeviceDatasourceInstance [-DisplayName <String>] [-WildValue <String>] [-WildValue2 <String>]
 [-Description <String>] [-Properties <Hashtable>] [-PropertiesMethod <String>] [-StopMonitoring <Boolean>]
 [-DisableAlerting <Boolean>] [-InstanceGroupId <String>] -InstanceId <String> -DatasourceId <String>
 -Name <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsId
```
Set-LMDeviceDatasourceInstance [-DisplayName <String>] [-WildValue <String>] [-WildValue2 <String>]
 [-Description <String>] [-Properties <Hashtable>] [-PropertiesMethod <String>] [-StopMonitoring <Boolean>]
 [-DisableAlerting <Boolean>] [-InstanceGroupId <String>] -InstanceId <String> -DatasourceId <String>
 -Id <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMDeviceDatasourceInstance function modifies an existing device datasource instance in LogicMonitor, allowing updates to its display name, wild values, description, and various other properties.

## EXAMPLES

### EXAMPLE 1
```
Set-LMDeviceDatasourceInstance -InstanceId 123 -DisplayName "Updated Instance" -Description "New description"
Updates the instance with ID 123 with a new display name and description.
```

## PARAMETERS

### -DisplayName
Specifies the new display name for the instance.

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

### -WildValue
Specifies the first wild value for the instance.

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

### -WildValue2
Specifies the second wild value for the instance.

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

### -Description
Specifies the description for the instance.

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

### -Properties
Specifies a hashtable of custom properties for the instance.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertiesMethod
Specifies how to handle existing properties.
Valid values are "Add", "Replace", or "Refresh".
Default is "Replace".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Replace
Accept pipeline input: False
Accept wildcard characters: False
```

### -StopMonitoring
Specifies whether to stop monitoring the instance.

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

### -DisableAlerting
Specifies whether to disable alerting for the instance.

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

### -InstanceGroupId
Specifies the ID of the instance group to which the instance belongs.

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

### -InstanceId
Specifies the ID of the instance to update.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DatasourceName
Specifies the name of the datasource associated with the instance.

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
Specifies the ID of the datasource associated with the instance.

```yaml
Type: String
Parameter Sets: Name-dsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Id-dsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Specifies the ID of the device associated with the instance.

```yaml
Type: String
Parameter Sets: Id-dsName
Aliases: DeviceId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Id-dsId
Aliases: DeviceId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the device associated with the instance.

```yaml
Type: String
Parameter Sets: Name-dsName, Name-dsId
Aliases: DeviceName

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

### You can pipe objects containing InstanceId, DatasourceId, and Id properties to this function.
## OUTPUTS

### Returns a LogicMonitor.DeviceDatasourceInstance object containing the updated instance information.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
