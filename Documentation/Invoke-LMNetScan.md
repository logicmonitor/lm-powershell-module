---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMNetScan

## SYNOPSIS
Invokes a NetScan task in LogicMonitor.

## SYNTAX

```
Invoke-LMNetScan [-Id] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMNetScan function schedules execution of a specified NetScan task in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
#Execute a NetScan
Invoke-LMNetScan -Id "12345"
```

## PARAMETERS

### -Id
The ID of the NetScan to execute.

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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns a success message if the NetScan is scheduled successfully.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
