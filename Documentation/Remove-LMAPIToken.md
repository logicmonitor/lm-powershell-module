---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Remove-LMAPIToken
---

# Remove-LMAPIToken

## SYNOPSIS

Removes an API token from Logic Monitor.

## SYNTAX

### Id (Default)

```
Remove-LMAPIToken -UserId <int> -APITokenId <int> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name

```
Remove-LMAPIToken -UserName <string> -APITokenId <int> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### AccessId

```
Remove-LMAPIToken -AccessId <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Remove-LMAPIToken function is used to remove an API token from Logic Monitor.
It supports removing the token by specifying either the token's ID, the user's ID and token's ID, or the user's name and token's ID.

## EXAMPLES

### EXAMPLE 1

Remove-LMAPIToken -UserId 1234 -APITokenId 5678
Removes the API token with ID 5678 associated with the user with ID 1234.

### EXAMPLE 2

Remove-LMAPIToken -UserName "john.doe" -APITokenId 5678
Removes the API token with ID 5678 associated with the user with name "john.doe".

### EXAMPLE 3

Remove-LMAPIToken -AccessId "abcd1234"
Removes the API token with the specified access ID.

## PARAMETERS

### -AccessId

The access ID of the API token.
This parameter is mandatory when using the 'AccessId' parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AccessId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -APITokenId

The ID of the API token.
This parameter is mandatory when using the 'Id' or 'Name' parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id
  Position: Named
  IsRequired: true
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

### -UserId

The ID of the user associated with the API token.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UserName

The name of the user associated with the API token.
This parameter is mandatory when using the 'Name' parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name
  Position: Named
  IsRequired: true
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

### You can pipe API token objects to this function.

### System.String

## OUTPUTS

### Returns a PSCustomObject containing the ID of the removed API token and a success message confirming the removal.

## NOTES

This function requires a valid API authentication.
Make sure to log in using Connect-LMAccount before running this command.

## RELATED LINKS

