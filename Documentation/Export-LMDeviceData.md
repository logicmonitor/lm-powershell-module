---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Export-LMDeviceData

## SYNOPSIS
Exports device monitoring data from LogicMonitor.

## SYNTAX

### DeviceId
```
Export-LMDeviceData -DeviceId <Int32> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DeviceDisplayName
```
Export-LMDeviceData -DeviceDisplayName <String> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DeviceHostName
```
Export-LMDeviceData -DeviceHostName <String> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DeviceGroupId
```
Export-LMDeviceData -DeviceGroupId <String> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DeviceGroupName
```
Export-LMDeviceData -DeviceGroupName <String> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Export-LMDeviceData function exports monitoring data from LogicMonitor devices or device groups.
It supports exporting data for specific time ranges and can filter datasources.
Data can be exported in CSV or JSON format.

## EXAMPLES

### EXAMPLE 1
```
#Export device data to JSON
Export-LMDeviceData -DeviceId 12345 -StartDate (Get-Date).AddDays(-1) -ExportFormat json
```

### EXAMPLE 2
```
#Export device group data to CSV with datasource filtering
Export-LMDeviceData -DeviceGroupName "Production" -DatasourceIncludeFilter "CPU*" -ExportFormat csv
```

## PARAMETERS

### -DeviceId
The ID of the device to export data from.
This parameter is part of a mutually exclusive parameter set.

```yaml
Type: Int32
Parameter Sets: DeviceId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceDisplayName
The display name of the device to export data from.
This parameter is part of a mutually exclusive parameter set.

```yaml
Type: String
Parameter Sets: DeviceDisplayName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceHostName
The hostname of the device to export data from.
This parameter is part of a mutually exclusive parameter set.

```yaml
Type: String
Parameter Sets: DeviceHostName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroupId
The ID of the device group to export data from.
This parameter is part of a mutually exclusive parameter set.

```yaml
Type: String
Parameter Sets: DeviceGroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroupName
The name of the device group to export data from.
This parameter is part of a mutually exclusive parameter set.

```yaml
Type: String
Parameter Sets: DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
The start date and time for data collection.
Defaults to 1 hour ago.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date).AddHours(-1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
The end date and time for data collection.
Defaults to current time.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceIncludeFilter
A filter pattern to include specific datasources.
Defaults to "*" (all datasources).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceExcludeFilter
A filter pattern to exclude specific datasources.
Defaults to null (no exclusions).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExportFormat
The format for the exported data.
Valid values are "csv", "json", or "none".
Defaults to "none".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExportPath
The path where exported files will be saved.
Defaults to current directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Location).Path
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

### Returns device data objects if ExportFormat is "none", otherwise creates export files.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
