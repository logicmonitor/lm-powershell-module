---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMAWSExternalId
---

# Get-LMAWSExternalId

## SYNOPSIS

Retrieves the AWS External ID associated with the LogicMonitor account.

## SYNTAX

### All (Default)

```
Get-LMAWSExternalId [<CommonParameters>]
```

## DESCRIPTION

The Get-LMAWSExternalId function retrieves the AWS External ID that is associated with the current LogicMonitor account.
This ID is used for AWS integration purposes and helps identify the AWS account linked to your LogicMonitor instance.

## EXAMPLES

### EXAMPLE 1

#Retrieve the AWS External ID
Get-LMAWSExternalId

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns a string containing the AWS External ID.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

