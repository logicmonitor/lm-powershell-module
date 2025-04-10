---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMNormalizedProperties

## SYNOPSIS
Removes normalized properties from LogicMonitor.

## SYNTAX

```
Remove-LMNormalizedProperties [-Alias] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMNormalizedProperties cmdlet removes normalized properties from LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMNormalizedProperties -Alias "location"
Removes the normalized property with alias "location".
```

## PARAMETERS

### -Alias
The alias name of the normalized property to remove.

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

### None.
## OUTPUTS

### Returns the response from the API after removing the normalized property.
## NOTES
This function requires valid API credentials to be logged in.
Use Connect-LMAccount to log in before running this command.

## RELATED LINKS
