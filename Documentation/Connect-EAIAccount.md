---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Connect-EAIAccount
---

# Connect-EAIAccount

## SYNOPSIS

Connect to an Edwin portal for event ingestion.

## SYNTAX

### Credential (Default)

```
Connect-EAIAccount -EdwinOrg <string> -ClientId <string> -ClientSecret <string>
 [-DisableConsoleLogging] [-SkipCredValidation] [<CommonParameters>]
```

### File

```
Connect-EAIAccount -AuthFilePath <string> [-DisableConsoleLogging] [-SkipCredValidation]
 [<CommonParameters>]
```

### Cached

```
Connect-EAIAccount [-UseCachedCredential] [-CachedAccountName <string>] [-DisableConsoleLogging]
 [-SkipCredValidation] [<CommonParameters>]
```

## DESCRIPTION

Connect-EAIAccount establishes a session for sending custom third-party events to Edwin.
This is separate from Connect-LMAccount.
LogicMonitor alerts are already sent to Edwin natively;
use these cmdlets to ingest events from external systems such as Meraki, ServiceNow, or custom applications.

## EXAMPLES

### EXAMPLE 1

Connect-EAIAccount -EdwinOrg "myorg" -ClientId "client-id" -ClientSecret "client-secret"

### EXAMPLE 2

Connect-EAIAccount -CachedAccountName "EAI:myorg"

## PARAMETERS

### -AuthFilePath

Path to a YAML auth file containing edwin_org, client_id, and client_secret.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: File
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

The cached Edwin account name to use from the Logic.Monitor secret vault.

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

### -ClientId

The client ID used for Edwin HTTP Basic authentication.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Credential
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ClientSecret

The client secret used for Edwin HTTP Basic authentication.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Credential
  Position: Named
  IsRequired: true
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

### -EdwinOrg

The Edwin organization subdomain (the name before ".dexda.ai").

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Credential
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SkipCredValidation

Skip local validation of required credential fields.

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

## OUTPUTS

### None.

## NOTES

LM portal authentication is not required for Edwin event ingestion.nn## RELATED LINKS

