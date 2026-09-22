---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/22/2026
PlatyPS schema version: 2024-05-01
title: Set-LMServiceInsight
---

# Set-LMServiceInsight

## SYNOPSIS

Updates a LogicMonitor Service Insight, most commonly its membership.

## SYNTAX

### __AllParameterSets

```
Set-LMServiceInsight [-Id] <int> [[-DeviceMemberFilter] <hashtable[]>]
 [[-InstanceMemberFilter] <hashtable[]>] [[-EvalMembersInterval] <int>] [[-DisplayName] <string>]
 [[-Description] <string>] [[-PreferredCollectorId] <int>] [[-HostGroupIds] <string[]>]
 [[-Properties] <hashtable>] [-WhatIf] [-Confirm]
```

## DESCRIPTION

Updates a Service Insight (a DeviceType 6 device) via Set-LMDevice.
-DeviceMemberFilter / -InstanceMemberFilter replace the Service
Insight's entire membership definition (the predef.bizservice.members
custom property) — LogicMonitor's membership model isn't additive per
filter entry, so this cmdlet always replaces the full set of filters
rather than trying to merge with what's already there.
Pull the
current filters first with Get-LMServiceInsight, edit the array, and
pass the whole thing back if you need to add/remove one filter among
several.

Also supports updating -EvalMembersInterval and the same general
device fields (name, description, etc.) as Set-LMDevice, without
disturbing the predef.bizservice.* properties unless you specifically
pass -DeviceMemberFilter, -InstanceMemberFilter, or
-EvalMembersInterval.

## EXAMPLES

### EXAMPLE 1

#Add another device filter to an existing Service Insight
$si = Get-LMServiceInsight -Id 129189
$newFilters = $si.DeviceMemberFilter + @{
    deviceGroupFullPath = "*"
    deviceDisplayName   = "*"
    deviceProperties    = @(@{ name = "environment"; value = "production" })
}
Set-LMServiceInsight -Id 129189 -DeviceMemberFilter $newFilters

### EXAMPLE 2

#Just change the re-evaluation interval
Set-LMServiceInsight -Id 129189 -EvalMembersInterval 1440

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

New description for the Service Insight device.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DeviceMemberFilter

Replaces the Service Insight's device-level membership filters entirely.
Pass the full desired array (see New-LMServiceInsight for the filter
shape) — omitting this parameter leaves existing device filters
untouched; passing an empty array clears them.

```yaml
Type: System.Collections.Hashtable[]
DefaultValue: ''
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

### -DisplayName

New display name for the Service Insight device.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -EvalMembersInterval

Updates how often membership is re-evaluated, in minutes (5, 30, or
1440).

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -HostGroupIds

New device group IDs for the Service Insight device.
Dynamic group IDs
are ignored; this replaces all existing groups (same as Set-LMDevice).

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 7
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

The ID of the Service Insight to update.
Mandatory.

```yaml
Type: System.Int32
DefaultValue: 0
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

### -InstanceMemberFilter

Replaces the Service Insight's instance-level membership filters
entirely, same semantics as -DeviceMemberFilter.

```yaml
Type: System.Collections.Hashtable[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PreferredCollectorId

New preferred collector for the Service Insight device.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 6
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Properties

Additional custom properties to set (besides the predef.bizservice.*
ones this cmdlet manages), merged in with -PropertiesMethod Replace
semantics.

```yaml
Type: System.Collections.Hashtable
DefaultValue: '@{}'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 8
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

### You can pipe objects containing an Id property to this function.

### System.Int32

## OUTPUTS

### Returns a LogicMonitor.Device object for the updated Service Insight.

## NOTES

You must run Connect-LMAccount before running this command.
See New-LMServiceInsight for creating one, Get-LMServiceInsight for
reading current membership.

## RELATED LINKS

