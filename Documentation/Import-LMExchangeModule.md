---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Import-LMExchangeModule

## SYNOPSIS
Imports an LM Exchange module into LogicMonitor.

## SYNTAX

```
Import-LMExchangeModule [-LMExchangeId] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Import-LMExchangeModule function imports a specified LM Exchange module into your LogicMonitor portal.

## EXAMPLES

### EXAMPLE 1
```
#Import an LM Exchange module
Import-LMExchangeModule -LMExchangeId "LM12345"
```

## PARAMETERS

### -LMExchangeId
The ID of the LM Exchange module to import.
This parameter is mandatory.

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

### Returns a success message if the import is successful.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
