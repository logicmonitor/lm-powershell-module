---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMUptimeDevice

## SYNOPSIS
Removes a LogicMonitor Uptime device using the v3 device endpoint.

## SYNTAX

### Id (Default)
```
Remove-LMUptimeDevice -Id <Int32> [-HardDelete <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Name
```
Remove-LMUptimeDevice -Name <String> [-HardDelete <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMUptimeDevice cmdlet deletes an Uptime monitor (web or ping) from LogicMonitor via
the v3 device endpoint.
It accepts either the numerical identifier or resolves the identifier
from a device name, and submits a DELETE request with the required X-Version header.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMUptimeDevice -Id 42
```

Removes the Uptime device with ID 42.

### EXAMPLE 2
```
Remove-LMUptimeDevice -Name "web-int-01"
```

Resolves the device ID by name and removes the corresponding Uptime device.

## PARAMETERS

### -Id
Specifies the device identifier to remove.
Accepts pipeline input by property name.

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
Specifies the device name to remove.
The cmdlet resolves the device and then removes it.

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

### -HardDelete
Indicates whether to permanently delete the device.
When $false (default), the device is moved
to the recycle bin.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
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

## OUTPUTS

### System.Management.Automation.PSCustomObject
## NOTES
You must run Connect-LMAccount before invoking this cmdlet.
Requests target
/device/devices/{id}?deleteHard={bool} with X-Version 3.

## RELATED LINKS
