---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMDeviceConfigSourceCollection

## SYNOPSIS
Invokes configuration collection for a device datasource.

## SYNTAX

### Name-dsName
```
Invoke-LMDeviceConfigSourceCollection -DatasourceName <String> -Name <String> -InstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsName
```
Invoke-LMDeviceConfigSourceCollection -DatasourceName <String> -Id <Int32> -InstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-dsId
```
Invoke-LMDeviceConfigSourceCollection -DatasourceId <Int32> -Name <String> -InstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsId
```
Invoke-LMDeviceConfigSourceCollection -DatasourceId <Int32> -Id <Int32> -InstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-HdsId
```
Invoke-LMDeviceConfigSourceCollection -Id <Int32> -HdsId <String> -InstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-HdsId
```
Invoke-LMDeviceConfigSourceCollection -Name <String> -HdsId <String> -InstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMDeviceConfigSourceCollection function triggers configuration collection for a specified device datasource instance.

## EXAMPLES

### EXAMPLE 1
```
#Collect config using datasource name
Invoke-LMDeviceConfigSourceCollection -Name "Device1" -DatasourceName "Config" -InstanceId "123"
```

### EXAMPLE 2
```
#Collect config using datasource ID
Invoke-LMDeviceConfigSourceCollection -Id 456 -DatasourceId 789 -InstanceId "123"
```

## PARAMETERS

### -DatasourceName
The name of the datasource.
Required for dsName parameter sets.

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
The ID of the datasource.
Required for dsId parameter sets.

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
The ID of the device.
Required for Id parameter sets.

```yaml
Type: Int32
Parameter Sets: Id-dsName, Id-dsId, Id-HdsId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the device.
Required for Name parameter sets.

```yaml
Type: String
Parameter Sets: Name-dsName, Name-dsId, Name-HdsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HdsId
The host datasource ID.
Required for HdsId parameter sets.

```yaml
Type: String
Parameter Sets: Id-HdsId, Name-HdsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceId
The ID of the datasource instance.

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

### Returns a success message if the collection is scheduled successfully.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
