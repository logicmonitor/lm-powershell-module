---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/21/2026
PlatyPS schema version: 2024-05-01
title: Set-EAISdtOverride
---

# Set-EAISdtOverride

## SYNOPSIS

Replaces all overrides on an Edwin SDT schedule.

## SYNTAX

### Replace (Default)

```
Set-EAISdtOverride -ScheduleId <string> -Override <Object[]> [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Clear

```
Set-EAISdtOverride -ScheduleId <string> -Clear [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Set-EAISdtOverride replaces the entire overrides list on a schedule.
Prefer New-EAISdtOverride and
Remove-EAISdtOverride for single-instance changes.

## EXAMPLES

### EXAMPLE 1

Set-EAISdtOverride -ScheduleId $id -Clear

### EXAMPLE 2

Set-EAISdtOverride -ScheduleId $id -Override @()

### EXAMPLE 3

# Replace with a single skip override
Set-EAISdtOverride -ScheduleId $id -Override @(
    @{
        originalInstanceId = @{
            scheduleId = $id
            startTime  = '2026-07-21T16:00:00.000Z'
        }
        status  = 'SKIPPED'
        summary = 'bulk skip'
    }
)

## PARAMETERS

### -Clear

Removes all overrides from the schedule.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Clear
  Position: Named
  IsRequired: true
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

### -Override

One or more override objects to store on the schedule.
Use with an empty array (@()) or -Clear to
remove all overrides.

```yaml
Type: System.Object[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Replace
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PassThru

Re-fetches and returns the updated schedule.

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

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
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

### None by default. With -PassThru

## NOTES

Use Connect-EAIAccount before running this command.
This cmdlet calls PUT /action/sdt/{scheduleId}/override and replaces all existing overrides.
Use -Clear or -Override @() to clear every override when the UI cannot delete orphaned entries.

## RELATED LINKS

