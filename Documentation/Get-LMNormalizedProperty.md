---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMNormalizedProperty

## SYNOPSIS
Gets normalized property mappings from LogicMonitor.

## SYNTAX

```
Get-LMNormalizedProperty [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMNormalizedProperty function retrieves normalized property mappings that allow standardizing property names across your LogicMonitor environment.
This function only supports the v4 API.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all normalized properties
Get-LMNormalizedProperty
```

## PARAMETERS

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

### Returns LogicMonitor.NormalizedProperties objects.
## NOTES
You must run Connect-LMAccount before running this command.
This command is reserver for internal use only.

## RELATED LINKS
