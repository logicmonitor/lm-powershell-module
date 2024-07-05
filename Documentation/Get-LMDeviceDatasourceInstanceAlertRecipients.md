---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceDatasourceInstanceAlertRecipients

## SYNOPSIS
Retrieves the alert recipients for a specific data point in a LogicMonitor device datasource instance.

## SYNTAX

### Name-dsName
```
Get-LMDeviceDatasourceInstanceAlertRecipients -DatasourceName <String> -Name <String> -InstanceName <String>
 -DataPointName <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsName
```
Get-LMDeviceDatasourceInstanceAlertRecipients -DatasourceName <String> -Id <Int32> -InstanceName <String>
 -DataPointName <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-dsId
```
Get-LMDeviceDatasourceInstanceAlertRecipients -DatasourceId <Int32> -Name <String> -InstanceName <String>
 -DataPointName <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsId
```
Get-LMDeviceDatasourceInstanceAlertRecipients -DatasourceId <Int32> -Id <Int32> -InstanceName <String>
 -DataPointName <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceDatasourceInstanceAlertRecipients function retrieves the alert recipients for a specific data point in a LogicMonitor device datasource instance.
It requires valid API credentials and a logged-in session.

## EXAMPLES

### EXAMPLE 1
```
Get-LMDeviceDatasourceInstanceAlertRecipients -DatasourceName "Ping-" -Name "Server01" -InstanceName "Instance01" -DataPointName "PingLossPercent"
```

Retrieves the alert recipients for the "PingLossPercent" data point in the "CPU" datasource instance of the "Server01" device.

### EXAMPLE 2
```
Get-LMDeviceDatasourceInstanceAlertRecipients -DatasourceId 123 -Id 456 -InstanceName "Instance01" -DataPointName "PingLossPercent"
```

Retrieves the alert recipients for the "PingLossPercent" data point in the datasource instance with ID 123 of the device with ID 456.

## PARAMETERS

### -DatasourceName
Specifies the name of the datasource.
This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

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
This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

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
Specifies the ID of the device.
This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets.
It can also be specified using the 'DeviceId' alias.

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
Specifies the name of the device.
This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets.
It can also be specified using the 'DeviceName' alias.

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
Specifies the name of the datasource instance.
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

### -DataPointName
Specifies the name of the data point.
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

## OUTPUTS

## NOTES

## RELATED LINKS
