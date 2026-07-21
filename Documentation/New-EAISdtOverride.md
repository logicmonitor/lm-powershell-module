---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/21/2026
PlatyPS schema version: 2024-05-01
title: New-EAISdtOverride
---

# New-EAISdtOverride

## SYNOPSIS

Adds an override to a single Edwin SDT instance.

## SYNTAX

### Adjust (Default)

```
New-EAISdtOverride [-InputObject <Object>] [-ScheduleId <string>] [-OriginalStartTime <Object>]
 [-NewStartTime <Object>] [-NewEndTime <Object>] [-Summary <string>] [-PassThru] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Skip

```
New-EAISdtOverride [-InputObject <Object>] [-ScheduleId <string>] [-OriginalStartTime <Object>]
 [-Skip] [-Summary <string>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

New-EAISdtOverride skips or reschedules one occurrence of a schedule without changing the
underlying schedule definition.

Use -Skip to skip an instance.
Use -NewStartTime and -NewEndTime to reschedule it.

## EXAMPLES

### EXAMPLE 1

$instances = Get-EAISdt -Id $id | Get-EAISdtInstance
$instances | Where-Object { $_.instanceId -like '*2026-07-22T16:00:00.000Z*' } |
    New-EAISdtOverride -Skip -Summary 'Holiday'

### EXAMPLE 2

$instance = Get-EAISdt -Id $id | Get-EAISdtInstance |
    Where-Object { $_.instanceId -like '*2026-07-22T16:00:00.000Z*' }
$instance | New-EAISdtOverride `
    -NewStartTime $instance.originalInstanceId.startTime `
    -NewEndTime $instance.originalInstanceId.startTime.AddHours(4)

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

### -InputObject

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NewEndTime

New end time for an adjusted instance.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Adjust
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NewStartTime

New start time for an adjusted instance.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Adjust
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OriginalStartTime

Canonical original instance start time.
Used with -ScheduleId when not piping an instance.

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

### -PassThru

Re-fetches and returns the parent schedule after the override is added.

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

### -ScheduleId

Schedule ID (UUID).
Optional when piping an Edwin.SDT.Instance object.

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

### -Skip

Skips the selected instance.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Skip
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Summary

Optional note stored with the override.

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

### You can pipe Edwin.SDT.Instance objects from Get-EAISdtInstance.

### System.Object

## OUTPUTS

### None by default. With -PassThru

## NOTES

Always pipe or filter to the specific instance you intend to change.
Derive -NewStartTime and -NewEndTime from the
piped instance, not from Get-Date.

Use instance.originalInstanceId.startTime as the canonical original start time.
The instanceId property is formatted as scheduleId:isoStartTime for use with Remove-EAISdtOverride.

## RELATED LINKS

