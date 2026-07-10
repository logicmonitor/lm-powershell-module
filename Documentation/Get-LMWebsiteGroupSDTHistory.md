---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMWebsiteGroupSDTHistory
---

# Get-LMWebsiteGroupSDTHistory

## SYNOPSIS

Retrieves historical Scheduled Down Time (SDT) entries for a website group from LogicMonitor.

## SYNTAX

### Id (Default)

```
Get-LMWebsiteGroupSDTHistory -Id <int> [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

### Name

```
Get-LMWebsiteGroupSDTHistory [-Name <string>] [-Filter <Object>] [-BatchSize <int>]
 [<CommonParameters>]
```

## DESCRIPTION

The Get-LMWebsiteGroupSDTHistory function retrieves historical SDT entries for a specified website group in LogicMonitor.
The group can be identified by either ID or name.

## EXAMPLES

### EXAMPLE 1

#Retrieve SDT history by group ID
Get-LMWebsiteGroupSDTHistory -Id 123

### EXAMPLE 2

#Retrieve SDT history for a specific group
Get-LMWebsiteGroupSDTHistory -Name "Production-Websites"

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

A filter object to apply when retrieving SDT history.

```yaml
Type: System.Object
DefaultValue: ''
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

### -Id

The ID of the website group to retrieve SDT history from.
Required for Id parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the website group to retrieve SDT history from.
Required for Name parameter set.

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

### Returns historical website group SDT objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

