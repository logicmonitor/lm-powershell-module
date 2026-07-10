---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Invoke-LMAzureSubscriptionDiscovery
---

# Invoke-LMAzureSubscriptionDiscovery

## SYNOPSIS

Discovers Azure subscriptions for a given tenant.

## SYNTAX

### __AllParameterSets

```
Invoke-LMAzureSubscriptionDiscovery [-ClientId] <string> [-SecretKey] <string> [-TenantId] <string>
 [[-IsChinaAccount] <string>] [<CommonParameters>]
```

## DESCRIPTION

The Invoke-LMAzureSubscriptionDiscovery function discovers available Azure subscriptions for a specified Azure tenant using provided credentials.

## EXAMPLES

### EXAMPLE 1

#Discover Azure subscriptions
Invoke-LMAzureSubscriptionDiscovery -ClientId "client-id" -SecretKey "secret-key" -TenantId "tenant-id"

## PARAMETERS

### -ClientId

The Azure Active Directory application client ID.

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

### -IsChinaAccount

Indicates if this is an Azure China account.
Defaults to $false.

```yaml
Type: System.String
DefaultValue: False
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

### -SecretKey

The Azure Active Directory application secret key.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TenantId

The Azure Active Directory tenant ID.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
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

### Returns a list of discovered Azure subscriptions.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

