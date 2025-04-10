---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMUnmonitoredDevice

## SYNOPSIS
Updates unmonitored devices in LogicMonitor.

## SYNTAX

```
Set-LMUnmonitoredDevice [-Ids] <String[]> [-DeviceGroupId] <Int32> [[-Description] <String>]
 [[-CollectorId] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMUnmonitoredDevice function modifies unmonitored devices in LogicMonitor by assigning them to a device group.

## EXAMPLES

### EXAMPLE 1
```
#Assigns the specified unmonitored devices to the device group and sets their description.
Set-LMUnmonitoredDevice -Ids @("123", "456") -DeviceGroupId 789 -Description "New devices"
```

## PARAMETERS

### -Ids
Specifies an array of unmonitored device IDs to update.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroupId
Specifies the ID of the device group to assign the devices to.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Specifies a description for the devices.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectorId
Specifies the ID of the collector to assign to the devices.
Default is 0.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
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

### Returns a LogicMonitor.Device object containing the updated device information.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
