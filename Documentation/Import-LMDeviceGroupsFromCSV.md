---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Import-LMDeviceGroupsFromCSV
---

# Import-LMDeviceGroupsFromCSV

## SYNOPSIS

Imports list of device groups based on specified CSV file.

## SYNTAX

### Import (Default)

```
Import-LMDeviceGroupsFromCSV -FilePath <string> [-PassThru] [<CommonParameters>]
```

### Sample

```
Import-LMDeviceGroupsFromCSV [-GenerateExampleCSV] [<CommonParameters>]
```

## DESCRIPTION

Imports list of device groups based on specified CSV file.
You can generate a sample of the CSV file by specifying the -GenerateExampleCSV parameter.

## EXAMPLES

### EXAMPLE 1

Import-LMDeviceGroupsFromCSV -FilePath ./ImportList.csv -PassThru

## PARAMETERS

### -FilePath

Path to the CSV file containing device groups to import.
Required for Import parameter set.

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

Generates a sample CSV file to use as a template for importing device groups.

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

Returns the imported device group objects.
By default, no output is returned.

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

### None. Does not accept pipeline input.

## OUTPUTS

## NOTES

Assumes csv with the headers name,fullpath,description,appliesTo,property1,property2,property[n].
Name and fullpath are the only required fields.

## RELATED LINKS

