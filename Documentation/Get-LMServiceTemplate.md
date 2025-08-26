---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMServiceTemplate

## SYNOPSIS
Retrieves service template information from LogicMonitor.

## SYNTAX

```
Get-LMServiceTemplate [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMServiceTemplate function retrieves service templates from LogicMonitor.
This function only supports the v4 API.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all service templates
Get-LMServiceTemplate
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

### Returns LogicMonitor.ServiceTemplate objects.
## NOTES
You must run Connect-LMAccount before running this command.
This command is reserved for internal use only.

## RELATED LINKS
