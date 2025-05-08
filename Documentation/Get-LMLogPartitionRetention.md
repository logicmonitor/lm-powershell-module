---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMLogPartitionRetention

## SYNOPSIS
Retrieves LM Log Partition Retentions from LogicMonitor.

## SYNTAX

```
Get-LMLogPartitionRetention [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMLogPartitionRetention function retrieves LM Log Partition Retentions from LogicMonitor.
It can retrieve all log partition retentions available to the account.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all log partition retentions
Get-LMLogPartitionRetention
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

### Returns LogicMonitor.LogPartitionRetention objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
