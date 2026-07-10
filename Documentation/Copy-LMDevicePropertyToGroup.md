---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Copy-LMDevicePropertyToGroup
---

# Copy-LMDevicePropertyToGroup

## SYNOPSIS

Copies device properties from a source device to target device groups. Sensitive properties cannot be copied as their values are not available via API.

## SYNTAX

### SourceDevice (Default)

```
Copy-LMDevicePropertyToGroup -SourceDeviceId <string> -TargetGroupId <string[]>
 -PropertyNames <string[]> [-PassThru] [<CommonParameters>]
```

### SourceGroup

```
Copy-LMDevicePropertyToGroup -SourceGroupId <string> -TargetGroupId <string[]>
 -PropertyNames <string[]> [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

The Copy-LMDevicePropertyToGroup function copies specified properties from a source device to one or more target device groups.
The source device can be randomly selected from a group or explicitly specified.
Properties are copied to the target groups while preserving other existing group properties.

## EXAMPLES

### EXAMPLE 1

Copy-LMDevicePropertyToGroup -SourceDeviceId 123 -TargetGroupId 456 -PropertyNames "location","department"
Copies the location and department properties from device 123 to group 456.

### EXAMPLE 2

Copy-LMDevicePropertyToGroup -SourceGroupId 789 -TargetGroupId 456,457 -PropertyNames "location" -PassThru
Randomly selects a device from group 789 and copies its location property to groups 456 and 457, returning the updated groups.

## PARAMETERS

### -PassThru

If specified, returns the updated device group objects.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PropertyNames

Array of property names to copy.
These can be only be custom properties directly assigned to the device.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SourceDeviceId

The ID of the source device to copy properties from.
This parameter is part of the "SourceDevice" parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SourceDevice
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SourceGroupId

The ID of the source group to randomly select a device from.
This parameter is part of the "SourceGroup" parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SourceGroup
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TargetGroupId

The ID of the target group(s) to copy properties to.
Multiple group IDs can be specified.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

Requires an active Logic Monitor session.
Use Connect-LMAccount to log in before running this function.

## RELATED LINKS

