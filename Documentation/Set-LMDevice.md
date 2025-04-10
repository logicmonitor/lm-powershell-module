---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMDevice

## SYNOPSIS
Updates a LogicMonitor device configuration.

## SYNTAX

### Id
```
Set-LMDevice -Id <String> [-NewName <String>] [-DisplayName <String>] [-Description <String>]
 [-PreferredCollectorId <Int32>] [-PreferredCollectorGroupId <Int32>] [-AutoBalancedCollectorGroupId <Int32>]
 [-Properties <Hashtable>] [-HostGroupIds <String[]>] [-PropertiesMethod <String>] [-Link <String>]
 [-DisableAlerting <Boolean>] [-EnableNetFlow <Boolean>] [-NetflowCollectorGroupId <Int32>]
 [-NetflowCollectorId <Int32>] [-EnableLogCollector <Boolean>] [-LogCollectorGroupId <Int32>]
 [-LogCollectorId <Int32>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Set-LMDevice -Name <String> [-NewName <String>] [-DisplayName <String>] [-Description <String>]
 [-PreferredCollectorId <Int32>] [-PreferredCollectorGroupId <Int32>] [-AutoBalancedCollectorGroupId <Int32>]
 [-Properties <Hashtable>] [-HostGroupIds <String[]>] [-PropertiesMethod <String>] [-Link <String>]
 [-DisableAlerting <Boolean>] [-EnableNetFlow <Boolean>] [-NetflowCollectorGroupId <Int32>]
 [-NetflowCollectorId <Int32>] [-EnableLogCollector <Boolean>] [-LogCollectorGroupId <Int32>]
 [-LogCollectorId <Int32>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMDevice function modifies an existing device in LogicMonitor, allowing updates to its name, display name, description, collector settings, and various other properties.

## EXAMPLES

### EXAMPLE 1
```
Set-LMDevice -Id 123 -NewName "UpdatedDevice" -Description "New description"
Updates the device with ID 123 with a new name and description.
```

## PARAMETERS

### -Id
Specifies the ID of the device to modify.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the current name of the device.
This parameter is mandatory when using the 'Name' parameter set.

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

### -NewName
Specifies the new name for the device.

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

### -DisplayName
Specifies the new display name for the device.

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

### -Description
Specifies the new description for the device.

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

### -PreferredCollectorId
Specifies the ID of the preferred collector for the device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreferredCollectorGroupId
Specifies the ID of the preferred collector group for the device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoBalancedCollectorGroupId
Specifies the ID of the auto-balanced collector group for the device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
Specifies a hashtable of custom properties for the device.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostGroupIds
Specifies an array of host group IDs to associate with the device.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertiesMethod
Specifies how to handle existing properties.
Valid values are "Add", "Replace", or "Refresh".
Default is "Replace".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Replace
Accept pipeline input: False
Accept wildcard characters: False
```

### -Link
Specifies the URL link associated with the device.

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

### -DisableAlerting
Specifies whether to disable alerting for the device.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableNetFlow
Specifies whether to enable NetFlow for the device.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetflowCollectorGroupId
Specifies the ID of the NetFlow collector group.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetflowCollectorId
Specifies the ID of the NetFlow collector.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableLogCollector
Specifies whether to enable log collection for the device.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogCollectorGroupId
Specifies the ID of the log collector group.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogCollectorId
Specifies the ID of the log collector.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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

### You can pipe objects containing Id properties to this function.
## OUTPUTS

### Returns a LogicMonitor.Device object containing the updated device information.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
