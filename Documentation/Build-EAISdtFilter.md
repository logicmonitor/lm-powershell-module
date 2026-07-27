---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/21/2026
PlatyPS schema version: 2024-05-01
title: Build-EAISdtFilter
---

# Build-EAISdtFilter

## SYNOPSIS

Builds a filter expression for Edwin SDT schedules.

## SYNTAX

### __AllParameterSets

```
Build-EAISdtFilter [[-ExistingFilter] <Object>] [-PassThru] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Build-EAISdtFilter interactively creates a filter condition object for use with
New-EAISdt, Set-EAISdt, and other Edwin Action Service cmdlets.

The completed filter is saved to the global `$EAIFilter` variable.

## EXAMPLES

### EXAMPLE 1

Build-EAISdtFilter

### EXAMPLE 2

$filter = Build-EAISdtFilter -PassThru
New-EAISdt -Name 'Maintenance' -Duration 60 -Filter $filter

### EXAMPLE 3

Build-EAISdtFilter -ExistingFilter (Get-EAISdt -Id $id).filter

## PARAMETERS

### -ExistingFilter

Optional current filter to keep or replace when updating a schedule.

```yaml
Type: System.Object
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

### -PassThru

Returns the filter object instead of only saving it to `$EAIFilter`.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.



## OUTPUTS

### Returns an Edwin filter object when using -PassThru.



## NOTES

Use Connect-EAIAccount before running Edwin cmdlets that submit the filter.
Requires sdt_read scope to load field metadata from the API when available.


## RELATED LINKS



