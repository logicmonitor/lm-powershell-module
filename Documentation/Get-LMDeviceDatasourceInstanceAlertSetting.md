---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceDatasourceInstanceAlertSetting

## SYNOPSIS
Retrieves alert settings for a LogicMonitor device datasource instance.

## SYNTAX

### Name-dsName
```
Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceName <String> -Name <String> -InstanceName <String>
 [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsName
```
Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceName <String> -Id <Int32> -InstanceName <String>
 [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-dsId
```
Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceId <Int32> -Name <String> -InstanceName <String>
 [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsId
```
Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceId <Int32> -Id <Int32> -InstanceName <String>
 [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceDatasourceInstanceAlertSetting function retrieves the alert configuration settings for a specific device datasource instance.
It supports identifying the device and datasource by either ID or name, and allows filtering of the results.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve alert settings using names
Get-LMDeviceDatasourceInstanceAlertSetting -Name "MyDevice" -DatasourceName "MyDatasource" -InstanceName "MyInstance"
```

### EXAMPLE 2
```
#Retrieve alert settings using IDs with filter
Get-LMDeviceDatasourceInstanceAlertSetting -Id 123 -DatasourceId 456 -InstanceName "MyInstance" -Filter $filterObject
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
The ID of the device.
Can be specified using the DeviceId alias.
Required for Id-dsId and Id-dsName parameter sets.

```yaml
Type: Int32
Parameter Sets: Id-dsName, Id-dsId
Aliases: DeviceId

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the device.
Can be specified using the DeviceName alias.
Required for Name-dsName and Name-dsId parameter sets.

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

### -InstanceName
The name of the instance to retrieve alert settings for.
This parameter is mandatory.

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

### Returns LogicMonitor.AlertSetting objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
