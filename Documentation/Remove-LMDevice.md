---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Remove-LMDevice
---

# Remove-LMDevice

## SYNOPSIS

Removes a LogicMonitor device.

## SYNTAX

### Id (Default)

```
Remove-LMDevice -Id <int> [-HardDelete <bool>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name

```
Remove-LMDevice -Name <string> [-HardDelete <bool>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Remove-LMDevice function removes a LogicMonitor device based on either its ID or name.
It supports both hard delete and soft delete options.

## EXAMPLES

### EXAMPLE 1

Remove-LMDevice -Id 12345
Removes the LogicMonitor device with ID 12345.

### EXAMPLE 2

Remove-LMDevice -Name "MyDevice"
Removes the LogicMonitor device with the name "MyDevice".

### EXAMPLE 3

Remove-LMDevice -Name "MyDevice" -HardDelete $true
Permanently deletes the LogicMonitor device with the name "MyDevice".

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

### -HardDelete

Indicates whether the device should be hard deleted.
If set to $true, the device will be permanently deleted.
If set to $false (default), the device will be moved to the Recycle Bin.

```yaml
Type: System.Boolean
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

### -Id

Specifies the ID of the device to be removed.
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

Specifies the name of the device to be removed.
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

### You can pipe input to this function.

### System.Int32

## OUTPUTS

### Returns a PSCustomObject containing the ID of the removed device and a message indicating the success of the removal operation.

## NOTES

## RELATED LINKS

