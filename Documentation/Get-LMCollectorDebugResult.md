---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMCollectorDebugResult
---

# Get-LMCollectorDebugResult

## SYNOPSIS

Retrieves debug results for a LogicMonitor collector.

## SYNTAX

### Id

```
Get-LMCollectorDebugResult -SessionId <int> -Id <int> [<CommonParameters>]
```

### Name

```
Get-LMCollectorDebugResult -SessionId <int> -Name <string> [<CommonParameters>]
```

## DESCRIPTION

The Get-LMCollectorDebugResult function retrieves the debug output for a specified collector debug session.
It requires both a session ID and either a collector ID or name to identify the specific debug results to retrieve.

## EXAMPLES

### EXAMPLE 1

#Retrieve debug results using collector ID
Get-LMCollectorDebugResult -SessionId 12345 -Id 67890

### EXAMPLE 2

#Retrieve debug results using collector name
Get-LMCollectorDebugResult -SessionId 12345 -Name "Collector1"

## PARAMETERS

### -Id

The ID of the collector to retrieve debug results for.
This parameter is mandatory when using the Id parameter set.

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

### -Name

The name of the collector to retrieve debug results for.
This parameter is mandatory when using the Name parameter set.

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

### -SessionId

The ID of the debug session to retrieve results from.
This parameter is mandatory.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
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

### Returns the debug output for the specified collector debug session.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

