---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/11/2026
PlatyPS schema version: 2024-05-01
title: Get-CPInstantTest
---

# Get-CPInstantTest

## SYNOPSIS

Retrieves Catchpoint instant test results.

## SYNTAX

### __AllParameterSets

```
Get-CPInstantTest [-Id] <long> [-NodeId] <int> [[-StepId] <int>] [<CommonParameters>]
```

## DESCRIPTION

Get-CPInstantTest returns performance data for an instant test via
GET /v4/InstantTests/{id}.
Results are for one node and a single step.
If -StepId is omitted, the first step is returned.

## EXAMPLES

### EXAMPLE 1

Get-CPInstantTest -Id 12345 -NodeId 17

### EXAMPLE 2

$run = New-CPInstantTest -Url "https://example.com" -NodeId 17
Get-CPInstantTest -Id $run.id -NodeId 17

## PARAMETERS

### -Id

Instant test ID.

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

### -NodeId

Node ID to retrieve results for.

```yaml
Type: System.Int32
DefaultValue: 0
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

### -StepId

Step ID for multi-step transaction tests.
Defaults to 0 (first step).

```yaml
Type: System.Int32
DefaultValue: 0
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### You can pipe objects with an Id property to this command.

### System.Int64

## OUTPUTS

### Returns a Catchpoint.InstantTest.Result object.

## NOTES

You must run Connect-CPAccount before running this command.
This is an analytics endpoint and counts against Catchpoint usage limits.

## RELATED LINKS

