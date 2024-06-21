---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version: https://www.logicmonitor.com/support/rest-api-developers-guide/
schema: 2.0.0
---

# Get-LMAWSAccountId

## SYNOPSIS
Retrieves the AWS Account ID associated with the LogicMonitor account.

## SYNTAX

```
Get-LMAWSAccountId [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMAWSAccountId function is used to retrieve the AWS Account ID associated with the LogicMonitor account.
It checks if the user is logged in and has valid API credentials.
If the user is logged in, it builds the necessary headers and URI, and then sends a GET request to the LogicMonitor API to retrieve the AWS Account ID.
The function returns the response containing the AWS Account ID.

## EXAMPLES

### EXAMPLE 1
```
Get-LMAWSAccountId
Retrieves the AWS Account ID associated with the LogicMonitor account.
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

## OUTPUTS

## NOTES

## RELATED LINKS
