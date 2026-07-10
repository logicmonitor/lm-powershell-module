---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Invoke-LMRemediationSource
---

# Invoke-LMRemediationSource

## SYNOPSIS

Triggers a remediation source execution for a host.

## SYNTAX

### Id-remediationId (Default)

```
Invoke-LMRemediationSource -Id <int> -RemediationId <int> [-AlertId <string>] [<CommonParameters>]
```

### Id-remediationName

```
Invoke-LMRemediationSource -Id <int> -RemediationName <string> [-AlertId <string>]
 [<CommonParameters>]
```

### Name-remediationName

```
Invoke-LMRemediationSource -Name <string> -RemediationName <string> [-AlertId <string>]
 [<CommonParameters>]
```

### Name-remediationId

```
Invoke-LMRemediationSource -Name <string> -RemediationId <int> [-AlertId <string>]
 [<CommonParameters>]
```

### DisplayName-remediationName

```
Invoke-LMRemediationSource -DisplayName <string> -RemediationName <string> [-AlertId <string>]
 [<CommonParameters>]
```

### DisplayName-remediationId

```
Invoke-LMRemediationSource -DisplayName <string> -RemediationId <int> [-AlertId <string>]
 [<CommonParameters>]
```

## DESCRIPTION

The Invoke-LMRemediationSource function manually triggers a remediation source execution for a
LogicMonitor host.
The host can be identified by ID, name, or display name, and the remediation
source can be identified by ID or name.

## EXAMPLES

### EXAMPLE 1

Invoke-LMRemediationSource -Id 123 -RemediationId 456

Triggers remediation source ID 456 on host ID 123.

### EXAMPLE 2

Invoke-LMRemediationSource -HostName "server01" -RemediationName "Restart Agent" -AlertId "A123456"

Looks up host and remediation source by name, then triggers a remediation execution associated with alert A123456.

## PARAMETERS

### -AlertId

Optional alert ID associated with this remediation execution.

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

### -DisplayName

The host display name to run the remediation source against.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- HostDisplayName
- DeviceDisplayName
ParameterSets:
- Name: DisplayName-remediationName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DisplayName-remediationId
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

The host ID to run the remediation source against.
Alias: HostId.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- HostId
- DeviceId
ParameterSets:
- Name: Id-remediationName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
- Name: Id-remediationId
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

The host name to run the remediation source against.
Alias: HostName.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- HostName
- DeviceName
ParameterSets:
- Name: Name-remediationName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-remediationId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RemediationId

The remediation source ID to execute.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DisplayName-remediationId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-remediationId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-remediationId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RemediationName

The remediation source name to execute.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DisplayName-remediationName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-remediationName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-remediationName
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

### Returns LogicMonitor.RemediationSourceExecution object.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

