---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Build-LMFilter

## SYNOPSIS
Builds a filter expression for Logic Monitor API queries.

## SYNTAX

```
Build-LMFilter [-PassThru] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Build-LMFilter function creates a filter expression by interactively prompting for conditions and operators.
It supports basic filtering for single fields and advanced filtering for property-based queries.
Multiple conditions can be combined using AND/OR operators.

## EXAMPLES

### EXAMPLE 1
```
#Build a basic filter expression
Build-LMFilter
This example launches the interactive filter builder wizard.
```

### EXAMPLE 2
```
#Build a filter and return the expression
Build-LMFilter -PassThru
This example builds a filter and returns the expression as a string.
```

## PARAMETERS

### -PassThru
When specified, returns the filter expression as a string instead of displaying it in a panel.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### [String] Returns a PowerShell filter expression when using -PassThru.
## NOTES
The filter expression is saved to the global $LMFilter variable.

## RELATED LINKS
