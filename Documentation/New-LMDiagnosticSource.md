---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDiagnosticSource

## SYNOPSIS
Creates a new LogicMonitor diagnostic source.

## SYNTAX

```
New-LMDiagnosticSource [-DiagnosticSource] <PSObject> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMDiagnosticSource function creates a new diagnostic source in LogicMonitor using a provided diagnostic source configuration object.

## EXAMPLES

### EXAMPLE 1
```
# Create a new diagnostic source
$config = @{
    name = "MyDiagnosticSource"
    # Additional configuration properties
}
New-LMDiagnosticSource -DiagnosticSource $config
```

## PARAMETERS

### -DiagnosticSource
A PSCustomObject containing the diagnostic source configuration.
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

### Returns LogicMonitor.DiagnosticSource object.
## NOTES
You must run Connect-LMAccount before running this command.
For diagnostic source schema details, see: https://www.logicmonitor.com/swagger-ui-master/api-v3/dist/#/DiagnosticSources/addDiagnosticSource

## RELATED LINKS
