---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMIntegrationLog

## SYNOPSIS
Retrieves integration audit logs from LogicMonitor.

## SYNTAX

### Range (Default)
```
Get-LMIntegrationLog [-SearchString <String>] [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMIntegrationLog [-Id <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMIntegrationLog [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMIntegrationLogs function retrieves integration audit logs from LogicMonitor.
It supports retrieving logs by ID, date range, search string, or filter criteria.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve logs for the last 30 days
Get-LMIntegrationLog
```

### EXAMPLE 2
```
#Retrieve logs with a specific search string and date range
Get-LMIntegrationLog -SearchString "error" -StartDate (Get-Date).AddDays(-7)
```

## PARAMETERS

### -Id
The specific integration log ID to retrieve.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchString
A string to search for within the integration logs.

```yaml
Type: String
Parameter Sets: Range
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
The start date for retrieving logs.
Defaults to 30 days ago if not specified.

```yaml
Type: DateTime
Parameter Sets: Range
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
The end date for retrieving logs.
Defaults to current time if not specified.

```yaml
Type: DateTime
Parameter Sets: Range
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A filter object to apply when retrieving logs.

```yaml
Type: Object
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
The number of results to return per request.
Must be between 1 and 1000.
Defaults to 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
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

### Returns LogicMonitor.IntegrationLog objects.
## NOTES
You must run Connect-LMAccount before running this command.
There is a 10,000 record query limitation for this endpoint.

## RELATED LINKS
