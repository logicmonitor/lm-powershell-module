---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Copy-LMDevicePropertyToGroup

## SYNOPSIS
Copies device properties from a source device to target device groups. Sensitive properties cannot be copied as their values are not available via API.

## SYNTAX

### SourceDevice (Default)
```
Copy-LMDevicePropertyToGroup -SourceDeviceId <String> -TargetGroupId <String[]> -PropertyNames <String[]>
 [-PassThru] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### SourceGroup
```
Copy-LMDevicePropertyToGroup -SourceGroupId <String> -TargetGroupId <String[]> -PropertyNames <String[]>
 [-PassThru] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Copy-LMDevicePropertyToGroup function copies specified properties from a source device to one or more target device groups.
The source device can be randomly selected from a group or explicitly specified.
Properties are copied to the target groups while preserving other existing group properties.

## EXAMPLES

### EXAMPLE 1
```
Copy-LMDevicePropertyToGroup -SourceDeviceId 123 -TargetGroupId 456 -PropertyNames "location","department"
Copies the location and department properties from device 123 to group 456.
```

### EXAMPLE 2
```
Copy-LMDevicePropertyToGroup -SourceGroupId 789 -TargetGroupId 456,457 -PropertyNames "location" -PassThru
Randomly selects a device from group 789 and copies its location property to groups 456 and 457, returning the updated groups.
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

### -TargetGroupId
The ID of the target group(s) to copy properties to.
Multiple group IDs can be specified.

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
If specified, returns the updated device group objects.

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
