---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Remove-LMCachedAccount
---

# Remove-LMCachedAccount

## SYNOPSIS

Removes cached account information from the Logic.Monitor vault.

## SYNTAX

### Single

```
Remove-LMCachedAccount -CachedAccountName <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### All

```
Remove-LMCachedAccount [-RemoveAllEntries] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Remove-LMCachedAccount function is used to remove cached account information from the Logic.Monitor vault.
It provides two parameter sets: 'Single' and 'All'.
When using the 'Single' parameter set, you can specify a single cached account to remove.
When using the 'All' parameter set, all cached accounts will be removed.

## EXAMPLES

### EXAMPLE 1

Remove-LMCachedAccount -CachedAccountName "JohnDoe"
Removes the cached account with the name "JohnDoe" from the Logic.Monitor vault.

### EXAMPLE 2

Remove-LMCachedAccount -RemoveAllEntries
Removes all cached accounts from the Logic.Monitor vault.

## PARAMETERS

### -CachedAccountName

Specifies the name of the cached account to remove.
This parameter is used with the 'Single' parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Portal
ParameterSets:
- Name: Single
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -RemoveAllEntries

Indicates that all cached accounts should be removed.
This parameter is used with the 'All' parameter set.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

### You can pipe objects to this function.

### System.String

## OUTPUTS

### This function does not generate any output.

## NOTES

This function operates on the local credential vault and does not require API authentication.

## RELATED LINKS

