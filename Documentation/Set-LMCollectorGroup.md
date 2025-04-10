---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMCollectorGroup

## SYNOPSIS
Updates a LogicMonitor collector group's configuration.

## SYNTAX

### Id
```
Set-LMCollectorGroup [-Id <Int32>] [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-AutoBalance <Boolean>] [-AutoBalanceInstanceCountThreshold <Int32>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Set-LMCollectorGroup [-Name <String>] [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-AutoBalance <Boolean>] [-AutoBalanceInstanceCountThreshold <Int32>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMCollectorGroup function modifies an existing collector group's settings, including its name, description, properties, and auto-balance settings.

## EXAMPLES

### EXAMPLE 1
```
Set-LMCollectorGroup -Id 123 -NewName "Updated Group" -AutoBalance $true
Updates the collector group with ID 123 with a new name and enables auto-balancing.
```

## PARAMETERS

### -Id
Specifies the ID of the collector group to modify.
This parameter is mandatory when using the 'Id' parameter set.

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
Specifies the current name of the collector group.
This parameter is mandatory when using the 'Name' parameter set.

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
Specifies the new name for the collector group.

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
Specifies a new description for the collector group.

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
Specifies a hashtable of custom properties to set for the collector group.

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

### -AutoBalance
Specifies whether to enable auto-balancing for the collector group.

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

### -AutoBalanceInstanceCountThreshold
Specifies the threshold for auto-balancing the collector group.

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

### Returns a LogicMonitor.CollectorGroup object containing the updated group information.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
