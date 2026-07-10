---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMCachedAccount
---

# Get-LMCachedAccount

## SYNOPSIS

Retrieves information about cached LogicMonitor account credentials.

## SYNTAX

### __AllParameterSets

```
Get-LMCachedAccount [[-CachedAccountName] <string>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMCachedAccount function retrieves information about cached LogicMonitor account credentials stored in the Logic.Monitor vault.
It can return information for a specific cached account or all cached accounts.

## EXAMPLES

### EXAMPLE 1

#Retrieve all cached accounts
Get-LMCachedAccount

### EXAMPLE 2

#Retrieve a specific cached account
Get-LMCachedAccount -CachedAccountName "MyAccount"

## PARAMETERS

### -CachedAccountName

The name of the specific cached account to retrieve information for.
If not specified, returns information for all cached accounts.

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

### Returns an array of custom objects containing cached account information including CachedAccountName

## NOTES

This function requires access to the Logic.Monitor vault where credentials are stored.

## RELATED LINKS

- [Get-SecretInfo]()
