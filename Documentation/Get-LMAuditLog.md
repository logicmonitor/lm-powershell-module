---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAuditLog

## SYNOPSIS
Retrieves audit logs from LogicMonitor.

## SYNTAX

### Range (Default)
```
Get-LMAuditLog [-SearchString <String>] [-StartDate <DateTime>] [-EndDate <DateTime>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMAuditLog [-Id <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Filter
```
Get-LMAuditLog [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMAuditLog function retrieves audit logs from LogicMonitor based on the specified parameters.
It supports retrieving logs by ID, by date range, or by applying filters.
The function can retrieve up to 10000 logs in a single query.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve audit logs from the last week
Get-LMAuditLog -StartDate (Get-Date).AddDays(-7)
```

### EXAMPLE 2
```
#Search for specific audit logs
Get-LMAuditLog -SearchString "login" -StartDate (Get-Date).AddDays(-30)
```

## PARAMETERS

### -Id
The ID of the specific audit log to retrieve.
This parameter is part of a mutually exclusive parameter set.

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
A string to filter audit logs by.
Only logs containing this string will be returned.

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
The start date for retrieving audit logs.
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
The end date for retrieving audit logs.
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
A filter object to apply when retrieving audit logs.
Part of a mutually exclusive parameter set.

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

### Returns LogicMonitor.AuditLog objects.
## NOTES
You must run Connect-LMAccount before running this command.
Maximum of 10000 logs can be retrieved in a single query.

## RELATED LINKS
