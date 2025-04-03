---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMCollector

## SYNOPSIS
Updates a LogicMonitor collector's configuration.

## SYNTAX

### Id (Default)
```
Set-LMCollector -Id <Int32> [-Description <String>] [-BackupAgentId <Int32>] [-CollectorGroupId <Int32>]
 [-Properties <Hashtable>] [-EnableFailBack <Boolean>] [-EnableFailOverOnCollectorDevice <Boolean>]
 [-EscalatingChainId <Int32>] [-SuppressAlertClear <Boolean>] [-ResendAlertInterval <Int32>]
 [-SpecifiedCollectorDeviceGroupId <Int32>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name
```
Set-LMCollector -Name <String> [-Description <String>] [-BackupAgentId <Int32>] [-CollectorGroupId <Int32>]
 [-Properties <Hashtable>] [-EnableFailBack <Boolean>] [-EnableFailOverOnCollectorDevice <Boolean>]
 [-EscalatingChainId <Int32>] [-SuppressAlertClear <Boolean>] [-ResendAlertInterval <Int32>]
 [-SpecifiedCollectorDeviceGroupId <Int32>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-LMCollector function modifies an existing collector's settings in LogicMonitor, including its description, backup agent, group, and various properties.

## EXAMPLES

### EXAMPLE 1
```
Set-LMCollector -Id 123 -Description "Updated collector" -EnableFailBack $true
Updates the collector with ID 123 with a new description and enables fail-back.
```

## PARAMETERS

### -Id
Specifies the ID of the collector to modify.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the name of the collector to modify.
This parameter is mandatory when using the 'Name' parameter set.

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

### -Description
Specifies a new description for the collector.

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

### -BackupAgentId
Specifies the ID of the backup collector.

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

### -CollectorGroupId
Specifies the ID of the collector group to which this collector should belong.

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

### -Properties
Specifies a hashtable of custom properties to set for the collector.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableFailBack
Specifies whether to enable fail-back functionality.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableFailOverOnCollectorDevice
Specifies whether to enable fail-over on the collector device.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EscalatingChainId
Specifies the ID of the escalation chain.

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

### -SuppressAlertClear
Specifies whether to suppress alert clear notifications.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResendAlertInterval
Specifies the interval for resending alerts.

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

### -SpecifiedCollectorDeviceGroupId
Specifies the ID of the device group for the collector.

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

### You can pipe objects containing Id properties to this function.
## OUTPUTS

### Returns a LogicMonitor.Collector object containing the updated collector information.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
