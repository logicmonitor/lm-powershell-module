---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceConfigSourceData

## SYNOPSIS
Retrieves configuration source data for a LogicMonitor device.

## SYNTAX

### ListDiffs (Default)
```
Get-LMDeviceConfigSourceData -Id <Int32> -HdsId <String> -HdsInsId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ConfigId
```
Get-LMDeviceConfigSourceData -Id <Int32> -HdsId <String> -HdsInsId <String> [-ConfigId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ListConfigs
```
Get-LMDeviceConfigSourceData -Id <Int32> -HdsId <String> -HdsInsId <String> [-LatestConfigOnly]
 [-ConfigType <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceConfigSourceData function retrieves configuration data from a specific device's configuration source in LogicMonitor.
It supports retrieving full configurations or delta changes, and can return either all configs or just the latest one.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve latest configuration for a device
Get-LMDeviceConfigSourceData -Id 123 -HdsId 456 -HdsInsId 789 -LatestConfigOnly
```

### EXAMPLE 2
```
#Retrieve full configuration history
Get-LMDeviceConfigSourceData -Id 123 -HdsId 456 -HdsInsId 789 -ConfigType Full
```

## PARAMETERS

### -Id
The ID of the device to retrieve configuration data for.
This parameter is mandatory.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -HdsId
The ID of the host datasource.
This parameter is mandatory.

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

### -HdsInsId
The ID of the host datasource instance.
This parameter is mandatory.

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

### -ConfigId
The specific configuration ID to retrieve.
Part of a mutually exclusive parameter set.

```yaml
Type: String
Parameter Sets: ConfigId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LatestConfigOnly
Switch to retrieve only the most recent configuration.
Part of the ListConfigs parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: ListConfigs
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigType
The type of configuration to retrieve.
Valid values are "Delta" or "Full".
Defaults to "Delta".

```yaml
Type: String
Parameter Sets: ListConfigs
Aliases:

Required: False
Position: Named
Default value: Delta
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

### Returns configuration data objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
