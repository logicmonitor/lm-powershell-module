---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMDeviceGroupProperty

## SYNOPSIS
Updates a property value for a LogicMonitor device group.

## SYNTAX

### Id (Default)
```
Set-LMDeviceGroupProperty -Id <Int32> -PropertyName <String> -PropertyValue <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Set-LMDeviceGroupProperty -Name <String> -PropertyName <String> -PropertyValue <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMDeviceGroupProperty function modifies the value of a specific property for a device group in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
Set-LMDeviceGroupProperty -Id 123 -PropertyName "Location" -PropertyValue "New York"
Updates the "Location" property to "New York" for the device group with ID 123.
```

## PARAMETERS

### -Id
Specifies the ID of the device group.
This parameter is mandatory when using the 'Id' parameter set.

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
Specifies the name of the device group.
This parameter is mandatory when using the 'Name' parameter set.

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

### You can pipe device group objects containing Id properties to this function.
## OUTPUTS

### Returns the response from the API indicating the success of the property update.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
