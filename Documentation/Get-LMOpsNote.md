---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMOpsNote

## SYNOPSIS
Retrieves operations notes from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMOpsNote [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMOpsNote [-Id <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Tag
```
Get-LMOpsNote [-Tag <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Filter
```
Get-LMOpsNote [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMOpsNote function retrieves operations notes from LogicMonitor.
It can retrieve all notes, a specific note by ID, notes by tag, or filter the results.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all operations notes
Get-LMOpsNote
```

### EXAMPLE 2
```
#Retrieve operations notes by tag
Get-LMOpsNote -Tag "Maintenance"
```

## PARAMETERS

### -Id
The ID of the specific operations note to retrieve.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag
The tag to filter operations notes by.

```yaml
Type: String
Parameter Sets: Tag
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A filter object to apply when retrieving operations notes.

```yaml
Type: Object
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
The number of results to return per request.
Must be between 1 and 1000.
Defaults to 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
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

### Returns operations note objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
