---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDatasourceAssociatedDevice
---

# Get-LMDatasourceAssociatedDevice

## SYNOPSIS

Retrieves devices associated with a LogicMonitor datasource.

## SYNTAX

### Id (Default)

```
Get-LMDatasourceAssociatedDevice -Id <int> [-Filter <Object>] [-BatchSize <int>]
 [<CommonParameters>]
```

### Name

```
Get-LMDatasourceAssociatedDevice [-Name <string>] [-Filter <Object>] [-BatchSize <int>]
 [<CommonParameters>]
```

### DisplayName

```
Get-LMDatasourceAssociatedDevice [-DisplayName <string>] [-Filter <Object>] [-BatchSize <int>]
 [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDatasourceAssociatedDevice function retrieves all devices that are associated with a specific datasource.
It can identify the datasource by ID, name, or display name.

## EXAMPLES

### EXAMPLE 1

#Retrieve devices associated with a datasource by ID
Get-LMDatasourceAssociatedDevice -Id 123

### EXAMPLE 2

#Retrieve devices associated with a datasource by name
Get-LMDatasourceAssociatedDevice -Name "CPU"

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

### -DisplayName

The display name of the datasource to retrieve associated devices for.
Part of a mutually exclusive parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DisplayName
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

A filter object to apply when retrieving associated devices.
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

The ID of the datasource to retrieve associated devices for.
This parameter is mandatory when using the Id parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
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

The name of the datasource to retrieve associated devices for.
Part of a mutually exclusive parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### Returns LogicMonitor.DatasourceDevice objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

