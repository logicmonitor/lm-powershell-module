---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDiagnosticRemediationModule
---

# Get-LMDiagnosticRemediationModule

## SYNOPSIS

Retrieves assigned diagnostic and remediation modules from LogicMonitor.

## SYNTAX

### __AllParameterSets

```
Get-LMDiagnosticRemediationModule [[-ResourceId] <int>] [[-AlertId] <string>]
 [[-ModuleType] <string>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMDiagnosticRemediationModule function lists diagnostic and remediation exchange
modules assigned to a resource or alert.

## EXAMPLES

### EXAMPLE 1

Get-LMDiagnosticRemediationModule -AlertId "DS12345"

### EXAMPLE 2

Get-LMDiagnosticRemediationModule -ResourceId 123 -ModuleType remediation

## PARAMETERS

### -AlertId

The alert ID to list assigned modules for.

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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ModuleType

Filter by module type.
Valid values: diagnostic, remediation.

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

### -ResourceId

The resource (device) ID to list assigned modules for.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
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

### Returns LogicMonitor.DiagnosticRemediationModule objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

