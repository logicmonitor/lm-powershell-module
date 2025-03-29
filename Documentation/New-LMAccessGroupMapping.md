---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAccessGroupMapping

## SYNOPSIS
Creates a new LogicMonitor access group mapping between an access group and an logicmodule.

## SYNTAX

```
New-LMAccessGroupMapping [-AccessGroupIds] <String[]> [-LogicModuleType] <String> [-LogicModuleId] <Int32>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAccessGroupMapping function is used to create a new access group mapping in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
New-LMAccessGroupMapping -AccessGroupIds "12345" -LogicModuleType "DATASOURCE" -LogicModuleId "67890"
```

This example creates a new access group mapping for the access group with ID "12345" and the logic module with ID "67890".

## PARAMETERS

### -AccessGroupIds
The IDs of the access group.
This parameter is mandatory.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogicModuleType
The type of logic module.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogicModuleId
The ID of the logic module.
This parameter is mandatory.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: 0
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
For this function to work, you need to be logged in and have valid API credentials.
Use the Connect-LMAccount function to log in before running any commands.

## RELATED LINKS
