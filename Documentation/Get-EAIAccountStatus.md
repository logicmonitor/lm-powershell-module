---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-EAIAccountStatus
---

# Get-EAIAccountStatus

## SYNOPSIS

Retrieves the current Edwin account connection status.

## SYNTAX

### __AllParameterSets

```
Get-EAIAccountStatus
```

## DESCRIPTION

Get-EAIAccountStatus returns connection details for the active Edwin session established by Connect-EAIAccount.

## EXAMPLES

### EXAMPLE 1

Get-EAIAccountStatus

## PARAMETERS

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns a PSCustomObject with EdwinOrg, PortalUrl, Valid, Type, ClientId, TokenExpiresAt, and Logging; otherwise a string when not connected.

## NOTES

Use Connect-EAIAccount to establish an Edwin session before running event ingestion commands.nn## RELATED LINKS

