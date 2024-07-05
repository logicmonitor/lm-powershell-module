---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceDatasourceInstance

## SYNOPSIS
Retrieves instances of a LogicMonitor device datasource.

## SYNTAX

### Name-dsName
```
Get-LMDeviceDatasourceInstance -DatasourceName <String> -Name <String> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsName
```
Get-LMDeviceDatasourceInstance -DatasourceName <String> -Id <Int32> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-dsId
```
Get-LMDeviceDatasourceInstance -DatasourceId <Int32> -Name <String> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsId
```
Get-LMDeviceDatasourceInstance -DatasourceId <Int32> -Id <Int32> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceDatasourceInstance function retrieves instances of a LogicMonitor device datasource based on the specified parameters.
It requires a valid API authentication and authorization.

## EXAMPLES

### EXAMPLE 1
```
Get-LMDeviceDatasourceInstance -DatasourceName "CPU" -Name "Server01" -BatchSize 500
Retrieves instances of the "CPU" datasource for the device named "Server01" with a batch size of 500.
```

### EXAMPLE 2
```
Get-LMDeviceDatasourceInstance -DatasourceId 1234 -Id 5678
Retrieves instances of the datasource with ID 1234 for the device with ID 5678.
```

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

### -Filter
Specifies additional filters to apply to the instances.
This parameter accepts an object representing the filter criteria.

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
Specifies the number of instances to retrieve per batch.
The default value is 1000.

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
This function requires a valid API authentication and authorization.
Use Connect-LMAccount to log in before running any commands.

## RELATED LINKS
