---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMUnmonitoredDevice

## SYNOPSIS
Retrieves unmonitored devices from LogicMonitor.

## SYNTAX

```
Get-LMUnmonitoredDevice [[-Filter] <Object>] [[-BatchSize] <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMUnmonitoredDevice function retrieves information about devices that are discovered but not currently being monitored in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all unmonitored devices
Get-LMUnmonitoredDevice
```

### EXAMPLE 2
```
#Retrieve unmonitored devices using a filter
Get-LMUnmonitoredDevice -Filter $filterObject
```

## PARAMETERS

### -Filter
A filter object to apply when retrieving unmonitored devices.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Position: 2
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

### Returns LogicMonitor.UnmonitoredDevice objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
