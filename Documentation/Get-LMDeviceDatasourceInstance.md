---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceDatasourceInstance

## SYNOPSIS
Retrieves datasource instances for a LogicMonitor device.

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
The Get-LMDeviceDatasourceInstance function retrieves instances of a datasource from a specific device in LogicMonitor.
The device and datasource can be identified by either ID or name.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve instances by device and datasource name
Get-LMDeviceDatasourceInstance -DatasourceName "CPU" -Name "Production-Server"
```

### EXAMPLE 2
```
#Retrieve instances by IDs
Get-LMDeviceDatasourceInstance -DatasourceId 123 -Id 456
```

## PARAMETERS

### -DatasourceName
The name of the datasource to retrieve instances from.
Required for certain parameter sets.

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
The ID of the datasource to retrieve instances from.
Required for certain parameter sets.

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
Required for certain parameter sets.

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
Required for certain parameter sets.

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
A filter object to apply when retrieving instances.
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

### Returns LogicMonitor.DeviceDatasourceInstance objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
