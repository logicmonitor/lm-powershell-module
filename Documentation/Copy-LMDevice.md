---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Copy-LMDevice

## SYNOPSIS
Creates a copy of a LogicMonitor device.

## SYNTAX

```
Copy-LMDevice [-Name] <String> [[-DisplayName] <String>] [[-Description] <String>] [-DeviceObject] <Object>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Copy-LMDevice function creates a new device based on an existing device's configuration.
It allows you to specify a new name, display name, and description while maintaining other settings from the source device.

## EXAMPLES

### EXAMPLE 1
```
#Copy a device with basic settings
Copy-LMDevice -Name "NewDevice" -DeviceObject $deviceObject
```

### EXAMPLE 2
```
#Copy a device with custom display name and description
Copy-LMDevice -Name "NewDevice" -DisplayName "New Display Name" -Description "New device description" -DeviceObject $deviceObject
```

## PARAMETERS

### -Name
The name for the new device.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisplayName
The display name for the new device.
If not specified, defaults to the Name parameter value.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Name
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
An optional description for the new device.

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

### -DeviceObject
The source device object to copy settings from.
This parameter is mandatory.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
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

### Returns the newly created device object.
## NOTES
Masked custom properties from the source device will need to be manually updated on the new device as they are not available via the API.

## RELATED LINKS
