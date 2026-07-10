---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMPortalInfo
---

# Get-LMPortalInfo

## SYNOPSIS

Retrieves portal information from LogicMonitor.

## SYNTAX

### __AllParameterSets

```
Get-LMPortalInfo [<CommonParameters>]
```

## DESCRIPTION

The Get-LMPortalInfo function retrieves company settings and portal information from your LogicMonitor instance.

## EXAMPLES

### EXAMPLE 1

#Retrieve portal information
Get-LMPortalInfo

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns portal information object containing company settings.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

