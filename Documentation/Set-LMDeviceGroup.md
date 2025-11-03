---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMDeviceGroup

## SYNOPSIS
Updates a LogicMonitor device group configuration.

## SYNTAX

### Id-ParentGroupId (Default)
```
Set-LMDeviceGroup -Id <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-Extra <Object>] [-DefaultCollectorId <Int32>] [-DefaultAutoBalancedCollectorGroupId <Int32>]
 [-DefaultCollectorGroupId <Int32>] [-PropertiesMethod <String>] [-DisableAlerting <Boolean>]
 [-EnableNetFlow <Boolean>] [-AppliesTo <String>] [-ParentGroupId <Int32>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-ParentGroupName
```
Set-LMDeviceGroup -Id <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-Extra <Object>] [-DefaultCollectorId <Int32>] [-DefaultAutoBalancedCollectorGroupId <Int32>]
 [-DefaultCollectorGroupId <Int32>] [-PropertiesMethod <String>] [-DisableAlerting <Boolean>]
 [-EnableNetFlow <Boolean>] [-AppliesTo <String>] [-ParentGroupName <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-ParentGroupName
```
Set-LMDeviceGroup -Name <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-Extra <Object>] [-DefaultCollectorId <Int32>] [-DefaultAutoBalancedCollectorGroupId <Int32>]
 [-DefaultCollectorGroupId <Int32>] [-PropertiesMethod <String>] [-DisableAlerting <Boolean>]
 [-EnableNetFlow <Boolean>] [-AppliesTo <String>] [-ParentGroupName <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-ParentGroupId
```
Set-LMDeviceGroup -Name <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-Extra <Object>] [-DefaultCollectorId <Int32>] [-DefaultAutoBalancedCollectorGroupId <Int32>]
 [-DefaultCollectorGroupId <Int32>] [-PropertiesMethod <String>] [-DisableAlerting <Boolean>]
 [-EnableNetFlow <Boolean>] [-AppliesTo <String>] [-ParentGroupId <Int32>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMDeviceGroup function modifies an existing device group in LogicMonitor, allowing updates to its name, description, properties, and various other settings.

## EXAMPLES

### EXAMPLE 1
```
Set-LMDeviceGroup -Id 123 -NewName "Updated Group" -Description "New description"
Updates the device group with ID 123 with a new name and description.
```

## PARAMETERS

### -Id
Specifies the ID of the device group to modify.

```yaml
Type: String
Parameter Sets: Id-ParentGroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Id-ParentGroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the current name of the device group.

```yaml
Type: String
Parameter Sets: Name-ParentGroupName, Name-ParentGroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Specifies the new name for the device group.

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
Specifies the new description for the device group.

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

### -Properties
Specifies a hashtable of custom properties for the device group.

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

### -Extra
Specifies a object of extra properties for the device group.
Used for LM Cloud resource groups

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

### -DefaultCollectorId
Specifies the default collector ID for the device group.

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

### -DefaultAutoBalancedCollectorGroupId
Specifies the default auto-balanced collector group ID for the device group.

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

### -DefaultCollectorGroupId
Specifies the default collector group ID for the device group.

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

### -DisableAlerting
Specifies whether to disable alerting for the device group.

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
Specifies whether to enable NetFlow for the device group.

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

### -AppliesTo
Specifies the applies to expression for the device group.

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

### -ParentGroupId
Specifies the ID of the parent group.

```yaml
Type: Int32
Parameter Sets: Id-ParentGroupId, Name-ParentGroupId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupName
Specifies the name of the parent group.

```yaml
Type: String
Parameter Sets: Id-ParentGroupName, Name-ParentGroupName
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

### Returns a LogicMonitor.DeviceGroup object containing the updated group information.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
