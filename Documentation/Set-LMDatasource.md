---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMDatasource

## SYNOPSIS
Updates a LogicMonitor datasource configuration.

## SYNTAX

### Id
```
Set-LMDatasource -Id <String> [-NewName <String>] [-DisplayName <String>] [-Description <String>]
 [-Tags <String[]>] [-TagsMethod <String>] [-appliesTo <String>] [-TechNotes <String>]
 [-PollingIntervalInSeconds <String>] [-Datapoints <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Name
```
Set-LMDatasource -Name <String> [-NewName <String>] [-DisplayName <String>] [-Description <String>]
 [-Tags <String[]>] [-TagsMethod <String>] [-appliesTo <String>] [-TechNotes <String>]
 [-PollingIntervalInSeconds <String>] [-Datapoints <PSObject>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMDatasource function modifies an existing datasource in LogicMonitor, allowing updates to its name, display name, description, applies to settings, and other properties.

## EXAMPLES

### EXAMPLE 1
```
Set-LMDatasource -Id 123 -NewName "UpdatedSource" -Description "New description"
Updates the datasource with ID 123 with a new name and description.
```

## PARAMETERS

### -Id
Specifies the ID of the datasource to modify.
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
Specifies the current name of the datasource.
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
Specifies the new name for the datasource.

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
Specifies the new display name for the datasource.

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
Specifies the new description for the datasource.

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

### -Tags
Specifies an array of tags to associate with the datasource.

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

### -TagsMethod
Specifies how to handle existing tags.
Valid values are "Add" or "Refresh".
Default is "Refresh".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Refresh
Accept pipeline input: False
Accept wildcard characters: False
```

### -appliesTo
Specifies the new applies to expression for the datasource.

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

### -TechNotes
Specifies the new technical notes for the datasource.

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

### -PollingIntervalInSeconds
Specifies the polling interval in seconds.

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

### -Datapoints
Specifies the datapoints configuration object for the datasource.

```yaml
Type: PSObject
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

### Returns a LogicMonitor.Datasource object containing the updated datasource information.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
