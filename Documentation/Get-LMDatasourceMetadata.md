---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDatasourceMetadata
---

# Get-LMDatasourceMetadata

## SYNOPSIS

Retrieves metadata for a LogicMonitor datasource.

## SYNTAX

### All (Default)

```
Get-LMDatasourceMetadata [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMDatasourceMetadata [-Id <int>] [-BatchSize <int>] [<CommonParameters>]
```

### Name

```
Get-LMDatasourceMetadata [-Name <string>] [-BatchSize <int>] [<CommonParameters>]
```

### DisplayName

```
Get-LMDatasourceMetadata [-DisplayName <string>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDatasourceMetadata function retrieves metadata information for a specified LogicMonitor datasource.
The datasource can be identified by ID, name, or display name.

## EXAMPLES

### EXAMPLE 1

#Retrieve metadata by datasource ID
Get-LMDatasourceMetadata -Id 123

### EXAMPLE 2

#Retrieve metadata by datasource name
Get-LMDatasourceMetadata -Name "CPU"

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

The display name of the datasource to retrieve metadata for.
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

### -Id

The ID of the datasource to retrieve metadata for.
Part of a mutually exclusive parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
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

The name of the datasource to retrieve metadata for.
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

### Returns metadata information for the specified datasource.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

