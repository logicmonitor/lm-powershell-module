---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceDatasourceInstanceAlertRecipients

## SYNOPSIS
Retrieves alert recipients for a specific data point in a LogicMonitor device datasource instance.

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
The Get-LMDeviceDatasourceInstanceAlertRecipients function retrieves the alert recipients configured for a specific data point within a device's datasource instance.
It supports identifying the device and datasource by either ID or name.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve alert recipients using names
Get-LMDeviceDatasourceInstanceAlertRecipients -DatasourceName "Ping" -Name "Server01" -InstanceName "Instance01" -DataPointName "PingLossPercent"
```

### EXAMPLE 2
```
#Retrieve alert recipients using IDs
Get-LMDeviceDatasourceInstanceAlertRecipients -DatasourceId 123 -Id 456 -InstanceName "Instance01" -DataPointName "PingLossPercent"
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
The name of the datasource instance.
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
The name of the data point to retrieve alert recipients for.
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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns alert recipient configuration objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
