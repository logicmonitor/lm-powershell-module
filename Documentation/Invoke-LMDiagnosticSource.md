---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Invoke-LMDiagnosticSource
---

# Invoke-LMDiagnosticSource

## SYNOPSIS

Triggers a diagnostic source execution for a host.

## SYNTAX

### Id-diagnosticId (Default)

```
Invoke-LMDiagnosticSource -Id <int> -DiagnosticId <int> [-AlertId <string>] [<CommonParameters>]
```

### Id-diagnosticName

```
Invoke-LMDiagnosticSource -Id <int> -DiagnosticName <string> [-AlertId <string>]
 [<CommonParameters>]
```

### Name-diagnosticName

```
Invoke-LMDiagnosticSource -Name <string> -DiagnosticName <string> [-AlertId <string>]
 [<CommonParameters>]
```

### Name-diagnosticId

```
Invoke-LMDiagnosticSource -Name <string> -DiagnosticId <int> [-AlertId <string>]
 [<CommonParameters>]
```

### DisplayName-diagnosticName

```
Invoke-LMDiagnosticSource -DisplayName <string> -DiagnosticName <string> [-AlertId <string>]
 [<CommonParameters>]
```

### DisplayName-diagnosticId

```
Invoke-LMDiagnosticSource -DisplayName <string> -DiagnosticId <int> [-AlertId <string>]
 [<CommonParameters>]
```

## DESCRIPTION

The Invoke-LMDiagnosticSource function manually triggers a diagnostic source execution for a
LogicMonitor host.
The host can be identified by ID, name, or display name, and the diagnostic
source can be identified by ID or name.

## EXAMPLES

### EXAMPLE 1

Invoke-LMDiagnosticSource -Id 123 -DiagnosticId 456

Triggers diagnostic source ID 456 on host ID 123.

### EXAMPLE 2

Invoke-LMDiagnosticSource -HostName "server01" -DiagnosticName "Disk Troubleshooter" -AlertId "A123456"

Looks up host and diagnostic source by name, then triggers a diagnostic execution associated with alert A123456.

## PARAMETERS

### -AlertId

Optional alert ID associated with this diagnostic execution.

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

### -DiagnosticId

The diagnostic source ID to execute.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DisplayName-diagnosticId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-diagnosticId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-diagnosticId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DiagnosticName

The diagnostic source name to execute.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DisplayName-diagnosticName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-diagnosticName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-diagnosticName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DisplayName

The host display name to run the diagnostic source against.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- HostDisplayName
- DeviceDisplayName
ParameterSets:
- Name: DisplayName-diagnosticName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DisplayName-diagnosticId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

The host ID to run the diagnostic source against.
Alias: HostId.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- HostId
- DeviceId
ParameterSets:
- Name: Id-diagnosticName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
- Name: Id-diagnosticId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The host name to run the diagnostic source against.
Alias: HostName.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- HostName
- DeviceName
ParameterSets:
- Name: Name-diagnosticName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-diagnosticId
  Position: Named
  IsRequired: true
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

### System.Int32

## OUTPUTS

### Returns LogicMonitor.DiagnosticSourceExecution object.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

