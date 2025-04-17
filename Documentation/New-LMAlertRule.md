---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAlertRule

## SYNOPSIS
Creates a new LogicMonitor alert rule.

## SYNTAX

```
New-LMAlertRule [-Name] <String> [-Priority] <Int32> [-EscalatingChainId] <Int32>
 [[-EscalationInterval] <Int32>] [[-ResourceProperties] <Hashtable>] [[-Devices] <String[]>]
 [[-DeviceGroups] <String[]>] [[-DataSource] <String>] [[-DataSourceInstanceName] <String>]
 [[-DataPoint] <String>] [[-SuppressAlertClear] <Boolean>] [[-SuppressAlertAckSdt] <Boolean>]
 [[-LevelStr] <String>] [[-Description] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMAlertRule function creates a new alert rule in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
New-LMAlertRule -Name "New Rule" -Priority 100 -EscalatingChainId 456
Creates a new alert rule with specified name, priority and escalation chain.
```

## PARAMETERS

### -Name
Specifies the name for the alert rule.

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

### -Priority
Specifies the priority level for the alert rule.
Valid values: "High", "Medium", "Low".

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

Required: True
Position: 3
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
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
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
Position: 8
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
Position: 9
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
Position: 10
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
Position: 11
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
Position: 12
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
Position: 13
Default value: All
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
Position: 14
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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns the response from the API containing the new alert rule information.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
