---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMNormalizedProperties

## SYNOPSIS
Creates normalized properties in LogicMonitor.

## SYNTAX

```
New-LMNormalizedProperties [-Alias] <String> [-Properties] <Array> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMNormalizedProperties cmdlet creates normalized properties in LogicMonitor.
Normalized properties allow you to map multiple host properties to a single alias that can be used across your environment.

## EXAMPLES

### EXAMPLE 1
```
New-LMNormalizedProperties -Alias "location" -Properties @("location", "snmp.sysLocation", "auto.meraki.location")
Creates a normalized property with alias "location" mapped to multiple source properties.
```

## PARAMETERS

### -Alias
The alias name for the normalized property.

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

### -Properties
An array of host property names to map to the alias.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
