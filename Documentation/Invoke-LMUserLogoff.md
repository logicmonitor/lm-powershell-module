---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMUserLogoff

## SYNOPSIS
Forces user logoff in LogicMonitor.

## SYNTAX

```
Invoke-LMUserLogoff [-Usernames] <String[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMUserLogoff function forces one or more users to be logged out of their LogicMonitor sessions.

## EXAMPLES

### EXAMPLE 1
```
#Log off multiple users
Invoke-LMUserLogoff -Usernames "user1", "user2"
```

## PARAMETERS

### -Usernames
An array of usernames to log off.

```yaml
Type: String[]
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

### Returns a success message if the logoff is completed successfully.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
