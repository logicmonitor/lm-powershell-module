---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: New-LMCachedAccount
---

# New-LMCachedAccount

## SYNOPSIS

Creates a cached LogicMonitor account connection.

## SYNTAX

### LMv1 (Default)

```
New-LMCachedAccount -AccessId <string> -AccessKey <string> -AccountName <string>
 [-CachedAccountName <string>] [-OverwriteExisting <bool>] [-GovCloud] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Bearer

```
New-LMCachedAccount -AccountName <string> -BearerToken <string> [-CachedAccountName <string>]
 [-OverwriteExisting <bool>] [-GovCloud] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The New-LMCachedAccount function stores LogicMonitor portal credentials securely for use with Connect-LMAccount.

## EXAMPLES

### EXAMPLE 1

#Cache LMv1 credentials
New-LMCachedAccount -AccessId "id123" -AccessKey "key456" -AccountName "company"

### EXAMPLE 2

#Cache Bearer token
New-LMCachedAccount -BearerToken "token123" -AccountName "company" -CachedAccountName "prod"

### EXAMPLE 3

#Cache FedRAMP GovCloud credentials
New-LMCachedAccount -AccessId "id123" -AccessKey "key456" -AccountName "agency" -GovCloud

## PARAMETERS

### -AccessId

The Access ID from your LogicMonitor API credentials.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: LMv1
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AccessKey

The Access Key from your LogicMonitor API credentials.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: LMv1
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AccountName

The portal subdomain (e.g., "company" for company.logicmonitor.com).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Bearer
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: LMv1
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -BearerToken

The Bearer token for authentication (alternative to AccessId/AccessKey).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Bearer
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -CachedAccountName

The name to use for the cached account.
Defaults to AccountName.

```yaml
Type: System.String
DefaultValue: $AccountName
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

### -GovCloud

Connect using the LM GovCloud (FedRAMP) portal when this cached account is used.

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

### -OverwriteExisting

Whether to overwrite an existing cached account.
Defaults to false.

```yaml
Type: System.Boolean
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

### None. You cannot pipe objects to this command.

## OUTPUTS

### None. Returns success message if account is cached successfully.

## NOTES

This command creates a secure vault to store credentials if one doesn't exist.

## RELATED LINKS

