---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Invoke-LMUserLogoff
---

# Invoke-LMUserLogoff

## SYNOPSIS

Forces user logoff in LogicMonitor.

## SYNTAX

### __AllParameterSets

```
Invoke-LMUserLogoff [-Usernames] <string[]> [<CommonParameters>]
```

## DESCRIPTION

The Invoke-LMUserLogoff function forces one or more users to be logged out of their LogicMonitor sessions.

## EXAMPLES

### EXAMPLE 1

#Log off multiple users
Invoke-LMUserLogoff -Usernames "user1", "user2"

## PARAMETERS

### -Usernames

An array of usernames to log off.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns a success message if the logoff is completed successfully.

### System.String

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

