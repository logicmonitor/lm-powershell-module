---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMNormalizedProperties

## SYNOPSIS
Updates normalized properties in LogicMonitor.

## SYNTAX

### Add
```
Set-LMNormalizedProperties -Alias <String> [-Add] -Properties <Array> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Remove
```
Set-LMNormalizedProperties -Alias <String> [-Remove] -Properties <Array> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-LMNormalizedProperties cmdlet updates normalized properties in LogicMonitor.
Normalized properties allow you to map multiple host properties to a single alias that can be used across your environment.

## EXAMPLES

### EXAMPLE 1
```
Set-LMNormalizedProperties -Add -Alias "location" -Properties @("location", "snmp.sysLocation", "auto.meraki.location")
Updates a normalized property with alias "location" to include the new properties.
```

PS C:\\\> Set-LMNormalizedProperties -Remove -Alias "location" -Properties @("auto.meraki.location")
Removes the "auto.meraki.location" property from the "location" alias.

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
{{ Fill Add Description }}

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
{{ Fill Remove Description }}

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
Requires valid LogicMonitor API credentials set via Connect-LMAccount.
This cmdlet uses LogicMonitor API v4.

## RELATED LINKS
