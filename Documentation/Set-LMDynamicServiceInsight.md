---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/22/2026
PlatyPS schema version: 2024-05-01
title: Set-LMDynamicServiceInsight
---

# Set-LMDynamicServiceInsight

## SYNOPSIS

Updates a LogicMonitor Service Template (dynamic Service Insight rule).

## SYNTAX

### __AllParameterSets

```
Set-LMDynamicServiceInsight [-Id] <string> [[-IsEnabled] <bool>] [[-Name] <string>]
 [[-Description] <string>] [[-Cardinality] <array>] [[-PropertySelector] <array>]
 [[-Properties] <array>] [[-ServiceNamingPattern] <array>] [[-GroupNamingPattern] <array>]
 [[-CreateGroup] <bool>] [[-DefaultCriticality] <string>] [[-MembershipEvaluationInterval] <string>]
 [[-FilterType] <string>] [[-ResourceGroupRecords] <array>] [[-Criticality] <array>]
 [[-StaticGroup] <array>] [[-ManageRuleLevel] <string>] [-WhatIf] [-Confirm]
```

## DESCRIPTION

The Set-LMDynamicServiceInsight function updates an existing Service Template
via /serviceTemplates/updateTemplate.
Unlike Set-LMDevice-style cmdlets,
this endpoint accepts a genuine partial update — only the fields you
specify are sent (plus Id and the model discriminator), and anything
you don't pass is left as-is on the template.

A Service Template is the rule LogicMonitor uses to dynamically spawn
individual Service Insights from a resource property (e.g.
one per
distinct "customer" property value) — this is separate from a static
Service Insight (see New-/Get-/Set-/Remove-LMServiceInsight), which has
a fixed, manually defined membership list instead of a property-driven
rule.

## EXAMPLES

### EXAMPLE 1

#Activate a newly created template
Set-LMDynamicServiceInsight -Id 7 -IsEnabled $true

### EXAMPLE 2

#Change the naming pattern on an active template
Set-LMDynamicServiceInsight -Id 7 -ServiceNamingPattern @("prefix-", "##customer##", "-suffix")

## PARAMETERS

### -Cardinality

Replaces the template's cardinality array entirely (see
New-LMDynamicServiceInsight for the shape).

```yaml
Type: System.Array
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

### -CreateGroup

Whether to create groups for spawned services.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 9
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Criticality

Replaces the criticality array entirely.

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 14
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DefaultCriticality

New default criticality ("Low", "Medium", "High", "Critical" per LM's
usual scale).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 10
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

New description for the template.

```yaml
Type: System.String
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

### -FilterType

New filter type.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 12
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GroupNamingPattern

Replaces the group naming pattern array entirely.

```yaml
Type: System.Array
DefaultValue: ''
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

### -Id

The ID of the Service Template to update.
Mandatory.

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

### -IsEnabled

Enable or disable the template.
A newly created template
(New-LMDynamicServiceInsight) starts disabled — this is how you activate it,
matching LogicMonitor's own UI flow (create, then a separate enable
step).

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -ManageRuleLevel

LogicMonitor's own UI sends "PARTIAL" here when editing an
already-activated template's fields (as opposed to the initial
enable-toggle call, which omits it).
Defaults to "PARTIAL" whenever any
field besides -IsEnabled is being changed; omitted otherwise.
Override
only if you've confirmed a different value is needed.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 16
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MembershipEvaluationInterval

New membership re-evaluation interval, in minutes.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 11
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

New name for the template.

```yaml
Type: System.String
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

### -Properties

Replaces the template's properties array entirely.

```yaml
Type: System.Array
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

### -PropertySelector

Replaces the template's propertySelector array entirely.

```yaml
Type: System.Array
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

### -ResourceGroupRecords

Replaces resourceGroupRecords entirely.

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 13
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ServiceNamingPattern

Replaces the naming pattern array entirely, e.g.
@("prefix-", "##customer##", "-suffix").

```yaml
Type: System.Array
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

### -StaticGroup

Replaces the staticGroup array entirely.

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 15
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

### System.String

## OUTPUTS

### Returns a LogicMonitor.ServiceTemplate object for the updated template.

## NOTES

You must run Connect-LMAccount with -SessionSync before running this
command — this endpoint does not support LMv1 or Bearer auth.
Request shape confirmed via a HAR capture of LogicMonitor's own
dynamic Service Insight creation and editing UI against
/serviceTemplates/updateTemplate.

## RELATED LINKS

