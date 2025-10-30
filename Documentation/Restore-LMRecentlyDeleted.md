---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Restore-LMRecentlyDeleted

## SYNOPSIS
Restores one or more resources from the LogicMonitor recycle bin.

## SYNTAX

```
Restore-LMRecentlyDeleted [-RecycleId] <String[]> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Restore-LMRecentlyDeleted function issues a batch restore request for the provided recycle
identifiers, returning the selected resources to their original state when possible.

## EXAMPLES

### EXAMPLE 1
```
Get-LMRecentlyDeleted -ResourceType device -DeletedBy "lmsupport" | Select-Object -First 5 -ExpandProperty id | Restore-LMRecentlyDeleted
```

Restores the five most recently deleted devices by lmsupport.

## PARAMETERS

### -RecycleId
One or more recycle identifiers representing deleted resources.
Accepts pipeline input and
property names of Id.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

## OUTPUTS

## NOTES
You must establish a session with Connect-LMAccount prior to calling this function.

## RELATED LINKS
