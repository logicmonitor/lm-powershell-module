---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Disconnect-LMAccount

## SYNOPSIS
Disconnects from a previously connected LM portal.

## SYNTAX

```
Disconnect-LMAccount
```

## DESCRIPTION
The Disconnect-LMAccount function clears stored API credentials for a previously connected LM portal.
It's useful for switching between LM portals or clearing credentials after a script runs.

## EXAMPLES

### EXAMPLE 1
```
#Disconnect from the current LM portal
Disconnect-LMAccount
```

## PARAMETERS

## INPUTS

### None. You cannot pipe objects to this command.
## OUTPUTS

### None. This command does not generate any output.
## NOTES
Once disconnected you will need to reconnect to a portal before you will be allowed to run commands again.

## RELATED LINKS
