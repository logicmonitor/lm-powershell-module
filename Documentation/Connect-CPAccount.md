---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/11/2026
PlatyPS schema version: 2024-05-01
title: Connect-CPAccount
---

# Connect-CPAccount

## SYNOPSIS

Connect to Catchpoint using a REST API v2 bearer token.

## SYNTAX

### Bearer (Default)

```
Connect-CPAccount -BearerToken <string> [-AccountName <string>] [-ApiBaseUrl <string>]
 [-DisableConsoleLogging] [-SkipCredValidation] [<CommonParameters>]
```

### Cached

```
Connect-CPAccount [-UseCachedCredential] [-CachedAccountName <string>] [-DisableConsoleLogging]
 [-SkipCredValidation] [<CommonParameters>]
```

## DESCRIPTION

Connect-CPAccount establishes a session for Catchpoint REST API v2 commands.
Catchpoint authenticates with the v2 API key from the Catchpoint portal API
settings page.
That key is an OAuth bearer token and is valid for two years
from generation unless it is regenerated or revoked.

Use a client-level key to access data at the client level, or a division-level
key to access data within a specific division.

## EXAMPLES

### EXAMPLE 1

Connect-CPAccount -BearerToken "your-catchpoint-api-key"

### EXAMPLE 2

Connect-CPAccount -BearerToken "your-catchpoint-api-key" -AccountName "prod"

### EXAMPLE 3

Connect-CPAccount -CachedAccountName "CP:prod"

## PARAMETERS

### -AccountName

Optional display name for this Catchpoint connection.
Used as a label in
status output and when selecting cached credentials.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Bearer
  Position: Named
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
- Name: Bearer
  Position: Named
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
Passed as a
bearer token in the Authorization header of subsequent requests.

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

The cached Catchpoint account name to use from the Logic.Monitor secret vault.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Cached
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DisableConsoleLogging

Disables informational messages for subsequent commands.
Console logging is enabled by default.

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

### -SkipCredValidation

Skip the remote token check against the Catchpoint API.

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

### -UseCachedCredential

Load credentials from the Logic.Monitor secret vault using interactive selection.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Cached
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

### None.

## NOTES

You must run this command before other Catchpoint commands.
The bearer token is the only required credential.
AccountName is optional
and is used only as a local label.

## RELATED LINKS

