---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMSysOIDMap
---

# Get-LMSysOIDMap

## SYNOPSIS

Gets LogicMonitor system OID mappings.

## SYNTAX

### All (Default)

```
Get-LMSysOIDMap [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMSysOIDMap [-Id <int>] [-BatchSize <int>] [<CommonParameters>]
```

### Name

```
Get-LMSysOIDMap [-Name <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMSysOIDMap [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMSysOIDMap function retrieves system OID mappings from LogicMonitor.
It can retrieve all mappings, a specific mapping by ID or name, or filter the results.

## EXAMPLES

### EXAMPLE 1

#Retrieve all system OID mappings
Get-LMSysOIDMap

### EXAMPLE 2

#Retrieve a specific OID mapping by name
Get-LMSysOIDMap -Name "\.1\.3\.6\.1\.4\.1\.318\.1\.1\.32"

## PARAMETERS

### -BatchSize

Specifies the number of records to retrieve per API request.
Valid values are 1-1000.
Default is 1000.

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

Specifies a filter to apply to the results.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter
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

Specifies the ID of a specific OID mapping to retrieve.

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

Specifies the name of a specific OID mapping to retrieve.

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

### Returns LogicMonitor.SysOIDMap objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

