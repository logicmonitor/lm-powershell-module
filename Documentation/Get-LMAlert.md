---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAlert

## SYNOPSIS
Retrieves alerts from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMAlert [-Severity <String>] [-Type <String>] [-ClearedAlerts <Boolean>] [-BatchSize <Int32>]
 [-Sort <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Range
```
Get-LMAlert [-StartDate <DateTime>] [-EndDate <DateTime>] [-Severity <String>] [-Type <String>]
 [-ClearedAlerts <Boolean>] [-BatchSize <Int32>] [-Sort <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Id
```
Get-LMAlert -Id <String> [-Severity <String>] [-Type <String>] [-ClearedAlerts <Boolean>]
 [-CustomColumns <String[]>] [-BatchSize <Int32>] [-Sort <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMAlert [-Severity <String>] [-Type <String>] [-ClearedAlerts <Boolean>] [-Filter <Object>]
 [-BatchSize <Int32>] [-Sort <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### FilterWizard
```
Get-LMAlert [-Severity <String>] [-Type <String>] [-ClearedAlerts <Boolean>] [-FilterWizard]
 [-BatchSize <Int32>] [-Sort <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMAlert function retrieves alerts from LogicMonitor based on specified criteria.
It supports filtering by date range, severity, type, and cleared status.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve alerts from the last 7 days
Get-LMAlert -StartDate (Get-Date).AddDays(-7) -Severity "Error"
```

### EXAMPLE 2
```
#Retrieve a specific alert with custom columns
Get-LMAlert -Id 12345 -CustomColumns "Column1","Column2"
```

## PARAMETERS

### -StartDate
The start date for retrieving alerts.
Defaults to 0 (beginning of time).

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
The end date for retrieving alerts.
Defaults to current time.

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

### -Id
The specific alert ID to retrieve.
This parameter is part of a mutually exclusive parameter set.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Severity
The severity level to filter alerts by.
Valid values are "*", "Warning", "Error", "Critical".
Defaults to "*".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of alerts to retrieve.
Valid values are "*", "websiteAlert", "dataSourceAlert", "eventAlert", "logAlert".
Defaults to "*".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClearedAlerts
Whether to include cleared alerts.
Defaults to $false.

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

### -Filter
A filter object to apply when retrieving alerts.
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

### -FilterWizard
Switch to use the filter wizard interface.
Part of a mutually exclusive parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: FilterWizard
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomColumns
Array of custom column names to include in the results.

```yaml
Type: String[]
Parameter Sets: Id
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

### -Sort
The field to sort results by.
Defaults to "+resourceId".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: +resourceId
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

### Returns LogicMonitor.Alert objects.
## NOTES
You must run Connect-LMAccount before running this command.
Maximum of 10000 alerts can be retrieved in a single query.

## RELATED LINKS
