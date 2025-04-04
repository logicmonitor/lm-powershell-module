---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceDatasourceInstanceGroup

## SYNOPSIS
Retrieves instance groups for a LogicMonitor device datasource.

## SYNTAX

### Name-dsName
```
Get-LMDeviceDatasourceInstanceGroup -DatasourceName <String> -Name <String> [-Filter <Object>]
 [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsName
```
Get-LMDeviceDatasourceInstanceGroup -DatasourceName <String> -Id <Int32> [-Filter <Object>]
 [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-dsId
```
Get-LMDeviceDatasourceInstanceGroup -DatasourceId <Int32> -Name <String> [-Filter <Object>]
 [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsId
```
Get-LMDeviceDatasourceInstanceGroup -DatasourceId <Int32> -Id <Int32> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-HdsId
```
Get-LMDeviceDatasourceInstanceGroup -Id <Int32> -HdsId <String> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-HdsId
```
Get-LMDeviceDatasourceInstanceGroup -Name <String> -HdsId <String> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceDatasourceInstanceGroup function retrieves all instance groups associated with a device datasource.
It supports identifying the device and datasource by either ID or name, and allows filtering of the results.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve instance groups using names
Get-LMDeviceDatasourceInstanceGroup -DatasourceName "CPU" -Name "Server01"
```

### EXAMPLE 2
```
#Retrieve instance groups using IDs
Get-LMDeviceDatasourceInstanceGroup -DatasourceId 123 -Id 456
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
Required for Id-dsId, Id-dsName, and Id-HdsId parameter sets.

```yaml
Type: Int32
Parameter Sets: Id-dsName, Id-dsId, Id-HdsId
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
Required for Name-dsName, Name-dsId, and Name-HdsId parameter sets.

```yaml
Type: String
Parameter Sets: Name-dsName, Name-dsId, Name-HdsId
Aliases: DeviceName

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HdsId
The ID of the device datasource.
Required for Id-HdsId and Name-HdsId parameter sets.

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

### -Filter
A filter object to apply when retrieving instance groups.
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

### Returns instance group objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
