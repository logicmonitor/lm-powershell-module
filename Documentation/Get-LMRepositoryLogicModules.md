---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMRepositoryLogicModules

## SYNOPSIS
Retrieves LogicModules from the LogicMonitor repository.

## SYNTAX

```
Get-LMRepositoryLogicModules [[-Type] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMRepositoryLogicModules function retrieves LogicModules from the LogicMonitor repository.
It supports retrieving different types of modules including datasources, property rules, event sources, topology sources, and config sources.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all datasource modules
Get-LMRepositoryLogicModules
```

### EXAMPLE 2
```
#Retrieve all event source modules
Get-LMRepositoryLogicModules -Type "eventsource"
```

## PARAMETERS

### -Type
The type of LogicModule to retrieve.
Valid values are "datasource", "propertyrules", "eventsource", "topologysource", "configsource".
Defaults to "datasource".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Datasource
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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns LogicMonitor.RepositoryLogicModules objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
