---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAlertEscalation

## SYNOPSIS
Creates a new escalation for a LogicMonitor alert.

## SYNTAX

```
New-LMAlertEscalation [-Id] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAlertEscalation function creates a new escalation for a specified alert in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
#Escalate an alert
New-LMAlertEscalation -Id "DS12345"
```

## PARAMETERS

### -Id
The ID of the alert to escalate.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### Returns a success message if the escalation is created successfully.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
