---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMLogicModule

## SYNOPSIS
Creates a new Logic Module in LogicMonitor.

## SYNTAX

```
New-LMLogicModule [-LogicModule] <PSObject> [-Type] <String> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-LMLogicModule function creates a new Logic Module in LogicMonitor.
It supports various types of modules including datasources, property rules, topology sources, event sources, log sources, and config sources.

## EXAMPLES

### EXAMPLE 1
```
$config = @{
    name = "MyLogicModule"
    # Additional configuration properties
}
New-LMLogicModule -LogicModule $config -Type "datasources"
```

## PARAMETERS

### -LogicModule
A PSCustomObject containing the Logic Module configuration.
Must follow the schema model defined in LogicMonitor's API documentation.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of Logic Module to create.
Valid values are: datasources, propertyrules, topologysources, eventsources, logsources, configsources

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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns LogicMonitor object of the appropriate type based on the Type parameter: LogicMonitor.Datasource, LogicMonitor.PropertySource, LogicMonitor.TopologySource, LogicMonitor.EventSource, LogicMonitor.LogSource, LogicMonitor.ConfigSource
## NOTES
You must run Connect-LMAccount before running this command.
For Logic Module schema details, see: https://www.logicmonitor.com/swagger-ui-master/api-v3/dist/#/Datasources/addDatasourceById

## RELATED LINKS
