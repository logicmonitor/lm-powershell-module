---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAWSExternalId

## SYNOPSIS
Retrieves the AWS External ID associated with the LogicMonitor account.

## SYNTAX

```
Get-LMAWSExternalId [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMAWSExternalId function retrieves the AWS External ID that is associated with the current LogicMonitor account.
This ID is used for AWS integration purposes and helps identify the AWS account linked to your LogicMonitor instance.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve the AWS External ID
Get-LMAWSExternalId
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

### Returns a string containing the AWS External ID.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
