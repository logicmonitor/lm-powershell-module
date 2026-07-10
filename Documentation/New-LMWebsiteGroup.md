---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: New-LMWebsiteGroup
---

# New-LMWebsiteGroup

## SYNOPSIS

Creates a new LogicMonitor website group.

## SYNTAX

### GroupId

```
New-LMWebsiteGroup -Name <string> -ParentGroupId <int> [-Description <string>]
 [-Properties <hashtable>] [-DisableAlerting <bool>] [-StopMonitoring <bool>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### GroupName

```
New-LMWebsiteGroup -Name <string> -ParentGroupName <string> [-Description <string>]
 [-Properties <hashtable>] [-DisableAlerting <bool>] [-StopMonitoring <bool>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The New-LMWebsiteGroup function creates a new website group in LogicMonitor.
It allows you to specify the name, description, properties, and parent group of the website group.

## EXAMPLES

### EXAMPLE 1

New-LMWebsiteGroup -Name "MyWebsiteGroup" -Description "This is my website group" -ParentGroupId 1234

This example creates a new website group with the name "MyWebsiteGroup", description "This is my website group", and parent group ID 1234.

### EXAMPLE 2

New-LMWebsiteGroup -Name "MyWebsiteGroup" -Description "This is my website group" -ParentGroupName "ParentGroup"

This example creates a new website group with the name "MyWebsiteGroup", description "This is my website group", and parent group name "ParentGroup".

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -Description

The description of the website group.

```yaml
Type: System.String
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

### -DisableAlerting

Specifies whether to disable alerting for the website group.
By default, alerting is enabled.

```yaml
Type: System.Boolean
DefaultValue: False
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

### -Name

The name of the website group.
This parameter is mandatory.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ParentGroupId

The ID of the parent group.
This parameter is mandatory if the ParentGroupName parameter is not specified.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ParentGroupName

The name of the parent group.
This parameter is mandatory if the ParentGroupId parameter is not specified.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Properties

A hashtable of custom properties for the website group.

```yaml
Type: System.Collections.Hashtable
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

### -StopMonitoring

Specifies whether to stop monitoring the website group.
By default, monitoring is not stopped.

```yaml
Type: System.Boolean
DefaultValue: False
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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns LogicMonitor.WebsiteGroup object.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

