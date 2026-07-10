---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDeviceData
---

# Get-LMDeviceData

## SYNOPSIS

Retrieves monitoring data for a LogicMonitor device.

## SYNTAX

### dsName-deviceName-instanceId

```
Get-LMDeviceData -DatasourceName <string> -DeviceName <string> -InstanceId <int>
 [-StartDate <datetime>] [-EndDate <datetime>] [-Datapoints <string>] [<CommonParameters>]
```

### dsName-deviceName-instanceName

```
Get-LMDeviceData -DatasourceName <string> -DeviceName <string> [-InstanceName <string>]
 [-StartDate <datetime>] [-EndDate <datetime>] [-Datapoints <string>] [<CommonParameters>]
```

### dsName-deviceId-instanceName

```
Get-LMDeviceData -DatasourceName <string> -DeviceId <int> [-InstanceName <string>]
 [-StartDate <datetime>] [-EndDate <datetime>] [-Datapoints <string>] [<CommonParameters>]
```

### dsName-deviceId-instanceId

```
Get-LMDeviceData -DatasourceName <string> -DeviceId <int> -InstanceId <int> [-StartDate <datetime>]
 [-EndDate <datetime>] [-Datapoints <string>] [<CommonParameters>]
```

### dsId-deviceName-instanceId

```
Get-LMDeviceData -DatasourceId <int> -DeviceName <string> -InstanceId <int> [-StartDate <datetime>]
 [-EndDate <datetime>] [-Datapoints <string>] [<CommonParameters>]
```

### dsId-deviceName-instanceName

```
Get-LMDeviceData -DatasourceId <int> -DeviceName <string> [-InstanceName <string>]
 [-StartDate <datetime>] [-EndDate <datetime>] [-Datapoints <string>] [<CommonParameters>]
```

### dsId-deviceId-instanceName

```
Get-LMDeviceData -DatasourceId <int> -DeviceId <int> [-InstanceName <string>]
 [-StartDate <datetime>] [-EndDate <datetime>] [-Datapoints <string>] [<CommonParameters>]
```

### dsId-deviceId-instanceId

```
Get-LMDeviceData -DatasourceId <int> -DeviceId <int> -InstanceId <int> [-StartDate <datetime>]
 [-EndDate <datetime>] [-Datapoints <string>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDeviceData function retrieves monitoring data from a specific device's datasource instance in LogicMonitor.
It supports various combinations of identifying the device, datasource, and instance, and allows for time range filtering of the data.

## EXAMPLES

### EXAMPLE 1

#Retrieve data using IDs for datapoints "cpu" and "memory"
Get-LMDeviceData -DeviceId 123 -DatasourceId 456 -InstanceId 789 -Datapoints "cpu,memory"

### EXAMPLE 2

#Retrieve data using names with time range
Get-LMDeviceData -DeviceName "Production-Server" -DatasourceName "CPU" -InstanceName "Total" -StartDate (Get-Date).AddDays(-1)

## PARAMETERS

### -Datapoints

Comma separated list of datapoints to retrieve.
If not provided, all datapoints will be retrieved.

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

### -DatasourceId

The ID of the datasource to retrieve data from.
Required for certain parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: dsId-deviceName-instanceId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsId-deviceName-instanceName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsId-deviceId-instanceName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsId-deviceId-instanceId
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

The name of the datasource to retrieve data from.
Required for certain parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: dsName-deviceName-instanceId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsName-deviceName-instanceName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsName-deviceId-instanceName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsName-deviceId-instanceId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DeviceId

The ID of the device to retrieve data from.
Required for certain parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: dsId-deviceId-instanceName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsId-deviceId-instanceId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsName-deviceId-instanceName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsName-deviceId-instanceId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DeviceName

The name of the device to retrieve data from.
Required for certain parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: dsId-deviceName-instanceId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsId-deviceName-instanceName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsName-deviceName-instanceId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsName-deviceName-instanceName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -EndDate

The end date and time for data collection.
Defaults to current time if not specified.

```yaml
Type: System.DateTime
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

### -InstanceId

The ID of the datasource instance to retrieve data from.
Required for certain parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: dsId-deviceName-instanceId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsId-deviceId-instanceId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsName-deviceName-instanceId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsName-deviceId-instanceId
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

The name of the datasource instance to retrieve data from.
Required for certain parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: dsId-deviceId-instanceName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsId-deviceName-instanceName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsName-deviceName-instanceName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: dsName-deviceId-instanceName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StartDate

The start date and time for data collection.
Defaults to 7 days ago if not specified.

```yaml
Type: System.DateTime
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns formatted monitoring data with timestamps and values.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

