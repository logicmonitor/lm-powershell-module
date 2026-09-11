---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/11/2026
PlatyPS schema version: 2024-05-01
title: New-CPInstantTest
---

# New-CPInstantTest

## SYNOPSIS

Runs a new Catchpoint instant test.

## SYNTAX

### Body (Default)

```
New-CPInstantTest -Body <Object> [-OnDemand] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Simple

```
New-CPInstantTest -Url <string> -NodeId <long[]> [-InstantTestType <int>] [-MonitorType <int>]
 [-OnDemand] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

New-CPInstantTest creates and runs an instant test via POST /v4/InstantTests.
Supply a full payload with -Body, or a URL and node IDs for a simple run.
The response contains the instant test ID and node status, not result data.
Use Get-CPInstantTest to retrieve results after the run completes.

## EXAMPLES

### EXAMPLE 1

New-CPInstantTest -Url "https://example.com" -NodeId 1, 2

### EXAMPLE 2

$config = Get-CPInstantTestConfiguration -Id 0
New-CPInstantTest -Body $config.instantTest -OnDemand

## PARAMETERS

### -Body

Instant test payload.
Accepts a hashtable, PSCustomObject, or JSON string.
Get a sample payload from Get-CPInstantTestConfiguration -Id 0.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Body
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
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

### -InstantTestType

Catchpoint instant test type ID.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Simple
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MonitorType

Catchpoint monitor type ID.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Simple
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NodeId

One or more node IDs to run the instant test from.
Maximum of five nodes.

```yaml
Type: System.Int64[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Simple
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OnDemand

Run the instant test from public nodes instead of enterprise nodes.

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

### -Url

Target URL for a simple instant test.
Used when -Body is not supplied.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Simple
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

### You can pipe an instant test payload to this command.

### System.Object

## OUTPUTS

### Returns a Catchpoint.InstantTest object.

## NOTES

You must run Connect-CPAccount before running this command.
An instant test can run from up to five nodes.

## RELATED LINKS

