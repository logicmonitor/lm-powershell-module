---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/11/2026
PlatyPS schema version: 2024-05-01
title: Get-CPTestEnumeration
---

# Get-CPTestEnumeration

## SYNOPSIS

Retrieves Catchpoint test enumerations.

## SYNTAX

### __AllParameterSets

```
Get-CPTestEnumeration [[-Include] <string[]>] [<CommonParameters>]
```

## DESCRIPTION

Get-CPTestEnumeration returns name/ID enumerations used to create and update
tests via GET /v4/Tests/enumeration.
When -Include is omitted, all
enumerations are returned.

## EXAMPLES

### EXAMPLE 1

Get-CPTestEnumeration

### EXAMPLE 2

Get-CPTestEnumeration -Include DisplayTestType, DisplayMonitorType

## PARAMETERS

### -Include

One or more enumeration sections to return.
When omitted, all sections are returned.

```yaml
Type: System.String[]
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

### Returns a Catchpoint.Test.Enumeration object.

## NOTES

You must run Connect-CPAccount before running this command.

## RELATED LINKS

