---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMCollector

## SYNOPSIS
Creates a new LogicMonitor collector.

## SYNTAX

```
New-LMCollector [-Description] <String> [[-BackupAgentId] <Int32>] [[-CollectorGroupId] <Int32>]
 [[-Properties] <Hashtable>] [[-EnableFailBack] <Boolean>] [[-EnableFailOverOnCollectorDevice] <Boolean>]
 [[-EscalatingChainId] <Int32>] [[-AutoCreateCollectorDevice] <Boolean>] [[-SuppressAlertClear] <Boolean>]
 [[-ResendAlertInterval] <Int32>] [[-SpecifiedCollectorDeviceGroupId] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMCollector function creates a new collector in LogicMonitor with specified configuration settings.

## EXAMPLES

### EXAMPLE 1
```
#Create a new collector
New-LMCollector -Description "Production Collector" -CollectorGroupId 123 -Properties @{"location"="datacenter1"}
```

## PARAMETERS

### -Description
The description of the collector.
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

### -BackupAgentId
The ID of the backup collector.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectorGroupId
The ID of the collector group to assign the collector to.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
A hashtable of custom properties for the collector.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableFailBack
Whether to enable failback for the collector.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableFailOverOnCollectorDevice
Whether to enable failover on the collector device.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EscalatingChainId
The ID of the escalation chain to use.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoCreateCollectorDevice
Whether to automatically create a device for the collector.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SuppressAlertClear
Whether to suppress alert clear notifications.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResendAlertInterval
The interval for resending alerts.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SpecifiedCollectorDeviceGroupId
The ID of the device group for the collector device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
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

### Returns LogicMonitor.Collector object.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
