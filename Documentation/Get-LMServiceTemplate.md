---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMServiceTemplate
---

# Get-LMServiceTemplate

## SYNOPSIS

Retrieves service template information from LogicMonitor.

## SYNTAX

### __AllParameterSets

```
Get-LMServiceTemplate [<CommonParameters>]
```

## DESCRIPTION

The Get-LMServiceTemplate function retrieves service templates from LogicMonitor.
This function only supports the v4 API.

## EXAMPLES

### EXAMPLE 1

#Retrieve all service templates
Get-LMServiceTemplate

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns LogicMonitor.ServiceTemplate objects.

## NOTES

You must run Connect-LMAccount before running this command.
This command is reserved for internal use only.

## RELATED LINKS

