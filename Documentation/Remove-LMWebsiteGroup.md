---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMWebsiteGroup

## SYNOPSIS
Removes a website group from LogicMonitor.

## SYNTAX

### Id (Default)
```
Remove-LMWebsiteGroup -Id <Int32> [-DeleteHostsandChildren <Boolean>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Remove-LMWebsiteGroup -Name <String> [-DeleteHostsandChildren <Boolean>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMWebsiteGroup function removes a website group from LogicMonitor using either its ID or name.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMWebsiteGroup -Id 123
Removes the website group with ID 123.
```

### EXAMPLE 2
```
Remove-LMWebsiteGroup -Name "MyGroup" -DeleteHostsandChildren $true
Removes the website group named "MyGroup" and all its child items.
```

## PARAMETERS

### -Id
Specifies the ID of the website group to remove.
This parameter is mandatory when using the 'Id' parameter set.

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
Specifies the name of the website group to remove.
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

### -DeleteHostsandChildren
Specifies whether to delete the hosts and their children within the website group.
Default value is $false.

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

### You can pipe objects to this function.
## OUTPUTS

### Returns a PSCustomObject containing the ID of the removed website group and a success message confirming the removal.
## NOTES

## RELATED LINKS
