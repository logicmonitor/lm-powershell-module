---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Send-EAIEvents
---

# Send-EAIEvents

## SYNOPSIS

Sends events to Edwin for ingestion.

## SYNTAX

### __AllParameterSets

```
Send-EAIEvents [-Events] <Object[]> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Send-EAIEvents posts one or more Common Event Format (CEF) payloads to Edwin.
Use this cmdlet for custom third-party event data.
LogicMonitor alerts are already sent to Edwin natively.

## EXAMPLES

### EXAMPLE 1

$event = @{
    cef = @{
        event_ci = 'server01'
        event_object = 'CPU'
        event_source = 'Meraki'
        event_name = 'High CPU'
        event_description = 'CPU above threshold'
        event_severity = 4
        event_time = (Format-EAIEventTime -DateTime (Get-Date))
        event_id = [guid]::NewGuid().ToString()
        event_domain = ''
        source_record = @{ device = 'server01' }
        class = 'event'
        version = '1.1'
    }
    enrichments = @{}
}
Send-EAIEvents -Events $event

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

### -Events

One or more event objects containing cef and enrichments properties.

```yaml
Type: System.Object[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PassThru

Returns per-event Edwin API acceptance results.

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

### System.Object[]

## OUTPUTS

### By default

## NOTES

LogicMonitor portal authentication is not required for Edwin event ingestion.nn## RELATED LINKS

