---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMServiceTemplate

## SYNOPSIS
Removes a LogicMonitor Service template.

## SYNTAX

```
Remove-LMServiceTemplate [-Id] <String> [[-DeleteHard] <Boolean>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMServiceTemplate function removes a LogicMonitor Service template by ID.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMServiceTemplate -Id 6
This example removes the LogicMonitor Service template with ID 6 using soft delete.
```

### EXAMPLE 2
```
Remove-LMServiceTemplate -Id 6 -DeleteHard $true
This example removes the LogicMonitor Service template with ID 6 using hard delete.
```

## PARAMETERS

### -Id
The ID of the Service template to remove.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeleteHard
Specifies whether to perform a hard delete.
Default is $false (soft delete).

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns a PSCustomObject containing the ID of the removed service template and a success message confirming the removal.
## NOTES

## RELATED LINKS
