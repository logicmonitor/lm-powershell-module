---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMUsageMetric
---

# Get-LMUsageMetric

## SYNOPSIS

Retrieves LogicMonitor account usage metrics from the API.

## SYNTAX

### All (Default)

```
Get-LMUsageMetric [<CommonParameters>]
```

## DESCRIPTION

The Get-LMUsageMetric cmdlet calls the `/metrics/usage` endpoint and returns the usage payload
for your LogicMonitor portal (for example device counts and related usage figures).
You must
call Connect-LMAccount before using this cmdlet.

## EXAMPLES

### EXAMPLE 1

Get-LMUsageMetric

Retrieves current usage metrics for the connected portal.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this cmdlet.

## OUTPUTS

### Returns the object returned by the LogicMonitor usage metrics API.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

