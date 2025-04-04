---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAlertNote

## SYNOPSIS
Creates a new note for LogicMonitor alerts.

## SYNTAX

```
New-LMAlertNote [-Ids] <String[]> [-Note] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAlertNote function adds a note to one or more alerts in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
#Add a note to multiple alerts
New-LMAlertNote -Ids @("12345","67890") -Note "This is a sample note"
```

## PARAMETERS

### -Ids
The alert IDs to add the note to.
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
The content of the note to add.
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

### Returns a success message if the note is created successfully.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
