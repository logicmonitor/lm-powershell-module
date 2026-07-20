---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Remove-EAICachedAccount
---

# Remove-EAICachedAccount

## SYNOPSIS

Removes cached Edwin account credentials.

## SYNTAX

### Single

```
Remove-EAICachedAccount -CachedAccountName <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### All

```
Remove-EAICachedAccount [-RemoveAllEntries] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Remove-EAICachedAccount removes Edwin cached credentials from the Logic.Monitor secret vault.

## EXAMPLES

### EXAMPLE 1

Remove-EAICachedAccount -CachedAccountName "EAI:myorg"

### EXAMPLE 2

Remove-EAICachedAccount -RemoveAllEntries

## PARAMETERS

### -CachedAccountName

The cached Edwin account name to remove.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- EdwinOrg
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

Remove all cached Edwin accounts from the vault.

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

### System.String

## OUTPUTS

### None.

## NOTES

## RELATED LINKS

