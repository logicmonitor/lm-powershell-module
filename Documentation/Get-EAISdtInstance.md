---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/21/2026
PlatyPS schema version: 2024-05-01
title: Get-EAISdtInstance
---

# Get-EAISdtInstance

## SYNOPSIS

Retrieves calculated or realised Edwin SDT instances.

## SYNTAX

### BySchedule (Default)

```
Get-EAISdtInstance -ScheduleId <string> [-StartTime <datetime>] [-EndTime <datetime>]
 [<CommonParameters>]
```

### ByInstanceId

```
Get-EAISdtInstance -InstanceId <string> [<CommonParameters>]
```

## DESCRIPTION

Get-EAISdtInstance lists downtime instances for a schedule within a time range, or retrieves a
single instance by ID.

## EXAMPLES

### EXAMPLE 1

Get-EAISdtInstance -ScheduleId '97038d1b-648a-4718-b287-33726ed49624'

### EXAMPLE 2

Get-EAISdt -Id $id | Get-EAISdtInstance

### EXAMPLE 3

$instances = Get-EAISdt -Id $id | Get-EAISdtInstance -EndTime (Get-Date).ToUniversalTime().AddDays(30)
$instances | Format-Table instanceId, startTime, endTime, status

### EXAMPLE 4

Get-EAISdtInstance -InstanceId '97038d1b-648a-4718-b287-33726ed49624:2026-07-22T16:00:00.000Z'

## PARAMETERS

### -EndTime

Exclusive range end.
Defaults to seven days after StartTime when omitted.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: BySchedule
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
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
- Name: ByInstanceId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ScheduleId

Schedule ID (UUID).
Required for the BySchedule parameter set unless piping an Edwin.SDT object.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: BySchedule
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StartTime

Inclusive range start.
Defaults to the current UTC time when omitted.

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: BySchedule
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

### You can pipe Edwin.SDT objects (scheduleId)

### System.String

## OUTPUTS

### Returns Edwin.SDT.Instance objects.

## NOTES

Use Connect-EAIAccount before running this command.
Use instance.originalInstanceId.startTime (not the top-level startTime) when creating overrides.
The instanceId property is formatted as scheduleId:isoStartTime for use with Remove-EAISdtOverride.

## RELATED LINKS

