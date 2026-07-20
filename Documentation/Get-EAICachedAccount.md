---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-EAICachedAccount
---

# Get-EAICachedAccount

## SYNOPSIS

Retrieves cached Edwin account credentials.

## SYNTAX

### __AllParameterSets

```
Get-EAICachedAccount [[-CachedAccountName] <string>] [<CommonParameters>]
```

## DESCRIPTION

Get-EAICachedAccount returns metadata for Edwin credentials stored in the Logic.Monitor secret vault.

## EXAMPLES

### EXAMPLE 1

Get-EAICachedAccount

### EXAMPLE 2

Get-EAICachedAccount -CachedAccountName "EAI:myorg"

## PARAMETERS

### -CachedAccountName

The cached Edwin account name to retrieve.
If omitted, all Edwin cached accounts are returned.

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

### Returns PSCustomObject entries with CachedAccountName

## NOTES

This function requires access to the Logic.Monitor vault where credentials are stored.nn## RELATED LINKS

- [Get-SecretInfo]()
