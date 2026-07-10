---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Import-LMDevicesFromCSV
---

# Import-LMDevicesFromCSV

## SYNOPSIS

Imports devices from a CSV file into LogicMonitor.

## SYNTAX

### Import (Default)

```
Import-LMDevicesFromCSV -FilePath <string> [-PassThru] [-CollectorId <int>]
 [-AutoBalancedCollectorGroupId <int>] [<CommonParameters>]
```

### Sample

```
Import-LMDevicesFromCSV [-GenerateExampleCSV] [<CommonParameters>]
```

## DESCRIPTION

The Import-LMDevicesFromCSV function imports devices from a CSV file into LogicMonitor.
It requires a valid CSV file containing device information such as IP address, display name, host group, collector ID, and description.
The function checks if the user is logged in and has valid API credentials before importing the devices.

## EXAMPLES

### EXAMPLE 1

Import-LMDevicesFromCSV -FilePath "C:\Devices.csv" -CollectorId 1234
Imports devices from the "Devices.csv" file located at "C:\Devices.csv" and assigns the collector with ID 1234 to the imported devices.

### EXAMPLE 2

Import-LMDevicesFromCSV -GenerateExampleCSV
Generates an example CSV file named "SampleLMDeviceImportCSV.csv" in the current directory with sample device information.

## PARAMETERS

### -AutoBalancedCollectorGroupId

Specifies the auto-balanced collector group ID to assign to the imported devices.
This parameter is optional and can be used with the 'Import' parameter set.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Import
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -CollectorId

Specifies the collector ID to assign to the imported devices.
This parameter is optional and can be used with the 'Import' parameter set.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Import
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FilePath

Specifies the path to the CSV file containing the device information.
This parameter is mandatory when the 'Import' parameter set is used.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Import
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GenerateExampleCSV

Generates an example CSV file with sample device information.
This parameter is optional and can be used with the 'Sample' parameter set.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Sample
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PassThru

Indicates whether to return the imported devices as output.
This parameter is optional and can be used with the 'Import' parameter set.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Import
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

## OUTPUTS

## NOTES

- This function requires valid API credentials to connect to LogicMonitor.
- The CSV file must have the following columns: ip, displayname, hostgroup.
collectorid, collectorgroupid, description, property.name1, property.name2..
are optional.
- The function creates device groups if they don't exist based on the host group path specified in the CSV file.
- If the collector ID is not specified in the CSV file, the function uses the collector ID specified by the CollectorId parameter.

## RELATED LINKS

