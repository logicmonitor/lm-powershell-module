---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Remove-LMDeviceGroupProperty
---

# Remove-LMDeviceGroupProperty

## SYNOPSIS

Removes a property from a LogicMonitor device group.

## SYNTAX

### Id (Default)

```
Remove-LMDeviceGroupProperty -Id <int> -PropertyName <string> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name

```
Remove-LMDeviceGroupProperty -Name <string> -PropertyName <string> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The Remove-LMDeviceGroupProperty function removes a specified property from a LogicMonitor device group.
It can remove the property either by providing the device group ID or the device group name.

## EXAMPLES

### EXAMPLE 1

Remove-LMDeviceGroupProperty -Id 1234 -PropertyName "Property1"
Removes the property named "Property1" from the device with ID 1234.

### EXAMPLE 2

Remove-LMDeviceGroupProperty -Name "Device1" -PropertyName "Property2"
Removes the property named "Property2" from the device with the name "Device1".

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -Id

The ID of the device group from which the property should be removed.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the device group from which the property should be removed.
This parameter is mandatory when using the 'Name' parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PropertyName

The name of the property to be removed.
This parameter is mandatory.

```yaml
Type: System.String
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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### You can pipe device group objects to this command.

### System.Int32

## OUTPUTS

### Returns a PSCustomObject containing the ID of the device group and a message confirming the successful removal of the property.

## NOTES

This function requires a valid LogicMonitor API authentication.
Make sure you are logged in before running any commands.

## RELATED LINKS

