---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceProperty

## SYNOPSIS
Retrieves properties for a LogicMonitor device.

## SYNTAX

### Id (Default)
```
Get-LMDeviceProperty -Id <Int32> [-PropertyName <String>] [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMDeviceProperty [-Name <String>] [-PropertyName <String>] [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DisplayName
```
Get-LMDeviceProperty [-DisplayName <String>] [-PropertyName <String>] [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceProperty function retrieves properties for a specified device in LogicMonitor.
The device can be identified by ID, name, or display name, and you can retrieve either all properties or a specific property.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all properties for a device
Get-LMDeviceProperty -Id 123
```

### EXAMPLE 2
```
#Retrieve a specific property by name
Get-LMDeviceProperty -Name "Production-Server" -PropertyName "location"
```

## PARAMETERS

### -Id
The ID of the device to retrieve properties from.
Required for Id parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the device to retrieve properties from.
Required for Name parameter set.

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

### -DisplayName
The display name of the device to retrieve properties from.
Required for DisplayName parameter set.

```yaml
Type: String
Parameter Sets: DisplayName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyName
The name of a specific property to retrieve.
If not specified, retrieves all properties.

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

### -Filter
A filter object to apply when retrieving properties.
This parameter is optional.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns device property objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
