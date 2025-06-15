---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMServiceGroup

## SYNOPSIS
Removes a LogicMonitor Service group.

## SYNTAX

### Id (Default)
```
Remove-LMServiceGroup -Id <Int32> [-DeleteHostsandChildren <Boolean>] [-HardDelete <Boolean>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Remove-LMServiceGroup -Name <String> [-DeleteHostsandChildren <Boolean>] [-HardDelete <Boolean>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMServiceGroup function is used to remove a LogicMonitor Service group.
It supports removing the group by either its ID or name.
The function requires valid API credentials to be logged in.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMServiceGroup -Id 12345
Removes the Service group with the specified ID.
```

### EXAMPLE 2
```
Remove-LMServiceGroup -Name "MyServiceGroup"
Removes the Service group with the specified name.
```

## PARAMETERS

### -Id
Specifies the ID of the Service group to be removed.
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
Specifies the name of the Service group to be removed.
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
Specifies whether to delete the service group and their children services within the Service group.
By default, this parameter is set to $false.

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

### -HardDelete
Specifies whether to perform a hard delete, which permanently removes the Service group and its associated data.
By default, this parameter is set to $false.

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

### None.
## OUTPUTS

### Returns a PSCustomObject containing the ID of the removed Service group and a message confirming the successful removal.
## NOTES
This function requires valid API credentials to be logged in.
Use the Connect-LMAccount function to log in before running any commands.

## RELATED LINKS
