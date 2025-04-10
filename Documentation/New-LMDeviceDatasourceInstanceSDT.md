---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceDatasourceInstanceSDT

## SYNOPSIS
Creates a new SDT entry for a Logic Monitor device datasource instance.

## SYNTAX

### OneTime
```
New-LMDeviceDatasourceInstanceSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime>
 -DeviceDataSourceInstanceId <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Weekly
```
New-LMDeviceDatasourceInstanceSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -DeviceDataSourceInstanceId <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### MonthlyByWeek
```
New-LMDeviceDatasourceInstanceSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> -DeviceDataSourceInstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Monthly
```
New-LMDeviceDatasourceInstanceSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> -DeviceDataSourceInstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Daily
```
New-LMDeviceDatasourceInstanceSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DeviceDataSourceInstanceId <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMDeviceDatasourceInstanceSDT function creates a new SDT entry for an instance of a Logic Monitor device datasource.
It allows you to specify various parameters such as comment, start date, end date, timezone, start hour, and start minute.

## EXAMPLES

### EXAMPLE 1
```
New-LMDeviceDatasourceInstanceSDT -Comment "Test SDT Instance" -StartDate (Get-Date) -EndDate (Get-Date).AddDays(7) -StartHour 8 -StartMinute 30 -DeviceDataSourceInstanceId 1234
Creates a new one-time instance SDT with a comment, start date, end date, start hour, and start minute.
```

## PARAMETERS

### -Comment
Specifies the comment for the new instance SDT.

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
Specifies the start date for the new instance SDT.
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
Specifies the end date for the new instance SDT.
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
Specifies the start hour for the new instance SDT.
This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets.
The value must be between 0 and 23.

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
Specifies the start minute for the new instance SDT.
This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets.
The value must be between 0 and 59.

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
Specifies the end hour for the new instance SDT.
This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets.
The value must be between 0 and 23.

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
Specifies the end minute for the new instance SDT.
This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets.
The value must be between 0 and 59.

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
Specifies the day of the week for the new instance SDT.
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
Specifies the week of the month for the new instance SDT.
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
Specifies the day of the month for the new instance SDT.
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

### -DeviceDataSourceInstanceId
Specifies the ID of the device datasource instance for which to create the SDT.

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
