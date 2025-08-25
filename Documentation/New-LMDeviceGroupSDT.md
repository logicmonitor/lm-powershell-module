---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceGroupSDT

## SYNOPSIS
Creates a new LogicMonitor Device Group Scheduled Downtime.

## SYNTAX

### OneTime-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime> -DeviceGroupName <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### OneTime-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime> -DeviceGroupId <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Weekly-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -DeviceGroupId <String> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### MonthlyByWeek-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> -DeviceGroupId <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Monthly-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> -DeviceGroupId <String> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Daily-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DeviceGroupId <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Weekly-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -DeviceGroupName <String> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### MonthlyByWeek-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> -DeviceGroupName <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Monthly-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> -DeviceGroupName <String> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Daily-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DeviceGroupName <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMDeviceGroupSDT function creates a new scheduled downtime for a LogicMonitor device group.
This allows you to temporarily disable monitoring for a specific group of devices within your LogicMonitor account.

## EXAMPLES

### EXAMPLE 1
```
New-LMDeviceGroupSDT -Comment "Maintenance window" -StartDate "2022-01-01 00:00:00" -EndDate "2022-01-01 06:00:00" -StartHour 2 -DeviceGroupName "Production Servers"
Creates a new scheduled downtime for the "Production Servers" device group.
```

## PARAMETERS

### -Comment
Specifies the comment for the scheduled downtime.
This comment will be displayed in the LogicMonitor UI.

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

### -StartDate
Specifies the start date and time for the scheduled downtime.
This parameter is mandatory when using the 'OneTime-DeviceGroupId' or 'OneTime-DeviceGroupName' parameter sets.

```yaml
Type: DateTime
Parameter Sets: OneTime-DeviceGroupName, OneTime-DeviceGroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
Specifies the end date and time for the scheduled downtime.
This parameter is mandatory when using the 'OneTime-DeviceGroupId' or 'OneTime-DeviceGroupName' parameter sets.

```yaml
Type: DateTime
Parameter Sets: OneTime-DeviceGroupName, OneTime-DeviceGroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartHour
Specifies the start hour for the scheduled downtime.
This parameter is mandatory when using recurring parameter sets.
The value must be between 0 and 23.

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartMinute
Specifies the start minute for the scheduled downtime.
This parameter is mandatory when using recurring parameter sets.
The value must be between 0 and 59.

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndHour
Specifies the end hour for the scheduled downtime.
This parameter is mandatory when using recurring parameter sets.
The value must be between 0 and 23.

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndMinute
Specifies the end minute for the scheduled downtime.
This parameter is mandatory when using recurring parameter sets.
The value must be between 0 and 59.

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekDay
Specifies the day of the week for weekly or monthly by week SDTs.
This parameter is mandatory when using the 'Weekly' or 'MonthlyByWeek' parameter sets.

```yaml
Type: String
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekOfMonth
Specifies which week of the month for monthly by week SDTs.
This parameter is mandatory when using the 'MonthlyByWeek' parameter set.

```yaml
Type: String
Parameter Sets: MonthlyByWeek-DeviceGroupId, MonthlyByWeek-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DayOfMonth
Specifies the day of the month for monthly SDTs.
This parameter is mandatory when using the 'Monthly' parameter set.

```yaml
Type: Int32
Parameter Sets: Monthly-DeviceGroupId, Monthly-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroupId
Specifies the ID of the device group.
This parameter is mandatory when using ID-based parameter sets.

```yaml
Type: String
Parameter Sets: OneTime-DeviceGroupId, Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroupName
Specifies the name of the device group.
This parameter is mandatory when using name-based parameter sets.

```yaml
Type: String
Parameter Sets: OneTime-DeviceGroupName, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

### Returns LogicMonitor.SDT object.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
