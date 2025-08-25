---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMAccessGroup

## SYNOPSIS
Sets the properties of a LogicMonitor access group.

## SYNTAX

### Id
```
Set-LMAccessGroup [-Id <Int32>] [-NewName <String>] [-Description <String>] [-Tenant <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Set-LMAccessGroup [-Name <String>] [-NewName <String>] [-Description <String>] [-Tenant <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMAccessGroup function is used to set the properties of a LogicMonitor access group.
It allows you to specify the access group either by its ID or by its name.
You can set the new name, description, and tenant ID for the access group.

## EXAMPLES

### EXAMPLE 1
```
Set-LMAccessGroup -Id 123 -NewName "New Access Group" -Description "This is a new access group" -Tenant "abc123"
Sets the properties of the access group with ID 123. The new name is set to "New Access Group", the description is set to "This is a new access group", and the tenant ID is set to "abc123".
```

### EXAMPLE 2
```
Set-LMAccessGroup -Name "Old Access Group" -NewName "New Access Group" -Description "This is a new access group" -Tenant "abc123"
Sets the properties of the access group with name "Old Access Group". The new name is set to "New Access Group", the description is set to "This is a new access group", and the tenant ID is set to "abc123".
```

## PARAMETERS

### -Id
Specifies the ID of the access group.
This parameter is used when you want to set the properties of the access group by its ID.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the name of the access group.
This parameter is used when you want to set the properties of the access group by its name.

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

### -NewName
Specifies the new name for the access group.

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
Specifies the new description for the access group.

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

### -Tenant
Specifies the tenant ID for the access group.

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

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

## NOTES
This function requires you to be logged in and have valid API credentials.
Use the Connect-LMAccount function to log in before running this command.

## RELATED LINKS
