---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMLogPartitionAction

## SYNOPSIS
Updates a LogicMonitor Log Partition configuration to either pause or resume log ingestion.

## SYNTAX

### Id
```
Set-LMLogPartitionAction [-Id <Int32>] -Action <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name
```
Set-LMLogPartitionAction [-Name <String>] -Action <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-LMLogPartitionAction function modifies an existing log partition action in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
Set-LMLogPartitionAction -Id 123 -Action "pause"
Updates the log partition with ID 123 to pause log ingestion.
```

## PARAMETERS

### -Id
Specifies the ID of the log partition action to modify.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the current name of the log partition to modify.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Action
Specifies the new action for the log partition.
Possible values are "pause" or "resume".

```yaml
Type: String
Parameter Sets: (All)
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

### None.
## OUTPUTS

### Returns a LogicMonitor.LogPartition object containing the updated log partition information.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
