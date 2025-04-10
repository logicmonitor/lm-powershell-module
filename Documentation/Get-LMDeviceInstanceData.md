---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceInstanceData

## SYNOPSIS
Retrieves data for LogicMonitor device instances.

## SYNTAX

```
Get-LMDeviceInstanceData [[-StartDate] <DateTime>] [[-EndDate] <DateTime>] [-Ids] <String[]>
 [[-AggregationType] <String>] [[-Period] <Double>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceInstanceData function retrieves monitoring data for specified device instances in LogicMonitor.
It supports data aggregation and time range filtering, with a maximum timeframe of 24 hours.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve data for multiple instances with aggregation
Get-LMDeviceInstanceData -Ids "12345","67890" -AggregationType "average" -StartDate (Get-Date).AddHours(-12)
```

### EXAMPLE 2
```
#Retrieve raw data for a single instance
Get-LMDeviceInstanceData -Id "12345" -AggregationType "none"
```

## PARAMETERS

### -StartDate
The start date for the data retrieval.
Defaults to 24 hours ago if not specified.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
The end date for the data retrieval.
Defaults to current time if not specified.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Ids
An array of device instance IDs for which to retrieve data.
This parameter is mandatory and can be specified using the Id alias.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AggregationType
The type of aggregation to apply to the data.
Valid values are "first", "last", "min", "max", "sum", "average", "none".
Defaults to "none".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Period
The period for data aggregation.
Defaults to 1 as this appears to be the only supported value.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 1
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

### Returns an array of data points for the specified device instances.
## NOTES
You must run Connect-LMAccount before running this command.
Maximum time range for data retrieval is 24 hours.

## RELATED LINKS
