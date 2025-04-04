---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceGroupDatasourceAlertSetting

## SYNOPSIS
Retrieves datasource alert settings for a LogicMonitor device group.

## SYNTAX

### All (Default)
```
Get-LMDeviceGroupDatasourceAlertSetting [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-dsName
```
Get-LMDeviceGroupDatasourceAlertSetting -DatasourceName <String> -Name <String> [-Filter <Object>]
 [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsName
```
Get-LMDeviceGroupDatasourceAlertSetting -DatasourceName <String> -Id <Int32> [-Filter <Object>]
 [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-dsId
```
Get-LMDeviceGroupDatasourceAlertSetting -DatasourceId <Int32> -Name <String> [-Filter <Object>]
 [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsId
```
Get-LMDeviceGroupDatasourceAlertSetting -DatasourceId <Int32> -Id <Int32> [-Filter <Object>]
 [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceGroupDatasourceAlertSetting function retrieves the alert settings for a specific datasource within a device group.
It supports identifying both the group and datasource by either ID or name.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve alert settings using names
Get-LMDeviceGroupDatasourceAlertSetting -Name "Production Servers" -DatasourceName "CPU"
```

### EXAMPLE 2
```
#Retrieve alert settings using IDs
Get-LMDeviceGroupDatasourceAlertSetting -Id 123 -DatasourceId 456
```

## PARAMETERS

### -DatasourceName
The name of the datasource.
Required for Id-dsName and Name-dsName parameter sets.

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
Required for Id-dsId and Name-dsId parameter sets.

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
The ID of the device group.
Required for Id-dsId and Id-dsName parameter sets.

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
The name of the device group.
Required for Name-dsName and Name-dsId parameter sets.

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

### -Filter
A filter object to apply when retrieving alert settings.
This parameter is optional.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
The number of results to return per request.
Must be between 1 and 1000.
Defaults to 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
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

### Returns LogicMonitor.DeviceGroupDatasourceAlertSetting objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
