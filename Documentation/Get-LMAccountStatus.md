---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAccountStatus

## SYNOPSIS
Retrieves the current LogicMonitor account connection status.

## SYNTAX

```
Get-LMAccountStatus
```

## DESCRIPTION
The Get-LMAccountStatus function retrieves the current connection status of the LogicMonitor account, including portal information, authentication validity, logging status, and authentication type.

## EXAMPLES

### EXAMPLE 1
```
#Get the current account status
Get-LMAccountStatus
```

## PARAMETERS

## INPUTS

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns a PSCustomObject with the following properties: Portal, Valid, Logging, and Type
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
