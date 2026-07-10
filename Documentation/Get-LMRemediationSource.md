---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMRemediationSource
---

# Get-LMRemediationSource

## SYNOPSIS

Retrieves remediation sources from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMRemediationSource [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMRemediationSource [-Id <int>] [-BatchSize <int>] [<CommonParameters>]
```

### Name

```
Get-LMRemediationSource [-Name <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMRemediationSource [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMRemediationSource function retrieves remediation source information from LogicMonitor.
It can return remediation sources by ID, name, display name, or using filters.

## EXAMPLES

### EXAMPLE 1

# Retrieve all remediation sources
Get-LMRemediationSource

### EXAMPLE 2

# Retrieve a remediation source by ID
Get-LMRemediationSource -Id 123

### EXAMPLE 3

# Retrieve a remediation source by name
Get-LMRemediationSource -Name "Test_RemediationSource"

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

A filter object to apply when retrieving remediation sources.
Part of a mutually exclusive parameter set.

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

The ID of the remediation source to retrieve.
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

The name of the remediation source to retrieve.
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

### Returns LogicMonitor.RemediationSource objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

