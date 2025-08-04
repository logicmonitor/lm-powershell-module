---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMNormalizedProperty

## SYNOPSIS
Updates normalized properties in LogicMonitor.

## SYNTAX

### Add
```
Set-LMNormalizedProperty -Alias <String> [-Add] -Properties <Array> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Remove
```
Set-LMNormalizedProperty -Alias <String> [-Remove] -Properties <Array> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMNormalizedProperty cmdlet updates normalized properties in LogicMonitor.
Normalized properties allow you to map multiple host properties to a single alias that can be used across your environment.

## EXAMPLES

### EXAMPLE 1
```
Set-LMNormalizedProperty -Add -Alias "location" -Properties @("location", "snmp.sysLocation", "auto.meraki.location")
Updates a normalized property with alias "location" to include the new properties.
```

### EXAMPLE 2
```
Set-LMNormalizedProperty -Remove -Alias "location" -Properties @("auto.meraki.location")
Removes the "auto.meraki.location" property from the "location" alias.
```

## PARAMETERS

### -Alias
The alias name for the normalized property.

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

### -Add
Indicates that properties should be added to the existing normalized property.

```yaml
Type: SwitchParameter
Parameter Sets: Add
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remove
Indicates that properties should be removed from the existing normalized property.

```yaml
Type: SwitchParameter
Parameter Sets: Remove
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
An array of host property names to map to the alias.

```yaml
Type: Array
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

### Returns a message indicating the success of the operation.
## NOTES
This function requires a valid LogicMonitor API authentication and uses API v4.

## RELATED LINKS
