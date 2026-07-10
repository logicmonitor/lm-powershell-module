---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Remove-LMUptimeDevice
---

# Remove-LMUptimeDevice

## SYNOPSIS

Removes a LogicMonitor Uptime device using the v3 device endpoint.

## SYNTAX

### Id (Default)

```
Remove-LMUptimeDevice -Id <int> [-HardDelete <bool>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name

```
Remove-LMUptimeDevice -Name <string> [-HardDelete <bool>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Remove-LMUptimeDevice cmdlet deletes an Uptime monitor (web or ping) from LogicMonitor via
the v3 device endpoint.
It accepts either the numerical identifier or resolves the identifier
from a device name, and submits a DELETE request with the required X-Version header.

## EXAMPLES

### EXAMPLE 1

Remove-LMUptimeDevice -Id 42

Removes the Uptime device with ID 42.

### EXAMPLE 2

Remove-LMUptimeDevice -Name "web-int-01"

Resolves the device ID by name and removes the corresponding Uptime device.

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

Indicates whether to permanently delete the device.
When $false (default), the device is moved
to the recycle bin.

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

Specifies the device identifier to remove.
Accepts pipeline input by property name.

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

Specifies the device name to remove.
The cmdlet resolves the device and then removes it.

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

### System.Int32. You can pipe an Id to this cmdlet.

### System.Int32

## OUTPUTS

### System.Management.Automation.PSCustomObject

## NOTES

You must run Connect-LMAccount before invoking this cmdlet.

## RELATED LINKS

- [Get-LMUptimeDevice]()
- [New-LMUptimeDevice]()
- [Set-LMUptimeDevice]()
