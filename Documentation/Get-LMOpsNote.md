---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMOpsNote
---

# Get-LMOpsNote

## SYNOPSIS

Retrieves operations notes from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMOpsNote [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMOpsNote [-Id <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Tag

```
Get-LMOpsNote [-Tag <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMOpsNote [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMOpsNote function retrieves operations notes from LogicMonitor.
It can retrieve all notes, a specific note by ID, notes by tag, or filter the results.

## EXAMPLES

### EXAMPLE 1

#Retrieve all operations notes
Get-LMOpsNote

### EXAMPLE 2

#Retrieve operations notes by tag
Get-LMOpsNote -Tag "Maintenance"

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
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Filter

A filter object to apply when retrieving operations notes.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

The ID of the specific operations note to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

The tag to filter operations notes by.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Tag
  Position: Named
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

### Returns operations note objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

