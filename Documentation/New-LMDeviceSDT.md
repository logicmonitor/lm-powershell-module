---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceSDT

## SYNOPSIS
Creates a new Logic Monitor Device Scheduled Down Time (SDT).

## SYNTAX

### OneTime-DeviceName
```
New-LMDeviceSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime> -DeviceName <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### OneTime-DeviceId
```
New-LMDeviceSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime> -DeviceId <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Weekly-DeviceId
```
New-LMDeviceSDT -Comment <String> -DeviceId <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### MonthlyByWeek-DeviceId
```
New-LMDeviceSDT -Comment <String> -DeviceId <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Monthly-DeviceId
```
New-LMDeviceSDT -Comment <String> -DeviceId <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Daily-DeviceId
```
New-LMDeviceSDT -Comment <String> -DeviceId <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Weekly-DeviceName
```
New-LMDeviceSDT -Comment <String> -DeviceName <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### MonthlyByWeek-DeviceName
```
New-LMDeviceSDT -Comment <String> -DeviceName <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Monthly-DeviceName
```
New-LMDeviceSDT -Comment <String> -DeviceName <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Daily-DeviceName
```
New-LMDeviceSDT -Comment <String> -DeviceName <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-LMDeviceSDT function creates a new SDT for a Logic Monitor device.
It allows you to specify the comment, start date, end date, timezone, and device ID or device name.

## EXAMPLES

### EXAMPLE 1
```
New-LMDeviceSDT -Comment "Maintenance window" -StartDate "2022-01-01 00:00:00" -EndDate "2022-01-01 06:00:00" -DeviceId "12345"
Creates a one-time SDT for the device with ID "12345".
```

## PARAMETERS

### -Comment
Specifies the comment for the SDT.

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
Specifies the start date and time for the SDT.
This parameter is mandatory when using the 'OneTime-DeviceId' or 'OneTime-DeviceName' parameter sets.

```yaml
Type: DateTime
Parameter Sets: OneTime-DeviceName, OneTime-DeviceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
Specifies the end date and time for the SDT.
This parameter is mandatory when using the 'OneTime-DeviceId' or 'OneTime-DeviceName' parameter sets.

```yaml
Type: DateTime
Parameter Sets: OneTime-DeviceName, OneTime-DeviceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceId
Specifies the ID of the device.
This parameter is mandatory when using ID-based parameter sets.

```yaml
Type: String
Parameter Sets: OneTime-DeviceId, Weekly-DeviceId, MonthlyByWeek-DeviceId, Monthly-DeviceId, Daily-DeviceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceName
Specifies the name of the device.
This parameter is mandatory when using name-based parameter sets.

```yaml
Type: String
Parameter Sets: OneTime-DeviceName, Weekly-DeviceName, MonthlyByWeek-DeviceName, Monthly-DeviceName, Daily-DeviceName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartHour
Specifies the start hour for recurring SDTs.
This parameter is mandatory when using recurring parameter sets.
Must be between 0 and 23.

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Monthly-DeviceId, Daily-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName, Monthly-DeviceName, Daily-DeviceName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartMinute
Specifies the start minute for recurring SDTs.
This parameter is mandatory when using recurring parameter sets.
Must be between 0 and 59.

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Monthly-DeviceId, Daily-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName, Monthly-DeviceName, Daily-DeviceName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndHour
Specifies the end hour for recurring SDTs.
This parameter is mandatory when using recurring parameter sets.
Must be between 0 and 23.

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Monthly-DeviceId, Daily-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName, Monthly-DeviceName, Daily-DeviceName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndMinute
Specifies the end minute for recurring SDTs.
This parameter is mandatory when using recurring parameter sets.
Must be between 0 and 59.

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Monthly-DeviceId, Daily-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName, Monthly-DeviceName, Daily-DeviceName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekDay
Specifies the day of the week for weekly or monthly by week SDTs.

```yaml
Type: String
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekOfMonth
Specifies which week of the month for monthly by week SDTs.

```yaml
Type: String
Parameter Sets: MonthlyByWeek-DeviceId, MonthlyByWeek-DeviceName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DayOfMonth
Specifies the day of the month for monthly SDTs.

```yaml
Type: Int32
Parameter Sets: Monthly-DeviceId, Monthly-DeviceName
Aliases:

Required: True
Position: Named
Default value: 0
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
