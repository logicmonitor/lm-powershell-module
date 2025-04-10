---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMCollectorDebugCommand

## SYNOPSIS
Executes debug commands on a LogicMonitor collector.

## SYNTAX

### Id-Groovy
```
Invoke-LMCollectorDebugCommand -Id <Int32> -GroovyCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-Posh
```
Invoke-LMCollectorDebugCommand -Id <Int32> -PoshCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-Debug
```
Invoke-LMCollectorDebugCommand -Id <Int32> -DebugCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-Groovy
```
Invoke-LMCollectorDebugCommand -Name <String> -GroovyCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-Posh
```
Invoke-LMCollectorDebugCommand -Name <String> -PoshCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-Debug
```
Invoke-LMCollectorDebugCommand -Name <String> -DebugCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMCollectorDebugCommand function allows execution of debug, PowerShell, or Groovy commands on a specified LogicMonitor collector.

## EXAMPLES

### EXAMPLE 1
```
#Execute a debug command
Invoke-LMCollectorDebugCommand -Id 123 -DebugCommand "!account" -IncludeResult
```

### EXAMPLE 2
```
#Execute a PowerShell command
Invoke-LMCollectorDebugCommand -Name "Collector1" -PoshCommand "Get-Process"
```

## PARAMETERS

### -Id
The ID of the collector.
Required for Id parameter sets.

```yaml
Type: Int32
Parameter Sets: Id-Groovy, Id-Posh, Id-Debug
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the collector.
Required for Name parameter sets.

```yaml
Type: String
Parameter Sets: Name-Groovy, Name-Posh, Name-Debug
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DebugCommand
The debug command to execute.
Required for Debug parameter sets.

```yaml
Type: String
Parameter Sets: Id-Debug, Name-Debug
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PoshCommand
The PowerShell command to execute.
Required for Posh parameter sets.

```yaml
Type: String
Parameter Sets: Id-Posh, Name-Posh
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroovyCommand
The Groovy command to execute.
Required for Groovy parameter sets.

```yaml
Type: String
Parameter Sets: Id-Groovy, Name-Groovy
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandHostName
The hostname context for the command execution.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandWildValue
The wild value context for the command execution.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeResult
Switch to wait for and include command execution results.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns command execution results if IncludeResult is specified.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
