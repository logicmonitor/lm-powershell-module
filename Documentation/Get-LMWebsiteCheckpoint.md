---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMWebsiteCheckpoint

## SYNOPSIS
Retrieves website checkpoints from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMWebsiteCheckpoint [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Filter
```
Get-LMWebsiteCheckpoint [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMWebsiteCheckpoint function retrieves checkpoint configurations used for website monitoring in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all website checkpoints
Get-LMWebsiteCheckpoint
```

### EXAMPLE 2
```
#Retrieve checkpoints using a filter
Get-LMWebsiteCheckpoint -Filter $filterObject
```

## PARAMETERS

### -Filter
A filter object to apply when retrieving checkpoints.

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

### Returns website checkpoint objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
