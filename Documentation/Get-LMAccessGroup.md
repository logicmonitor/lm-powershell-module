---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMAccessGroup
---

# Get-LMAccessGroup

## SYNOPSIS

Retrieves access groups from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMAccessGroup [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMAccessGroup [-Id <int>] [-BatchSize <int>] [<CommonParameters>]
```

### Name

```
Get-LMAccessGroup [-Name <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMAccessGroup [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMAccessGroup function retrieves access group information from LogicMonitor.
It can return a single access group by ID or name, or multiple groups based on filter criteria.

## EXAMPLES

### EXAMPLE 1

#Retrieve an access group by ID
Get-LMAccessGroup -Id 123

### EXAMPLE 2

#Retrieve an access group by name
Get-LMAccessGroup -Name "Admin Group"

### EXAMPLE 3

#Retrieve access groups using a filter
Get-LMAccessGroup -Filter "name -like 'Dev*'"

## PARAMETERS

### -BatchSize

The number of results to return per request.
Must be between 1 and 1000.
Default is 1000.

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

A filter object to apply when retrieving access groups.
This parameter is part of a mutually exclusive parameter set.

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

The ID of the access group to retrieve.
This parameter is part of a mutually exclusive parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
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

### -Name

The name of the access group to retrieve.
This parameter is part of a mutually exclusive parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name
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

### Returns LogicMonitor.AccessGroup objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

