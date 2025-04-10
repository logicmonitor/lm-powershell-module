---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceGroup

## SYNOPSIS
Retrieves device group information from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMDeviceGroup [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMDeviceGroup [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMDeviceGroup [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMDeviceGroup [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### FilterWizard
```
Get-LMDeviceGroup [-FilterWizard] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceGroup function retrieves device group information from a connected LogicMonitor portal.
It supports retrieving groups by ID, name (including wildcards), or using custom filters.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all device groups
Get-LMDeviceGroup
```

### EXAMPLE 2
```
#Retrieve a specific device group by name with wildcard
Get-LMDeviceGroup -Name "* - Servers"
```

### EXAMPLE 3
```
#Retrieve device groups using a filter
Get-LMDeviceGroup -Filter @{parentId=1;disableAlerting=$false}
```

## PARAMETERS

### -Id
The ID of the device group to retrieve.
Part of a mutually exclusive parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
The name of the device group to retrieve.
Supports wildcard input such as "* - Servers".
Part of a mutually exclusive parameter set.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A filter object to apply when retrieving device groups.
Can include multiple conditions combined as AND operations.
Part of a mutually exclusive parameter set.

```yaml
Type: Object
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterWizard
Switch to use the filter wizard interface for building the filter.
Part of a mutually exclusive parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: FilterWizard
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
The number of results to return per request.
Must be between 1 and 1000.
Defaults to 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
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

### System.Int32. The device group ID can be piped to this function.
## OUTPUTS

### Returns LogicMonitor.DeviceGroup objects.
## NOTES
You must run Connect-LMAccount before running this command.
When using filters, consult the LM API docs for allowed filter fields.

## RELATED LINKS
