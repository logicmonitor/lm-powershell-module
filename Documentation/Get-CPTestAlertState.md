---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/11/2026
PlatyPS schema version: 2024-05-01
title: Get-CPTestAlertState
---

# Get-CPTestAlertState

## SYNOPSIS

Retrieves Catchpoint test alert pause state.

## SYNTAX

### __AllParameterSets

```
Get-CPTestAlertState [-Id] <long[]> [<CommonParameters>]
```

## DESCRIPTION

Get-CPTestAlertState returns whether alerts are paused or unpaused for one or
more tests via GET /v4/Tests/alert/state/{testIds}.

## EXAMPLES

### EXAMPLE 1

Get-CPTestAlertState -Id 12345, 67890

### EXAMPLE 2

Get-CPTests -Name "Homepage" | Get-CPTestAlertState

## PARAMETERS

### -Id

One or more Catchpoint test IDs.

```yaml
Type: System.Int64[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- TestId
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
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

### You can pipe Catchpoint.Test objects or objects with an Id property.

### System.Int64[]

## OUTPUTS

### Returns Catchpoint.Test.AlertState objects.

## NOTES

You must run Connect-CPAccount before running this command.
Status ID 0 is Paused and 1 is Unpaused.

## RELATED LINKS

