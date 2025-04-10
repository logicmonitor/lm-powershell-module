---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMPortalInfo

## SYNOPSIS
Retrieves portal information from LogicMonitor.

## SYNTAX

```
Get-LMPortalInfo [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMPortalInfo function retrieves company settings and portal information from your LogicMonitor instance.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve portal information
Get-LMPortalInfo
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

### Returns portal information object containing company settings.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
