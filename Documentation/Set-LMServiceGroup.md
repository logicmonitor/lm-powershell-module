---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMServiceGroup

## SYNOPSIS
Updates a LogicMonitor Service group configuration.

## SYNTAX

### Id-ParentGroupId (Default)
```
Set-LMServiceGroup -Id <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-DisableAlerting <Boolean>] [-ParentGroupId <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-ParentGroupName
```
Set-LMServiceGroup -Id <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-DisableAlerting <Boolean>] [-ParentGroupName <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-ParentGroupName
```
Set-LMServiceGroup -Name <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-DisableAlerting <Boolean>] [-ParentGroupName <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-ParentGroupId
```
Set-LMServiceGroup -Name <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-DisableAlerting <Boolean>] [-ParentGroupId <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMServiceGroup function modifies an existing Service group in LogicMonitor, allowing updates to its name, description, properties, and various other settings.

## EXAMPLES

### EXAMPLE 1
```
Set-LMServiceGroup -Id 123 -NewName "Updated Group" -Description "New description"
Updates the Service group with ID 123 with a new name and description.
```

## PARAMETERS

### -Id
Specifies the ID of the Service group to modify.

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
Specifies the current name of the Service group.

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
Specifies the new name for the Service group.

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
Specifies the new description for the Service group.

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
Specifies a hashtable of custom properties for the Service group.

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
Specifies whether to disable alerting for the Service group.

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
