---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDeviceDatasourceInstanceGroup
---

# Get-LMDeviceDatasourceInstanceGroup

## SYNOPSIS

Retrieves instance groups for a LogicMonitor device datasource.

## SYNTAX

### Name-dsName

```
Get-LMDeviceDatasourceInstanceGroup -DatasourceName <string> -Name <string>
 [-InstanceGroupName <string>] [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

### Id-dsName

```
Get-LMDeviceDatasourceInstanceGroup -DatasourceName <string> -Id <int> [-InstanceGroupName <string>]
 [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

### Name-dsId

```
Get-LMDeviceDatasourceInstanceGroup -DatasourceId <int> -Name <string> [-InstanceGroupName <string>]
 [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

### Id-dsId

```
Get-LMDeviceDatasourceInstanceGroup -DatasourceId <int> -Id <int> [-InstanceGroupName <string>]
 [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

### Id-HdsId

```
Get-LMDeviceDatasourceInstanceGroup -Id <int> -HdsId <string> [-InstanceGroupName <string>]
 [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

### Name-HdsId

```
Get-LMDeviceDatasourceInstanceGroup -Name <string> -HdsId <string> [-InstanceGroupName <string>]
 [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDeviceDatasourceInstanceGroup function retrieves all instance groups associated with a device datasource.
It supports identifying the device and datasource by either ID or name, and allows filtering of the results.

## EXAMPLES

### EXAMPLE 1

#Retrieve instance groups using names
Get-LMDeviceDatasourceInstanceGroup -DatasourceName "CPU" -Name "Server01"

### EXAMPLE 2

#Retrieve instance groups using IDs
Get-LMDeviceDatasourceInstanceGroup -DatasourceId 123 -Id 456

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

### -DatasourceId

The ID of the datasource.
Required for Id-dsId and Name-dsId parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
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
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DatasourceName

The name of the datasource.
Required for Id-dsName and Name-dsName parameter sets.

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
- Name: Id-dsName
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

A filter object to apply when retrieving instance groups.
This parameter is optional.

```yaml
Type: System.Object
DefaultValue: ''
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

### -HdsId

The ID of the device datasource.
Required for Id-HdsId and Name-HdsId parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-HdsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-HdsId
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

The ID of the device.
Can be specified using the DeviceId alias.
Required for Id-dsId, Id-dsName, and Id-HdsId parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- DeviceId
ParameterSets:
- Name: Id-HdsId
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

### -InstanceGroupName

The name of the instance group to retrieve.
This parameter is optional.

```yaml
Type: System.String
DefaultValue: ''
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

### -Name

The name of the device.
Can be specified using the DeviceName alias.
Required for Name-dsName, Name-dsId, and Name-HdsId parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- DeviceName
ParameterSets:
- Name: Name-HdsId
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
- Name: Name-dsName
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

### Returns instance group objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

