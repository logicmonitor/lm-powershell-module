---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Export-LMDeviceConfigBackup

## SYNOPSIS
Exports the latest version of device configurations from LogicMonitor.

## SYNTAX

### Device (Default)
```
Export-LMDeviceConfigBackup -DeviceId <Int32> [-InstanceNameFilter <Regex>] [-ConfigSourceNameFilter <Regex>]
 [-Path <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DeviceGroup
```
Export-LMDeviceConfigBackup -DeviceGroupId <Int32> [-InstanceNameFilter <Regex>]
 [-ConfigSourceNameFilter <Regex>] [-Path <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Export-LMDeviceConfigBackup function exports the latest version of device configurations for specified devices.
It can export configs from either a single device or all devices in a device group.

## EXAMPLES

### EXAMPLE 1
```
#Export configurations from a device group
Export-LMDeviceConfigBackup -DeviceGroupId 2 -Path "export-report.csv"
```

### EXAMPLE 2
```
#Export configurations from a single device
Export-LMDeviceConfigBackup -DeviceId 1 -Path "export-report.csv"
```

## PARAMETERS

### -DeviceGroupId
The ID of the device group to export configurations from.
This parameter is mandatory when using the DeviceGroup parameter set.

```yaml
Type: Int32
Parameter Sets: DeviceGroup
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceId
The ID of the device to export configurations from.
This parameter is mandatory when using the Device parameter set.

```yaml
Type: Int32
Parameter Sets: Device
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceNameFilter
A regex filter to use for filtering Instance names.
Defaults to "running|current|PaloAlto".

```yaml
Type: Regex
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [rR]unning|[cC]urrent|[pP]aloAlto
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigSourceNameFilter
A regex filter to use for filtering ConfigSource names.
Defaults to ".*".

```yaml
Type: Regex
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: .*
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The file path where the CSV backup will be exported to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns an array of device configuration objects if successful.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
