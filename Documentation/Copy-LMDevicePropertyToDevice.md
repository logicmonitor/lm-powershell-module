---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Copy-LMDevicePropertyToDevice

## SYNOPSIS
Copies device properties from a source device to target devices. Sensitive properties cannot be copied as their values are not available via API.

## SYNTAX

### SourceDevice (Default)
```
Copy-LMDevicePropertyToDevice -SourceDeviceId <String> -TargetDeviceId <String[]> -PropertyNames <String[]>
 [-PassThru] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### SourceGroup
```
Copy-LMDevicePropertyToDevice -SourceGroupId <String> -TargetDeviceId <String[]> -PropertyNames <String[]>
 [-PassThru] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Copy-LMDevicePropertyToDevice function copies specified properties from a source device to one or more target devices.
The source device can be randomly selected from a group or explicitly specified.
Properties are copied to the targets while preserving other existing device properties.

## EXAMPLES

### EXAMPLE 1
```
Copy-LMDevicePropertyToDevice -SourceDeviceId 123 -TargetDeviceId 456 -PropertyNames "location","department"
Copies the location and department properties from device 123 to device 456.
```

### EXAMPLE 2
```
Copy-LMDevicePropertyToDevice -SourceGroupId 789 -TargetDeviceId 456,457 -PropertyNames "location" -PassThru
Randomly selects a device from group 789 and copies its location property to devices 456 and 457, returning the updated devices.
```

## PARAMETERS

### -SourceDeviceId
The ID of the source device to copy properties from.
This parameter is part of the "SourceDevice" parameter set.

```yaml
Type: String
Parameter Sets: SourceDevice
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SourceGroupId
The ID of the source group to randomly select a device from.
This parameter is part of the "SourceGroup" parameter set.

```yaml
Type: String
Parameter Sets: SourceGroup
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetDeviceId
The ID of the target device(s) to copy properties to.
Multiple device IDs can be specified.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyNames
Array of property names to copy.
These can be only be custom properties directly assigned to the device.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
If specified, returns the updated device objects.

```yaml
Type: SwitchParameter
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

## OUTPUTS

## NOTES
Requires an active Logic Monitor session.
Use Connect-LMAccount to log in before running this function.

## RELATED LINKS
