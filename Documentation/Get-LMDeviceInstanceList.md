---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceInstanceList

## SYNOPSIS
Retrieves a list of instances for a LogicMonitor device.

## SYNTAX

### Id (Default)
```
Get-LMDeviceInstanceList -Id <Int32> [-Filter <Object>] [-BatchSize <Int32>] [-CountOnly <Boolean>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMDeviceInstanceList [-Name <String>] [-Filter <Object>] [-BatchSize <Int32>] [-CountOnly <Boolean>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceInstanceList function retrieves all instances associated with a specific device in LogicMonitor.
The device can be identified by either ID or name, and the results can be filtered.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve instances by device ID
Get-LMDeviceInstanceList -Id 123
```

### EXAMPLE 2
```
#Get instance count for a device
Get-LMDeviceInstanceList -Name "Production-Server" -CountOnly $true
```

## PARAMETERS

### -Id
The ID of the device to retrieve instances from.
Required for Id parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the device to retrieve instances from.
Required for Name parameter set.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A filter object to apply when retrieving instances.
This parameter is optional.

```yaml
Type: Object
Parameter Sets: (All)
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

### -CountOnly
When set to true, returns only the total count of instances instead of the instance details.

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

### Returns device instance objects or a count if CountOnly is specified.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
