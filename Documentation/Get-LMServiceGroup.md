---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/22/2026
PlatyPS schema version: 2024-05-01
title: Get-LMServiceGroup
---

# Get-LMServiceGroup

## SYNOPSIS

Retrieves full detail for a LogicMonitor resource group, including
its type (e.g. SERVICE_GROUP for a Service Insight/Service Template
container vs. an ordinary device group).

## SYNTAX

### __AllParameterSets

```
Get-LMServiceGroup [-Id] <string>
```

## DESCRIPTION

Get-LMDeviceGroup (v3 API) doesn't expose a group's `type` or
`recordTypeName` fields, which is how a Service Insight or Service
Template's auto-created container group ("BizService", shown as a
SERVICE_GROUP in the portal's "Services" tree) is distinguished from
an ordinary device group.
Get-LMServiceGroup fetches that detail via
the v4 /resourceGroups/filter endpoint.

Removing a Service Insight (Remove-LMServiceInsight) or Service
Template (Remove-LMDynamicServiceInsight) does not remove this container
group - it's left behind separately.
Use Remove-LMResourceGroup to
clean it up once identified here.

## EXAMPLES

### EXAMPLE 1

Get-LMServiceGroup -Id 14822

## PARAMETERS

### -Id

The resourceGroups id to fetch.

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

### Returns the raw resourceGroups object for the given id (not wrapped
in a LogicMonitor.* type

## NOTES

You must run Connect-LMAccount with -SessionSync before running this
command - this endpoint does not support LMv1 or Bearer auth.
Request shape confirmed via a HAR capture of LogicMonitor's own UI
deleting a service group.

## RELATED LINKS

