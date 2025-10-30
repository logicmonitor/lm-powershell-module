---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMRecentlyDeleted

## SYNOPSIS
Retrieves recently deleted resources from the LogicMonitor recycle bin.

## SYNTAX

```
Get-LMRecentlyDeleted [[-ResourceType] <String>] [[-DeletedAfter] <DateTime>] [[-DeletedBefore] <DateTime>]
 [[-DeletedBy] <String>] [[-BatchSize] <Int32>] [[-Sort] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMRecentlyDeleted function queries the LogicMonitor recycle bin for deleted resources
within a configurable time range.
Results can be filtered by resource type and deleted-by user,
and support paging through the API using size, offset, and sort parameters.

## EXAMPLES

### EXAMPLE 1
```
Get-LMRecentlyDeleted -ResourceType device -DeletedBy "lmsupport"
```

Retrieves every device deleted by the user lmsupport over the past seven days.

### EXAMPLE 2
```
Get-LMRecentlyDeleted -DeletedAfter (Get-Date).AddDays(-1) -DeletedBefore (Get-Date) -BatchSize 100 -Sort "+deletedOn"
```

Retrieves deleted resources from the past 24 hours in ascending order of deletion time.

## PARAMETERS

### -ResourceType
Limits results to a specific resource type.
Accepted values are All, device, and deviceGroup.
Defaults to All.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeletedAfter
The earliest deletion timestamp (inclusive) to return.
Defaults to seven days prior when not specified.

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

### -DeletedBefore
The latest deletion timestamp (exclusive) to return.
Defaults to the current time when not specified.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeletedBy
Limits results to items deleted by the specified user principal.

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

### -BatchSize
The number of records to request per API call (1-1000).
Defaults to 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sort
Sort expression passed to the API.
Defaults to -deletedOn.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: -deletedOn
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

## OUTPUTS

## NOTES
You must establish a session with Connect-LMAccount prior to calling this function.

## RELATED LINKS
