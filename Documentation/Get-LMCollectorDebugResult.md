---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMCollectorDebugResult

## SYNOPSIS
Retrieves debug results for a LogicMonitor collector.

## SYNTAX

### Id
```
Get-LMCollectorDebugResult -SessionId <Int32> -Id <Int32> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name
```
Get-LMCollectorDebugResult -SessionId <Int32> -Name <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMCollectorDebugResult function retrieves the debug output for a specified collector debug session.
It requires both a session ID and either a collector ID or name to identify the specific debug results to retrieve.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve debug results using collector ID
Get-LMCollectorDebugResult -SessionId 12345 -Id 67890
```

### EXAMPLE 2
```
#Retrieve debug results using collector name
Get-LMCollectorDebugResult -SessionId 12345 -Name "Collector1"
```

## PARAMETERS

### -SessionId
The ID of the debug session to retrieve results from.
This parameter is mandatory.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The ID of the collector to retrieve debug results for.
This parameter is mandatory when using the Id parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the collector to retrieve debug results for.
This parameter is mandatory when using the Name parameter set.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
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

### Returns the debug output for the specified collector debug session.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
