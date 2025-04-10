---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMPushModuleDeviceProperty

## SYNOPSIS
Updates a device property using the LogicMonitor Push Module.

## SYNTAX

### Id (Default)
```
Set-LMPushModuleDeviceProperty -Id <Int32> -PropertyName <String> -PropertyValue <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Set-LMPushModuleDeviceProperty -Name <String> -PropertyName <String> -PropertyValue <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMPushModuleDeviceProperty function modifies a property value for a device using the LogicMonitor Push Module API.

## EXAMPLES

### EXAMPLE 1
```
Set-LMPushModuleDeviceProperty -Id 123 -PropertyName "location" -PropertyValue "New York"
Updates the location property for device ID 123.
```

## PARAMETERS

### -Id
Specifies the ID of the device.

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
Specifies the name of the device.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyName
Specifies the name of the property to update.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyValue
Specifies the new value for the property.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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

### None.
## OUTPUTS

### Returns the response from the API indicating the success of the property update.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
