---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMSDT

## SYNOPSIS
Updates a Scheduled Down Time (SDT) entry in LogicMonitor.

## SYNTAX

### OneTime (Default)
```
Set-LMSDT -Id <String> [-Comment <String>] [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Recurring
```
Set-LMSDT -Id <String> [-Comment <String>] [-StartHour <Int32>] [-StartMinute <Int32>] [-EndHour <Int32>]
 [-EndMinute <Int32>] [-WeekDay <String>] [-WeekOfMonth <String>] [-DayOfMonth <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMSDT function modifies an existing SDT entry in LogicMonitor, allowing updates to both one-time and recurring schedules.

## EXAMPLES

### EXAMPLE 1
```
Set-LMSDT -Id 123 -StartDate "2024-01-01 00:00" -EndDate "2024-01-02 00:00" -Comment "Extended maintenance"
Updates a one-time SDT entry with new dates and comment.
```

## PARAMETERS

### -Id
Specifies the ID of the SDT entry to modify.

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

### -Comment
Specifies a comment for the SDT entry.

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

### -StartDate
Specifies the start date and time for one-time SDT.

```yaml
Type: DateTime
Parameter Sets: OneTime
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
Specifies the end date and time for one-time SDT.

```yaml
Type: DateTime
Parameter Sets: OneTime
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartHour
Specifies the start hour (0-23) for recurring SDT.

```yaml
Type: Int32
Parameter Sets: Recurring
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartMinute
Specifies the start minute (0-59) for recurring SDT.

```yaml
Type: Int32
Parameter Sets: Recurring
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndHour
Specifies the end hour (0-23) for recurring SDT.

```yaml
Type: Int32
Parameter Sets: Recurring
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndMinute
Specifies the end minute (0-59) for recurring SDT.

```yaml
Type: Int32
Parameter Sets: Recurring
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekDay
Specifies the day of the week for recurring SDT.

```yaml
Type: String
Parameter Sets: Recurring
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekOfMonth
Specifies which week of the month for recurring SDT.
Valid values: "First", "Second", "Third", "Fourth", "Last".

```yaml
Type: String
Parameter Sets: Recurring
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DayOfMonth
Specifies the day of the month (1-31) for recurring SDT.

```yaml
Type: Int32
Parameter Sets: Recurring
Aliases:

Required: False
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

### None.
## OUTPUTS

### Returns the response from the API containing the updated SDT configuration.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
