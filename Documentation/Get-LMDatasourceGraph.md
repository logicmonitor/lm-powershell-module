---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDatasourceGraph

## SYNOPSIS
Retrieves graphs associated with a LogicMonitor datasource.

## SYNTAX

### Id-dsName
```
Get-LMDatasourceGraph -Id <Int32> -DataSourceName <String> [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsId
```
Get-LMDatasourceGraph -Id <Int32> -DataSourceId <String> [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Filter-dsName
```
Get-LMDatasourceGraph -DataSourceName <String> -Filter <Object> [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-dsName
```
Get-LMDatasourceGraph -DataSourceName <String> -Name <String> [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### dsName
```
Get-LMDatasourceGraph -DataSourceName <String> [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter-dsId
```
Get-LMDatasourceGraph -DataSourceId <String> -Filter <Object> [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-dsId
```
Get-LMDatasourceGraph -DataSourceId <String> -Name <String> [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### dsId
```
Get-LMDatasourceGraph -DataSourceId <String> [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDatasourceGraph function retrieves graph information from LogicMonitor datasources.
It can retrieve graphs by ID, name, or by their associated datasource using either datasource ID or name.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve a graph by ID from a specific datasource
Get-LMDatasourceGraph -Id 123 -DataSourceId 456
```

### EXAMPLE 2
```
#Retrieve graphs by name from a datasource
Get-LMDatasourceGraph -Name "CPU Usage" -DataSourceName "CPU"
```

## PARAMETERS

### -Id
The ID of the graph to retrieve.
This parameter is mandatory when using the Id-dsId or Id-dsName parameter sets.

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

### -DataSourceName
The name of the datasource to retrieve graphs from.
This parameter is mandatory for dsName, Id-dsName, Name-dsName, and Filter-dsName parameter sets.

```yaml
Type: String
Parameter Sets: Id-dsName, Filter-dsName, Name-dsName, dsName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataSourceId
The ID of the datasource to retrieve graphs from.
This parameter is mandatory for dsId, Id-dsId, Name-dsId, and Filter-dsId parameter sets.

```yaml
Type: String
Parameter Sets: Id-dsId, Filter-dsId, Name-dsId, dsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the graph to retrieve.
This parameter is mandatory for Name-dsId and Name-dsName parameter sets.

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
A filter object to apply when retrieving graphs.
This parameter is mandatory for Filter-dsId and Filter-dsName parameter sets.

```yaml
Type: Object
Parameter Sets: Filter-dsName, Filter-dsId
Aliases:

Required: True
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

### Returns LogicMonitor.DatasourceGraph objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
