---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceAlerts

## SYNOPSIS
Retrieves alerts for a specific LogicMonitor device.

## SYNTAX

### Id (Default)
```
Get-LMDeviceAlerts -Id <Int32> [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name
```
Get-LMDeviceAlerts [-Name <String>] [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceAlerts function retrieves all alerts associated with a specific device in LogicMonitor.
The device can be identified by either ID or name, and the results can be filtered using custom criteria.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve alerts for a device by ID
Get-LMDeviceAlerts -Id 123
```

### EXAMPLE 2
```
#Retrieve alerts for a device by name with filtering
Get-LMDeviceAlerts -Name "Production-Server" -Filter $filterObject
```

## PARAMETERS

### -Id
The ID of the device to retrieve alerts for.
This parameter is mandatory when using the Id parameter set and can accept pipeline input.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The name of the device to retrieve alerts for.
Part of a mutually exclusive parameter set.

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
A filter object to apply when retrieving alerts.
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

### System.Int32. The device ID can be piped to this function.
## OUTPUTS

### Returns LogicMonitor.Alert objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
