---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDeviceGroupDatasourceAlertSetting
---

# Get-LMDeviceGroupDatasourceAlertSetting

## SYNOPSIS

Retrieves datasource alert settings for a LogicMonitor device group.

## SYNTAX

### All (Default)

```
Get-LMDeviceGroupDatasourceAlertSetting [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

### Name-dsName

```
Get-LMDeviceGroupDatasourceAlertSetting -DatasourceName <string> -Name <string> [-Filter <Object>]
 [-BatchSize <int>] [<CommonParameters>]
```

### Id-dsName

```
Get-LMDeviceGroupDatasourceAlertSetting -DatasourceName <string> -Id <int> [-Filter <Object>]
 [-BatchSize <int>] [<CommonParameters>]
```

### Name-dsId

```
Get-LMDeviceGroupDatasourceAlertSetting -DatasourceId <int> -Name <string> [-Filter <Object>]
 [-BatchSize <int>] [<CommonParameters>]
```

### Id-dsId

```
Get-LMDeviceGroupDatasourceAlertSetting -DatasourceId <int> -Id <int> [-Filter <Object>]
 [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDeviceGroupDatasourceAlertSetting function retrieves the alert settings for a specific datasource within a device group.
It supports identifying both the group and datasource by either ID or name.

## EXAMPLES

### EXAMPLE 1

#Retrieve alert settings using names
Get-LMDeviceGroupDatasourceAlertSetting -Name "Production Servers" -DatasourceName "CPU"

### EXAMPLE 2

#Retrieve alert settings using IDs
Get-LMDeviceGroupDatasourceAlertSetting -Id 123 -DatasourceId 456

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

The ID of the device group.
Required for Id-dsId and Id-dsName parameter sets.

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

The name of the device group.
Required for Name-dsName and Name-dsId parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### Returns LogicMonitor.DeviceGroupDatasourceAlertSetting objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

