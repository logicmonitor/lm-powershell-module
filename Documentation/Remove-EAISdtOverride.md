---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/21/2026
PlatyPS schema version: 2024-05-01
title: Remove-EAISdtOverride
---

# Remove-EAISdtOverride

## SYNOPSIS

Removes an Edwin SDT instance override.

## SYNTAX

### __AllParameterSets

```
Remove-EAISdtOverride [[-InputObject] <Object>] [[-InstanceId] <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Remove-EAISdtOverride deletes an override and restores the calculated instance behavior.

The DELETE path uses the canonical original instance identity (`scheduleId:isoStartTime`), not
the rescheduled newStartTime.
Pipe objects from Get-EAISdtInstance or from a schedule's
overrides array returned by Get-EAISdt.

## EXAMPLES

### EXAMPLE 1

Remove-EAISdtOverride -InstanceId '97038d1b-648a-4718-b287-33726ed49624:2026-07-22T16:00:00.000Z'

### EXAMPLE 2

Get-EAISdtInstance -ScheduleId $id | Where-Object { $_.instanceId -like '*2026-07-22T16:00:00.000Z*' } |
    Remove-EAISdtOverride

### EXAMPLE 3

# Remove one stored override (originalInstanceId.startTime may be epoch seconds from the API)
(Get-EAISdt -Id $id).overrides | Select-Object -First 1 | Remove-EAISdtOverride

### EXAMPLE 4

# Preview removals before deleting orphaned overrides
(Get-EAISdt -Id $id).overrides | Remove-EAISdtOverride -WhatIf

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

An Edwin.SDT.Instance, a schedule override object from Get-EAISdt, or any object with
instanceId or originalInstanceId properties.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -InstanceId

Instance ID in the format scheduleId:isoStartTime.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
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

### You can pipe Edwin.SDT.Instance objects

### System.Object

### System.String

## OUTPUTS

### None.

## NOTES

Use Connect-EAIAccount before running this command.
To remove all overrides at once, use Set-EAISdtOverride -ScheduleId $id -Override @().

## RELATED LINKS

