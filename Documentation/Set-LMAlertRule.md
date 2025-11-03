---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMAlertRule

## SYNOPSIS
Updates a LogicMonitor alert rule configuration.

## SYNTAX

### Id (Default)
```
Set-LMAlertRule -Id <Int32> [-NewName <String>] [-Priority <Int32>] [-EscalatingChainId <Int32>]
 [-EscalationInterval <Int32>] [-ResourceProperties <Hashtable>] [-Devices <String[]>]
 [-DeviceGroups <String[]>] [-DataSource <String>] [-DataSourceInstanceName <String>] [-DataPoint <String>]
 [-SuppressAlertClear <Boolean>] [-SuppressAlertAckSdt <Boolean>] [-LevelStr <String>] [-Description <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Set-LMAlertRule [-Id <Int32>] -Name <String> [-NewName <String>] [-Priority <Int32>]
 [-EscalatingChainId <Int32>] [-EscalationInterval <Int32>] [-ResourceProperties <Hashtable>]
 [-Devices <String[]>] [-DeviceGroups <String[]>] [-DataSource <String>] [-DataSourceInstanceName <String>]
 [-DataPoint <String>] [-SuppressAlertClear <Boolean>] [-SuppressAlertAckSdt <Boolean>] [-LevelStr <String>]
 [-Description <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMAlertRule function modifies an existing alert rule in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
Set-LMAlertRule -Id 123 -Name "Updated Rule" -Priority 100 -EscalatingChainId 456
Updates the alert rule with new name, priority and escalation chain.
```

## PARAMETERS

### -Id
Specifies the ID of the alert rule to modify.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Int32
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name for the alert rule.

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
Specifies the new name for the alert rule.

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

### -Priority
Specifies the priority level for the alert rule.
Valid values: "High", "Medium", "Low".

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EscalatingChainId
Specifies the ID of the escalation chain to use.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EscalationInterval
Specifies the escalation interval in minutes.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceProperties
Specifies resource properties to filter on.

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

### -Devices
Specifies an array of device display names to apply the rule to.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroups
Specifies an array of device group full paths to apply the rule to.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataSource
Specifies the datasource name to apply the rule to.

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

### -DataSourceInstanceName
Specifies the instance name to apply the rule to.

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

### -DataPoint
Specifies the datapoint name to apply the rule to.

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

### -SuppressAlertClear
Indicates whether to suppress alert clear notifications.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SuppressAlertAckSdt
Indicates whether to suppress alert acknowledgement and SDT notifications.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LevelStr
Specifies the level string for the alert rule.
Valid values: "All", "Critical", "Error", "Warning".

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
Specifies the description for the alert rule.

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

### You can pipe alert rule objects containing Id properties to this function.
## OUTPUTS

### Returns the response from the API containing the updated alert rule information.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
