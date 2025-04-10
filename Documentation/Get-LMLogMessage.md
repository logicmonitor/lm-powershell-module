---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMLogMessage

## SYNOPSIS
Retrieves log messages from LogicMonitor.

## SYNTAX

### Range-Async (Default)
```
Get-LMLogMessage [-Query <String>] [-Range <String>] [-BatchSize <Int32>] [-MaxPages <Int32>] [-Async]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Date-Async
```
Get-LMLogMessage -StartDate <DateTime> -EndDate <DateTime> [-Query <String>] [-BatchSize <Int32>]
 [-MaxPages <Int32>] [-Async] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Date-Sync
```
Get-LMLogMessage -StartDate <DateTime> -EndDate <DateTime> [-Query <String>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Range-Sync
```
Get-LMLogMessage [-Query <String>] [-Range <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMLogMessage function retrieves log messages from LogicMonitor based on specified time ranges or date ranges.
It supports both synchronous and asynchronous queries with pagination control.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve logs for a specific date range
Get-LMLogMessage -StartDate (Get-Date).AddDays(-1) -EndDate (Get-Date)
```

### EXAMPLE 2
```
#Retrieve logs asynchronously with a custom query
Get-LMLogMessage -Range "1hour" -Query "error" -Async
```

## PARAMETERS

### -StartDate
The start date for retrieving log messages.
Required for Date parameter sets.

```yaml
Type: DateTime
Parameter Sets: Date-Async, Date-Sync
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
The end date for retrieving log messages.
Required for Date parameter sets.

```yaml
Type: DateTime
Parameter Sets: Date-Async, Date-Sync
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
A query string to filter the log messages.

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

### -Range
The time range for retrieving log messages.
Valid values are "15min", "30min", "1hour", "3hour", "6hour", "12hour", "24hour", "3day", "7day", "1month".
Defaults to "15min".

```yaml
Type: String
Parameter Sets: Range-Async, Range-Sync
Aliases:

Required: False
Position: Named
Default value: 15min
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
The number of results to return per request.
Must be between 1 and 300.
Defaults to 300.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 300
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxPages
The maximum number of pages to retrieve in async mode.
Defaults to 10.

```yaml
Type: Int32
Parameter Sets: Range-Async, Date-Async
Aliases:

Required: False
Position: Named
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -Async
Switch to enable asynchronous query mode.

```yaml
Type: SwitchParameter
Parameter Sets: Range-Async, Date-Async
Aliases:

Required: False
Position: Named
Default value: False
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

### Returns LogicMonitor.LMLogs objects.
## NOTES
You must run Connect-LMAccount before running this command.
This command is reserver for internal use only.

## RELATED LINKS
