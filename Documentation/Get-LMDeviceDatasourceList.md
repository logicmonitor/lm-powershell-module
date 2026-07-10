---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDeviceDataSourceList
---

# Get-LMDeviceDataSourceList

## SYNOPSIS

Retrieves a list of device data sources from LogicMonitor.

## SYNTAX

### Id (Default)

```
Get-LMDeviceDataSourceList -Id <int> [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

### Name

```
Get-LMDeviceDataSourceList [-Name <string>] [-Filter <Object>] [-BatchSize <int>]
 [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDeviceDatasourceList function retrieves all data sources associated with a specific device.
The device can be identified by either ID or name, and the results can be filtered.

## EXAMPLES

### EXAMPLE 1

#Retrieve data sources by device ID
Get-LMDeviceDatasourceList -Id 1234

### EXAMPLE 2

#Retrieve data sources by device name with filter
Get-LMDeviceDatasourceList -Name "MyDevice" -Filter $filterObject

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

### -Filter

A filter object to apply when retrieving data sources.
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
Required for Id parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- DeviceId
ParameterSets:
- Name: Id
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
Required for Name parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- DeviceName
ParameterSets:
- Name: Name
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

### Returns LogicMonitor.DeviceDatasourceList objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

