---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceGroupGroups

## SYNOPSIS
Retrieves subgroups of a LogicMonitor device group.

## SYNTAX

## DESCRIPTION
The Get-LMDeviceGroupGroups function retrieves all subgroups that belong to a specified device group in LogicMonitor.
The parent group can be identified by either ID or name, and the results can be filtered.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve subgroups by parent group ID
Get-LMDeviceGroupGroups -Id 123
```

### EXAMPLE 2
```
#Retrieve filtered subgroups by parent group name
Get-LMDeviceGroupGroups -Name "Production" -Filter $filterObject
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns LogicMonitor.DeviceGroup objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
