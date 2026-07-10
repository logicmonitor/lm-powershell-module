---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Invoke-LMCollectorDebugCommand
---

# Invoke-LMCollectorDebugCommand

## SYNOPSIS

Executes debug commands on a LogicMonitor collector.

## SYNTAX

### Id-Groovy

```
Invoke-LMCollectorDebugCommand -Id <int> -GroovyCommand <string> [-CommandHostName <string>]
 [-CommandWildValue <string>] [-IncludeResult] [<CommonParameters>]
```

### Id-Posh

```
Invoke-LMCollectorDebugCommand -Id <int> -PoshCommand <string> [-CommandHostName <string>]
 [-CommandWildValue <string>] [-IncludeResult] [<CommonParameters>]
```

### Id-Debug

```
Invoke-LMCollectorDebugCommand -Id <int> -DebugCommand <string> [-CommandHostName <string>]
 [-CommandWildValue <string>] [-IncludeResult] [<CommonParameters>]
```

### Name-Groovy

```
Invoke-LMCollectorDebugCommand -Name <string> -GroovyCommand <string> [-CommandHostName <string>]
 [-CommandWildValue <string>] [-IncludeResult] [<CommonParameters>]
```

### Name-Posh

```
Invoke-LMCollectorDebugCommand -Name <string> -PoshCommand <string> [-CommandHostName <string>]
 [-CommandWildValue <string>] [-IncludeResult] [<CommonParameters>]
```

### Name-Debug

```
Invoke-LMCollectorDebugCommand -Name <string> -DebugCommand <string> [-CommandHostName <string>]
 [-CommandWildValue <string>] [-IncludeResult] [<CommonParameters>]
```

## DESCRIPTION

The Invoke-LMCollectorDebugCommand function allows execution of debug, PowerShell, or Groovy commands on a specified LogicMonitor collector.

## EXAMPLES

### EXAMPLE 1

#Execute a debug command
Invoke-LMCollectorDebugCommand -Id 123 -DebugCommand "!account" -IncludeResult

### EXAMPLE 2

#Execute a PowerShell command
Invoke-LMCollectorDebugCommand -Name "Collector1" -PoshCommand "Get-Process"

## PARAMETERS

### -CommandHostName

The hostname context for the command execution.

```yaml
Type: System.String
DefaultValue: ''
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

### -CommandWildValue

The wild value context for the command execution.

```yaml
Type: System.String
DefaultValue: ''
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

### -DebugCommand

The debug command to execute.
Required for Debug parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-Debug
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-Debug
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GroovyCommand

The Groovy command to execute.
Required for Groovy parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-Groovy
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-Groovy
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

The ID of the collector.
Required for Id parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id-Groovy
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-Posh
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-Debug
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IncludeResult

Switch to wait for and include command execution results.

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

### -Name

The name of the collector.
Required for Name parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-Groovy
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-Posh
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-Debug
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PoshCommand

The PowerShell command to execute.
Required for Posh parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-Posh
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-Posh
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

### Returns command execution results if IncludeResult is specified.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

