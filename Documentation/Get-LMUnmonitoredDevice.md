---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMUnmonitoredDevice
---

# Get-LMUnmonitoredDevice

## SYNOPSIS

Retrieves unmonitored devices from LogicMonitor.

## SYNTAX

### __AllParameterSets

```
Get-LMUnmonitoredDevice [[-Filter] <Object>] [[-BatchSize] <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMUnmonitoredDevice function retrieves information about devices that are discovered but not currently being monitored in LogicMonitor.

## EXAMPLES

### EXAMPLE 1

#Retrieve all unmonitored devices
Get-LMUnmonitoredDevice

### EXAMPLE 2

#Retrieve unmonitored devices using a filter
Get-LMUnmonitoredDevice -Filter $filterObject

## PARAMETERS

### -BatchSize

The number of results to return per request.
Must be between 1 and 1000.
Defaults to 1000.

```yaml
Type: System.Int32
DefaultValue: 1000
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Filter

A filter object to apply when retrieving unmonitored devices.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
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

### Returns LogicMonitor.UnmonitoredDevice objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

