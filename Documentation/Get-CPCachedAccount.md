---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/11/2026
PlatyPS schema version: 2024-05-01
title: Get-CPCachedAccount
---

# Get-CPCachedAccount

## SYNOPSIS

Retrieves cached Catchpoint account credentials.

## SYNTAX

### __AllParameterSets

```
Get-CPCachedAccount [[-CachedAccountName] <string>] [<CommonParameters>]
```

## DESCRIPTION

Get-CPCachedAccount returns metadata for Catchpoint credentials stored in the Logic.Monitor secret vault.

## EXAMPLES

### EXAMPLE 1

Get-CPCachedAccount

### EXAMPLE 2

Get-CPCachedAccount -CachedAccountName "CP:prod"

## PARAMETERS

### -CachedAccountName

The cached Catchpoint account name to retrieve.
If omitted, all Catchpoint cached accounts are returned.

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

This function requires access to the Logic.Monitor vault where credentials are stored.

## RELATED LINKS

- [Get-SecretInfo]()
