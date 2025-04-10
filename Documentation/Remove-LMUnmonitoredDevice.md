---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMUnmonitoredDevice

## SYNOPSIS
Removes unmonitored devices from LogicMonitor.

## SYNTAX

```
Remove-LMUnmonitoredDevice -Ids <String[]> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMUnmonitoredDevice function removes one or more unmonitored devices from LogicMonitor using their IDs.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMUnmonitoredDevice -Ids "123","456"
Removes the unmonitored devices with IDs "123" and "456".
```

## PARAMETERS

### -Ids
Specifies an array of IDs for the unmonitored devices to remove.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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

### Returns a LogicMonitor.UnmonitoredDevice object containing information about the removed devices.
## NOTES

## RELATED LINKS
