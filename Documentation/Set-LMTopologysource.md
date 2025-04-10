---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMTopologysource

## SYNOPSIS
Updates a LogicMonitor topology source configuration.

## SYNTAX

### Id
```
Set-LMTopologysource -Id <String> [-NewName <String>] [-Description <String>] [-appliesTo <String>]
 [-TechNotes <String>] [-PollingIntervalInSeconds <Int32>] [-Group <String>] [-ScriptType <String>]
 [-Script <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Set-LMTopologysource -Name <String> [-NewName <String>] [-Description <String>] [-appliesTo <String>]
 [-TechNotes <String>] [-PollingIntervalInSeconds <Int32>] [-Group <String>] [-ScriptType <String>]
 [-Script <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMTopologysource function modifies an existing topology source in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
Set-LMTopologysource -Id 123 -NewName "UpdatedSource" -Description "New description"
Updates the topology source with new name and description.
```

## PARAMETERS

### -Id
Specifies the ID of the topology source to modify.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the current name of the topology source.

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

### -NewName
Specifies the new name for the topology source.

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

### -Description
Specifies the description for the topology source.

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

### -appliesTo
Specifies the applies to expression for the topology source.

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

### -TechNotes
Specifies technical notes for the topology source.

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

### -PollingIntervalInSeconds
Specifies the polling interval in seconds.
Valid values: 1800, 3600, 7200, 21600.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group
Specifies the group for the topology source.

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

### -ScriptType
Specifies the script type.
Valid values: "embed", "powerShell".

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

### -Script
Specifies the script content.

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

### Returns a LogicMonitor.Topologysource object containing the updated configuration.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
