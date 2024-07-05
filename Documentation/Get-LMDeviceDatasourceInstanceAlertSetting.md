---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceDatasourceInstanceAlertSetting

## SYNOPSIS
Retrieves the alert settings for a specific LogicMonitor device datasource instance.

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
The Get-LMDeviceDatasourceInstanceAlertSetting function retrieves the alert settings for a specific LogicMonitor device datasource instance.
It requires the device name or ID, datasource name or ID, and instance name as input parameters.
Optionally, you can also provide a filter to narrow down the results.
The function returns an array of alert settings for the specified instance.

## EXAMPLES

### EXAMPLE 1
```
Get-LMDeviceDatasourceInstanceAlertSetting -Name "MyDevice" -DatasourceName "MyDatasource" -InstanceName "MyInstance"
Retrieves the alert settings for the instance named "MyInstance" of the datasource "MyDatasource" on the device named "MyDevice".
```

### EXAMPLE 2
```
Get-LMDeviceDatasourceInstanceAlertSetting -Id 123 -DatasourceId 456 -InstanceName "MyInstance" -Filter "Property -eq 'value'"
Retrieves the alert settings for the instance named "MyInstance" of the datasource with ID 456 on the device with ID 123, applying the specified filter.
```

## PARAMETERS

### -DatasourceName
Specifies the name of the datasource.
This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter set.

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
This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter set.

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
This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter set.
This parameter can also be specified using the 'DeviceId' alias.

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
This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter set.
This parameter can also be specified using the 'DeviceName' alias.

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
Specifies the name of the instance for which to retrieve the alert settings.
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
Specifies a filter to narrow down the results.
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
Specifies the number of results to retrieve per batch.
The default value is 1000.
This parameter is optional.

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

## OUTPUTS

## NOTES
This function requires a valid LogicMonitor API authentication.
Make sure you are logged in before running any commands by using the Connect-LMAccount function.

## RELATED LINKS
