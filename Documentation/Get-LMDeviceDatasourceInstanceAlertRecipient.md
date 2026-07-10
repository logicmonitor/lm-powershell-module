---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDeviceDatasourceInstanceAlertRecipient
---

# Get-LMDeviceDatasourceInstanceAlertRecipient

## SYNOPSIS

Retrieves alert recipients for a specific data point in a LogicMonitor device datasource instance.

## SYNTAX

### Name-dsName

```
Get-LMDeviceDatasourceInstanceAlertRecipient -DatasourceName <string> -Name <string>
 -InstanceName <string> -DataPointName <string> [<CommonParameters>]
```

### Id-dsName

```
Get-LMDeviceDatasourceInstanceAlertRecipient -DatasourceName <string> -Id <int>
 -InstanceName <string> -DataPointName <string> [<CommonParameters>]
```

### Name-dsId

```
Get-LMDeviceDatasourceInstanceAlertRecipient -DatasourceId <int> -Name <string>
 -InstanceName <string> -DataPointName <string> [<CommonParameters>]
```

### Id-dsId

```
Get-LMDeviceDatasourceInstanceAlertRecipient -DatasourceId <int> -Id <int> -InstanceName <string>
 -DataPointName <string> [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDeviceDatasourceInstanceAlertRecipient function retrieves the alert recipients configured for a specific data point within a device's datasource instance.
It supports identifying the device and datasource by either ID or name.

## EXAMPLES

### EXAMPLE 1

#Retrieve alert recipients using names
Get-LMDeviceDatasourceInstanceAlertRecipient -DatasourceName "Ping" -Name "Server01" -InstanceName "Instance01" -DataPointName "PingLossPercent"

### EXAMPLE 2

#Retrieve alert recipients using IDs
Get-LMDeviceDatasourceInstanceAlertRecipient -DatasourceId 123 -Id 456 -InstanceName "Instance01" -DataPointName "PingLossPercent"

## PARAMETERS

### -DataPointName

The name of the data point to retrieve alert recipients for.
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

The name of the datasource instance.
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

### Returns alert recipient configuration objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

