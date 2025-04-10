---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMTopologyMapData

## SYNOPSIS
Retrieves data for a specific topology map from LogicMonitor.

## SYNTAX

### Id
```
Get-LMTopologyMapData -Id <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMTopologyMapData -Name <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMTopologyMapData function retrieves the vertex and edge data for a specified topology map in LogicMonitor.
The map can be identified by either ID or name.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve topology map data by ID
Get-LMTopologyMapData -Id 123
```

### EXAMPLE 2
```
#Retrieve topology map data by name
Get-LMTopologyMapData -Name "Network-Topology"
```

## PARAMETERS

### -Id
The ID of the topology map to retrieve data from.
Required for Id parameter set.

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
The name of the topology map to retrieve data from.
Required for Name parameter set.

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

### Returns LogicMonitor.TopologyMapData objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
