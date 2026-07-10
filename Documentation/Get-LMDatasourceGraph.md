---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDatasourceGraph
---

# Get-LMDatasourceGraph

## SYNOPSIS

Retrieves graphs associated with a LogicMonitor datasource.

## SYNTAX

### Id-dsName

```
Get-LMDatasourceGraph -Id <int> -DataSourceName <string> [-BatchSize <int>] [<CommonParameters>]
```

### Id-dsId

```
Get-LMDatasourceGraph -Id <int> -DataSourceId <string> [-BatchSize <int>] [<CommonParameters>]
```

### Filter-dsName

```
Get-LMDatasourceGraph -DataSourceName <string> -Filter <Object> [-BatchSize <int>]
 [<CommonParameters>]
```

### Name-dsName

```
Get-LMDatasourceGraph -DataSourceName <string> -Name <string> [-BatchSize <int>]
 [<CommonParameters>]
```

### dsName

```
Get-LMDatasourceGraph -DataSourceName <string> [-BatchSize <int>] [<CommonParameters>]
```

### Filter-dsId

```
Get-LMDatasourceGraph -DataSourceId <string> -Filter <Object> [-BatchSize <int>]
 [<CommonParameters>]
```

### Name-dsId

```
Get-LMDatasourceGraph -DataSourceId <string> -Name <string> [-BatchSize <int>] [<CommonParameters>]
```

### dsId

```
Get-LMDatasourceGraph -DataSourceId <string> [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDatasourceGraph function retrieves graph information from LogicMonitor datasources.
It can retrieve graphs by ID, name, or by their associated datasource using either datasource ID or name.

## EXAMPLES

### EXAMPLE 1

#Retrieve a graph by ID from a specific datasource
Get-LMDatasourceGraph -Id 123 -DataSourceId 456

### EXAMPLE 2

#Retrieve graphs by name from a datasource
Get-LMDatasourceGraph -Name "CPU Usage" -DataSourceName "CPU"

## PARAMETERS

### -BatchSize

The number of results to return per request.
Must be between 1 and 1000.
Defaults to 1000.

```yaml
Type: System.Int32
DefaultValue: 1000
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DataSourceId

The ID of the datasource to retrieve graphs from.
This parameter is mandatory for dsId, Id-dsId, Name-dsId, and Filter-dsId parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DataSourceName

The name of the datasource to retrieve graphs from.
This parameter is mandatory for dsName, Id-dsName, Name-dsName, and Filter-dsName parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Filter

A filter object to apply when retrieving graphs.
This parameter is mandatory for Filter-dsId and Filter-dsName parameter sets.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Filter-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

The ID of the graph to retrieve.
This parameter is mandatory when using the Id-dsId or Id-dsName parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the graph to retrieve.
This parameter is mandatory for Name-dsId and Name-dsName parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns LogicMonitor.DatasourceGraph objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

