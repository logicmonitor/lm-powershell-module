---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDiagnosticSource
---

# Get-LMDiagnosticSource

## SYNOPSIS

Retrieves diagnostic sources from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMDiagnosticSource [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMDiagnosticSource [-Id <int>] [-BatchSize <int>] [<CommonParameters>]
```

### Name

```
Get-LMDiagnosticSource [-Name <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMDiagnosticSource [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDiagnosticSource function retrieves diagnostic source information from LogicMonitor.
It can return diagnostic sources by ID, name, or using filters.

## EXAMPLES

### EXAMPLE 1

# Retrieve a diagnostic source by ID
Get-LMDiagnosticSource -Id 123

### EXAMPLE 2

# Retrieve a diagnostic source by name
Get-LMDiagnosticSource -Name "Test_DiagnosticSource"

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

A filter object to apply when retrieving diagnostic sources.
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

The ID of the diagnostic source to retrieve.
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

The name of the diagnostic source to retrieve.
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

### Returns LogicMonitor.DiagnosticSource objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

