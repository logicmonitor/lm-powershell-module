---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/11/2026
PlatyPS schema version: 2024-05-01
title: Set-CPTestAlertState
---

# Set-CPTestAlertState

## SYNOPSIS

Pauses or unpauses alerts for Catchpoint tests.

## SYNTAX

### Status (Default)

```
Set-CPTestAlertState -Id <long[]> -Status <string> [-PauseExpiration <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Body

```
Set-CPTestAlertState -Body <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Set-CPTestAlertState updates alert pause state via PATCH /v4/Tests/alert/state.
An alert can be paused for a duration with -PauseExpiration.

## EXAMPLES

### EXAMPLE 1

Set-CPTestAlertState -Id 12345 -Status Paused -PauseExpiration "01:00"

### EXAMPLE 2

Get-CPTests -Name "Homepage" | Set-CPTestAlertState -Status Unpaused

## PARAMETERS

### -Body

Full alert state payload with a tests array.
Use instead of the convenience parameters.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Body
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

### -Id

One or more Catchpoint test IDs.

```yaml
Type: System.Int64[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- TestId
ParameterSets:
- Name: Status
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PauseExpiration

Pause duration as HH:MM when Status is Paused.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Status
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Status

Paused (0) or Unpaused (1).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Status
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

### You can pipe Catchpoint.Test objects or objects with an Id property.

### System.Int64[]

## OUTPUTS

### Returns Catchpoint.Test.AlertState objects.

## NOTES

You must run Connect-CPAccount before running this command.

## RELATED LINKS

