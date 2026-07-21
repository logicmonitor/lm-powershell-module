---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/21/2026
PlatyPS schema version: 2024-05-01
title: Get-EAISdt
---

# Get-EAISdt

## SYNOPSIS

Retrieves scheduled downtime entries from Edwin.

## SYNTAX

### List (Default)

```
Get-EAISdt [<CommonParameters>]
```

### ById

```
Get-EAISdt -Id <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Get-EAISdt lists all scheduled downtime (SDT) entries for the connected Edwin organisation,
or retrieves a single schedule when -Id is specified.
A single schedule response includes
the overrides array (epoch-second timestamps on read).

## EXAMPLES

### EXAMPLE 1

Get-EAISdt

### EXAMPLE 2

Get-EAISdt -Id '6d18821f-8f3c-48ca-8331-3e4c8d77cac3'

### EXAMPLE 3

(Get-EAISdt -Id '6d18821f-8f3c-48ca-8331-3e4c8d77cac3').overrides

## PARAMETERS

### -Id

Schedule ID (UUID).
When specified, retrieves a single schedule via GET /action/sdt/{id}.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ById
  Position: Named
  IsRequired: true
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

### Returns Edwin.SDT objects.



## NOTES

Use Connect-EAIAccount to establish an Edwin session before running this command.
Requires ADMIN role or sdt_read API scope on the Edwin credentials.


## RELATED LINKS



