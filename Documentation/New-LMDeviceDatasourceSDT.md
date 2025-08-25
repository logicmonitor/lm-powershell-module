---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceDatasourceSDT

## SYNOPSIS
Creates a new device datasource SDT (Scheduled Downtime) in Logic Monitor.

## SYNTAX

### OneTime
```
New-LMDeviceDatasourceSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime>
 -DeviceDataSourceId <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Weekly
```
New-LMDeviceDatasourceSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -DeviceDataSourceId <String> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### MonthlyByWeek
```
New-LMDeviceDatasourceSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> -DeviceDataSourceId <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Monthly
```
New-LMDeviceDatasourceSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> -DeviceDataSourceId <String> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Daily
```
New-LMDeviceDatasourceSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DeviceDataSourceId <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMDeviceDatasourceSDT function creates a new device datasource SDT (Scheduled Downtime) in Logic Monitor.
It allows you to specify the comment, start date and time, end date and time, and the timezone for the SDT.

## EXAMPLES

### EXAMPLE 1
```
New-LMDeviceDatasourceSDT -Comment "Maintenance window" -StartDate "2022-01-01 00:00" -EndDate "2022-01-01 06:00" -StartHour 2 -StartMinute 30 -DeviceDataSourceId 123
Creates a new one-time device datasource SDT with a comment "Maintenance window" starting on January 1, 2022, at 00:00 and ending on the same day at 06:00.
```

### EXAMPLE 2
```
New-LMDeviceDatasourceSDT -Comment "Daily maintenance" -StartHour 3 -StartMinute 0 -ParameterSet Daily -DeviceDataSourceId 123
Creates a new daily device datasource SDT with a comment "Daily maintenance" starting at 03:00.
```

### EXAMPLE 3
```
New-LMDeviceDatasourceSDT -Comment "Monthly maintenance" -StartHour 8 -StartMinute 30 -ParameterSet Monthly -DeviceDataSourceId 123
Creates a new monthly device datasource SDT with a comment "Monthly maintenance" starting on the 1st day of each month at 08:30.
```

### EXAMPLE 4
```
New-LMDeviceDatasourceSDT -Comment "Weekly maintenance" -StartHour 10 -StartMinute 0 -ParameterSet Weekly -DeviceDataSourceId 123
Creates a new weekly device datasource SDT with a comment "Weekly maintenance" starting every Monday at 10:00.
```

## PARAMETERS

### -Comment
The comment for the SDT.
This parameter is mandatory.

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
The start date for the SDT.
This parameter is mandatory when using the 'OneTime' parameter set.

```yaml
Type: DateTime
Parameter Sets: OneTime
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
The end date for the SDT.
This parameter is mandatory when using the 'OneTime' parameter set.

```yaml
Type: DateTime
Parameter Sets: OneTime
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartHour
The start hour for the SDT.
This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets.
Must be a value between 0 and 23.

```yaml
Type: Int32
Parameter Sets: Weekly, MonthlyByWeek, Monthly, Daily
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartMinute
The start minute for the SDT.
This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets.
Must be a value between 0 and 59.

```yaml
Type: Int32
Parameter Sets: Weekly, MonthlyByWeek, Monthly, Daily
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndHour
The end hour for the SDT.
This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets.
Must be a value between 0 and 23.

```yaml
Type: Int32
Parameter Sets: Weekly, MonthlyByWeek, Monthly, Daily
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndMinute
The end minute for the SDT.
This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets.
Must be a value between 0 and 59.

```yaml
Type: Int32
Parameter Sets: Weekly, MonthlyByWeek, Monthly, Daily
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekDay
The day of the week for the SDT.
This parameter is mandatory when using the 'Weekly' or 'MonthlyByWeek' parameter sets.

```yaml
Type: String
Parameter Sets: Weekly, MonthlyByWeek
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekOfMonth
The week of the month for the SDT.
This parameter is mandatory when using the 'MonthlyByWeek' parameter set.

```yaml
Type: String
Parameter Sets: MonthlyByWeek
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DayOfMonth
The day of the month for the SDT.
This parameter is mandatory when using the 'Monthly' parameter set.

```yaml
Type: Int32
Parameter Sets: Monthly
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceDataSourceId
The ID of the device datasource for which to create the SDT.

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
