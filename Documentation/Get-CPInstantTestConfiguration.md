---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/11/2026
PlatyPS schema version: 2024-05-01
title: Get-CPInstantTestConfiguration
---

# Get-CPInstantTestConfiguration

## SYNOPSIS

Retrieves Catchpoint instant test configuration.

## SYNTAX

### __AllParameterSets

```
Get-CPInstantTestConfiguration [-Id] <long> [<CommonParameters>]
```

## DESCRIPTION

Get-CPInstantTestConfiguration returns the properties used to create an instant
test via GET /v4/InstantTests/configuration/{id}.
Pass -Id 0 to get a sample
payload for New-CPInstantTest.

## EXAMPLES

### EXAMPLE 1

Get-CPInstantTestConfiguration -Id 0

### EXAMPLE 2

Get-CPInstantTestConfiguration -Id 12345

## PARAMETERS

### -Id

Instant test ID.
Pass 0 to return post data for creating a new instant test.

```yaml
Type: System.Int64
DefaultValue: 0
SupportsWildcards: false
Aliases:
- InstantTestId
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
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

### You can pipe objects with an Id property to this command.

### System.Int64

## OUTPUTS

### Returns a Catchpoint.InstantTest.Configuration object.

## NOTES

You must run Connect-CPAccount before running this command.

## RELATED LINKS

