---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMAppliesToFunction

## SYNOPSIS
Updates a LogicMonitor AppliesTo function.

## SYNTAX

### Id (Default)
```
Set-LMAppliesToFunction [-NewName <String>] -Id <String> [-Description <String>] [-AppliesTo <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Set-LMAppliesToFunction -Name <String> [-NewName <String>] [-Description <String>] [-AppliesTo <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMAppliesToFunction function modifies an existing AppliesTo function in LogicMonitor, allowing updates to its name, description, and AppliesTo code.

## EXAMPLES

### EXAMPLE 1
```
Set-LMAppliesToFunction -Id 123 -NewName "UpdatedFunction" -Description "New description"
Updates the AppliesTo function with ID 123 with a new name and description.
```

## PARAMETERS

### -Name
Specifies the current name of the AppliesTo function.
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
Specifies the new name for the AppliesTo function.

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

### -Id
Specifies the ID of the AppliesTo function to modify.

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

### -Description
Specifies a new description for the AppliesTo function.

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

### -AppliesTo
Specifies the new AppliesTo code for the function.

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

### Returns a LogicMonitor.AppliesToFunction object containing the updated function information.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
