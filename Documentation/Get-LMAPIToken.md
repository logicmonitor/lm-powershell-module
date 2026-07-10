---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMAPIToken
---

# Get-LMAPIToken

## SYNOPSIS

Retrieves API tokens from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMAPIToken [-Type <string>] [-BatchSize <int>] [<CommonParameters>]
```

### AdminId

```
Get-LMAPIToken [-AdminId <int>] [-Type <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMAPIToken [-Id <int>] [-Type <string>] [-BatchSize <int>] [<CommonParameters>]
```

### AccessId

```
Get-LMAPIToken [-AccessId <string>] [-Type <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMAPIToken [-Filter <Object>] [-Type <string>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMAPIToken function retrieves API tokens from LogicMonitor based on specified criteria.
It can return tokens by admin ID, token ID, access ID, or using filters.

## EXAMPLES

### EXAMPLE 1

#Retrieve tokens for a specific admin
Get-LMAPIToken -AdminId 1234

### EXAMPLE 2

#Retrieve a specific token by ID
Get-LMAPIToken -Id 5678

### EXAMPLE 3

#Retrieve bearer tokens only
Get-LMAPIToken -Type "Bearer"

## PARAMETERS

### -AccessId

The access ID of the specific API token to retrieve.
Part of a mutually exclusive parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AccessId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AdminId

The ID of the admin to retrieve tokens for.
Part of a mutually exclusive parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AdminId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -BatchSize

The number of results to return per request.
Must be between 1 and 1000.
Defaults to 1000.

```yaml
Type: System.Int32
DefaultValue: 1000
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

### -Filter

A filter object to apply when retrieving tokens.
Part of a mutually exclusive parameter set.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

The ID of the specific API token to retrieve.
Part of a mutually exclusive parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Type

The type of token to retrieve.
Valid values are "LMv1", "Bearer", "*".
Defaults to "*".

```yaml
Type: System.String
DefaultValue: '*'
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns LogicMonitor.APIToken objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

