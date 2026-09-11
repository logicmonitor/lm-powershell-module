---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/11/2026
PlatyPS schema version: 2024-05-01
title: New-CPCachedAccount
---

# New-CPCachedAccount

## SYNOPSIS

Creates a cached Catchpoint account connection.

## SYNTAX

### __AllParameterSets

```
New-CPCachedAccount [-BearerToken] <string> [[-AccountName] <string>] [[-ApiBaseUrl] <string>]
 [[-CachedAccountName] <string>] [[-OverwriteExisting] <bool>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

New-CPCachedAccount stores a Catchpoint REST API v2 bearer token securely for use with Connect-CPAccount.

## EXAMPLES

### EXAMPLE 1

New-CPCachedAccount -BearerToken "your-catchpoint-api-key" -AccountName "prod"

## PARAMETERS

### -AccountName

Optional display name for this Catchpoint connection.
Used as the default cached account label.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ApiBaseUrl

Catchpoint REST API v2 base URL.
Defaults to https://io.catchpoint.com/api.

```yaml
Type: System.String
DefaultValue: https://io.catchpoint.com/api
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -BearerToken

REST API v2 key from the Catchpoint portal API settings page.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
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
Defaults to CP:{AccountName} or CP:Catchpoint.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
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

### -OverwriteExisting

Whether to overwrite an existing cached account.

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
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

### None. Returns a success message if the account is cached successfully.

## NOTES

This command creates a secure vault to store credentials if one does not exist.
Catchpoint cached accounts share the Logic.Monitor vault with LM credentials and are identified by Metadata.Type = 'CP'.

## RELATED LINKS

