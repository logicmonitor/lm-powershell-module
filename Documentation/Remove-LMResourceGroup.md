---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/22/2026
PlatyPS schema version: 2024-05-01
title: Remove-LMResourceGroup
---

# Remove-LMResourceGroup

## SYNOPSIS

Removes a LogicMonitor resourceGroup (v4 API), including a Service
Insight/Service Template container group ("BizService" resource group).

## SYNTAX

### __AllParameterSets

```
Remove-LMResourceGroup [-Id] <string> [-DeleteChildren] [-WhatIf] [-Confirm]
```

## DESCRIPTION

Static Service Insights and Service Templates each auto-create a
SERVICE_GROUP-type resourceGroup (visible in the portal's "Services"
tree, distinct from an ordinary device group) to contain the service
and any child groups.
Removing the Service Insight device
(Remove-LMServiceInsight) or Service Template
(Remove-LMDynamicServiceInsight) does not remove this container - it's left
behind.
Use Get-LMServiceGroup first to confirm a group's type before
removing it here.

Named distinctly from the existing Remove-LMServiceGroup (v3
/device/groups endpoint, -Name lookup, different parameters) - this
uses the v4 /resourceGroups endpoint instead, confirmed via a HAR
capture of LogicMonitor's own UI deleting a service group.
The two are
not interchangeable; this one is what's needed for SERVICE_GROUP-type
containers specifically.

## EXAMPLES

### EXAMPLE 1

Remove-LMResourceGroup -Id 14822

### EXAMPLE 2

#Also remove everything nested under this group
Remove-LMResourceGroup -Id 14962 -DeleteChildren

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

### -DeleteChildren

If set, also deletes all child groups/services under this one.
If not
set (default), only this group itself is removed - matches
LogicMonitor's own UI choice between "Delete group" and "Delete group
and all services in the group".

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -Id

The resourceGroups id of the group to remove.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

### You can pipe objects containing an Id property to this function.

### System.String

## OUTPUTS

### Returns a PSCustomObject containing the ID of the removed group and a
success message confirming the removal.

## NOTES

You must run Connect-LMAccount with -SessionSync before running this
command - this endpoint does not support LMv1 or Bearer auth.
Request shape confirmed via a HAR capture of LogicMonitor's own UI
deleting a service group.

## RELATED LINKS

