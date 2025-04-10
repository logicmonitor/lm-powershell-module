---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceData

## SYNOPSIS
Retrieves monitoring data for a LogicMonitor device.

## SYNTAX

### dsName-deviceName-instanceId
```
Get-LMDeviceData -DatasourceName <String> -DeviceName <String> -InstanceId <Int32> [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### dsName-deviceName-instanceName
```
Get-LMDeviceData -DatasourceName <String> -DeviceName <String> [-InstanceName <String>] [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### dsName-deviceId-instanceName
```
Get-LMDeviceData -DatasourceName <String> -DeviceId <Int32> [-InstanceName <String>] [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### dsName-deviceId-instanceId
```
Get-LMDeviceData -DatasourceName <String> -DeviceId <Int32> -InstanceId <Int32> [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### dsId-deviceName-instanceId
```
Get-LMDeviceData -DatasourceId <Int32> -DeviceName <String> -InstanceId <Int32> [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### dsId-deviceName-instanceName
```
Get-LMDeviceData -DatasourceId <Int32> -DeviceName <String> [-InstanceName <String>] [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### dsId-deviceId-instanceName
```
Get-LMDeviceData -DatasourceId <Int32> -DeviceId <Int32> [-InstanceName <String>] [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### dsId-deviceId-instanceId
```
Get-LMDeviceData -DatasourceId <Int32> -DeviceId <Int32> -InstanceId <Int32> [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceData function retrieves monitoring data from a specific device's datasource instance in LogicMonitor.
It supports various combinations of identifying the device, datasource, and instance, and allows for time range filtering of the data.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve data using IDs
Get-LMDeviceData -DeviceId 123 -DatasourceId 456 -InstanceId 789
```

### EXAMPLE 2
```
#Retrieve data using names with time range
Get-LMDeviceData -DeviceName "Production-Server" -DatasourceName "CPU" -InstanceName "Total" -StartDate (Get-Date).AddDays(-1)
```

## PARAMETERS

### -DatasourceName
The name of the datasource to retrieve data from.
Required for certain parameter sets.

```yaml
Type: String
Parameter Sets: dsName-deviceName-instanceId, dsName-deviceName-instanceName, dsName-deviceId-instanceName, dsName-deviceId-instanceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceId
The ID of the datasource to retrieve data from.
Required for certain parameter sets.

```yaml
Type: Int32
Parameter Sets: dsId-deviceName-instanceId, dsId-deviceName-instanceName, dsId-deviceId-instanceName, dsId-deviceId-instanceId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceId
The ID of the device to retrieve data from.
Required for certain parameter sets.

```yaml
Type: Int32
Parameter Sets: dsName-deviceId-instanceName, dsName-deviceId-instanceId, dsId-deviceId-instanceName, dsId-deviceId-instanceId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceName
The name of the device to retrieve data from.
Required for certain parameter sets.

```yaml
Type: String
Parameter Sets: dsName-deviceName-instanceId, dsName-deviceName-instanceName, dsId-deviceName-instanceId, dsId-deviceName-instanceName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceId
The ID of the datasource instance to retrieve data from.
Required for certain parameter sets.

```yaml
Type: Int32
Parameter Sets: dsName-deviceName-instanceId, dsName-deviceId-instanceId, dsId-deviceName-instanceId, dsId-deviceId-instanceId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceName
The name of the datasource instance to retrieve data from.
Required for certain parameter sets.

```yaml
Type: String
Parameter Sets: dsName-deviceName-instanceName, dsName-deviceId-instanceName, dsId-deviceName-instanceName, dsId-deviceId-instanceName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
The start date and time for data collection.
Defaults to 7 days ago if not specified.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
The end date and time for data collection.
Defaults to current time if not specified.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A filter object to apply when retrieving data.
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

### Returns formatted monitoring data with timestamps and values.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
