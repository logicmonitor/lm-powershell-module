---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDeviceDatasourceInstanceAlertSetting
---

# Get-LMDeviceDatasourceInstanceAlertSetting

## SYNOPSIS

Retrieves alert settings for a LogicMonitor device datasource instance.

## SYNTAX

### Name-dsName

```
Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceName <string> -Name <string>
 -InstanceName <string> [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

### Id-dsName

```
Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceName <string> -Id <int> -InstanceName <string>
 [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

### Name-dsId

```
Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceId <int> -Name <string> -InstanceName <string>
 [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

### Id-dsId

```
Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceId <int> -Id <int> -InstanceName <string>
 [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDeviceDatasourceInstanceAlertSetting function retrieves the alert configuration settings for a specific device datasource instance.
It supports identifying the device and datasource by either ID or name, and allows filtering of the results.

## EXAMPLES

### EXAMPLE 1

#Retrieve alert settings using names
Get-LMDeviceDatasourceInstanceAlertSetting -Name "MyDevice" -DatasourceName "MyDatasource" -InstanceName "MyInstance"

### EXAMPLE 2

#Retrieve alert settings using IDs with filter
Get-LMDeviceDatasourceInstanceAlertSetting -Id 123 -DatasourceId 456 -InstanceName "MyInstance" -Filter $filterObject

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

A filter object to apply when retrieving alert settings.
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

### -Id

The ID of the device.
Can be specified using the DeviceId alias.
Required for Id-dsId and Id-dsName parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- DeviceId
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

### -InstanceName

The name of the instance to retrieve alert settings for.
This parameter is mandatory.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
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

The name of the device.
Can be specified using the DeviceName alias.
Required for Name-dsName and Name-dsId parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- DeviceName
ParameterSets:
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

### Returns LogicMonitor.AlertSetting objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

