---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# ConvertTo-LMUptimeDevice

## SYNOPSIS
Migrates LogicMonitor website checks to LM Uptime devices.

## SYNTAX

```
ConvertTo-LMUptimeDevice [-Website] <PSObject> [[-NamePrefix] <String>] [[-NameSuffix] <String>]
 [-TargetHostGroupIds] <String[]> [-DisableSourceAlerting] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
ConvertTo-LMUptimeDevice consumes objects returned by Get-LMWebsite, translates their
configuration into the v3 Uptime payload shape, and provisions new Uptime devices by invoking
New-LMUptimeDevice.
The cmdlet preserves alerting behaviour, polling thresholds, locations,
and scripted web steps whenever possible.

## EXAMPLES

### EXAMPLE 1
```
Get-LMWebsite -Name "logicmonitor.com" | ConvertTo-LMUptimeDevice -NameSuffix "-uptime"
```

Migrates the logicmonitor.com website check to an Uptime device with a "-uptime" suffix.

## PARAMETERS

### -Website
Website object returned by Get-LMWebsite.
Accepts pipeline input.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -NamePrefix
Optional string prefixed to the generated Uptime device name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NameSuffix
Optional string appended to the generated Uptime device name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetHostGroupIds
Explicit host group identifiers for the new device.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableSourceAlerting
When specified, disables alerting on the source website after the Uptime device is created successfully.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

## OUTPUTS

### LogicMonitor.LMUptimeDevice
## NOTES
You must run Connect-LMAccount prior to execution.
The cmdlet honours -WhatIf/-Confirm
through ShouldProcess.

## RELATED LINKS
