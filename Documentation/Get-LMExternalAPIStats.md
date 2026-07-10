---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMExternalAPIStats
---

# Get-LMExternalAPIStats

## SYNOPSIS

Retrieves external API statistics from LogicMonitor.

## SYNTAX

### __AllParameterSets

```
Get-LMExternalAPIStats [<CommonParameters>]
```

## DESCRIPTION

The Get-LMExternalAPIStats function retrieves external API usage statistics from LogicMonitor.
This provides information about API call volumes and usage patterns for external API access.

## EXAMPLES

### EXAMPLE 1

Get-LMExternalAPIStats

Retrieves all external API statistics for the account.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns LogicMonitor.ExternalAPIStats object.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

