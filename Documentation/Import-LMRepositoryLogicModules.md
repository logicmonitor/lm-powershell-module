---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Import-LMRepositoryLogicModules

## SYNOPSIS
Imports LogicMonitor repository logic modules.

## SYNTAX

```
Import-LMRepositoryLogicModules [-Type] <String> [-LogicModuleNames] <String[]>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Import-LMRepositoryLogicModules function imports specified logic modules from the LogicMonitor repository into your portal.

## EXAMPLES

### EXAMPLE 1
```
#Import specific datasources
Import-LMRepositoryLogicModules -Type "datasources" -LogicModuleNames "DataSource1", "DataSource2"
```

## PARAMETERS

### -Type
The type of logic modules to import.
Valid values are "datasources", "propertyrules", "eventsources", "topologysources", "configsources".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogicModuleNames
An array of logic module names to import.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns a success message with the names of imported modules.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
