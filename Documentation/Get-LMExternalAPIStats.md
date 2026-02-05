---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMExternalAPIStats

## SYNOPSIS
Retrieves external API statistics from LogicMonitor.

## SYNTAX

```
Get-LMExternalAPIStats [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMExternalAPIStats function retrieves external API usage statistics from LogicMonitor.
This provides information about API call volumes and usage patterns for external API access.

## EXAMPLES

### EXAMPLE 1
```
Get-LMExternalAPIStats
```

Retrieves all external API statistics for the account.

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

### Returns LogicMonitor.ExternalAPIStats object.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
