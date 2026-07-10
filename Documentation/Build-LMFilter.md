---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Build-LMFilter
---

# Build-LMFilter

## SYNOPSIS

Builds a filter expression for Logic Monitor API queries.

## SYNTAX

### __AllParameterSets

```
Build-LMFilter [[-ResourcePath] <string>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

The Build-LMFilter function creates a filter expression by interactively prompting for conditions and operators.
It supports basic filtering for single fields and advanced filtering for property-based queries.
Multiple conditions can be combined using AND/OR operators.
When a ResourcePath is provided, the wizard validates field names and provides suggestions.

## EXAMPLES

### EXAMPLE 1

#Build a basic filter expression
Build-LMFilter
This example launches the interactive filter builder wizard.

### EXAMPLE 2

#Build a filter with field validation for devices
Build-LMFilter -ResourcePath "/device/devices"
This example launches the wizard with field validation and suggestions for the device endpoint.

### EXAMPLE 3

#Build a filter and return the expression
Build-LMFilter -PassThru
This example builds a filter and returns the expression as a string.

## PARAMETERS

### -PassThru

When specified, returns the filter expression as a string instead of displaying it in a panel.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -ResourcePath

Optional.
The API endpoint path (e.g., '/device/devices') to provide field validation and suggestions.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
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

### [String] Returns a PowerShell filter expression when using -PassThru.

## NOTES

The filter expression is saved to the global $LMFilter variable.
When ResourcePath is provided, field names are validated against the API schema.

## RELATED LINKS

