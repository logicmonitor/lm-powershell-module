---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAlertAck

## SYNOPSIS
Creates a new alert acknowledgment in LogicMonitor.

## SYNTAX

```
New-LMAlertAck [-Ids] <String[]> [-Note] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAlertAck function acknowledges one or more alerts in LogicMonitor and adds a note to the acknowledgment.

## EXAMPLES

### EXAMPLE 1
```
#Acknowledge multiple alerts
New-LMAlertAck -Ids @("12345","67890") -Note "Acknowledging alerts"
```

## PARAMETERS

### -Ids
The alert IDs to be acknowledged.
This parameter is mandatory.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Note
The note to be added to the acknowledgment.
This parameter is mandatory.

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

### Returns a success message if the acknowledgment is created successfully.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
