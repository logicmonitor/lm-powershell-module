---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/22/2026
PlatyPS schema version: 2024-05-01
title: Get-LMServiceInsight
---

# Get-LMServiceInsight

## SYNOPSIS

Retrieves Service Insights from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMServiceInsight [-Raw] [-BatchSize <int>]
```

### Id

```
Get-LMServiceInsight [-Id <int>] [-Raw] [-BatchSize <int>]
```

### Name

```
Get-LMServiceInsight [-Name <string>] [-Raw] [-BatchSize <int>]
```

### DisplayName

```
Get-LMServiceInsight [-DisplayName <string>] [-Raw] [-BatchSize <int>]
```

## DESCRIPTION

A Service Insight is a LogicMonitor device with DeviceType 6, whose
membership (which devices/instances feed it) is defined by a
"predef.bizservice.members" custom property.
Get-LMServiceInsight wraps
Get-LMDevice filtered to deviceType 6, and (unless -Raw is specified)
parses the predef.bizservice.* custom properties into readable
DeviceMemberFilter / InstanceMemberFilter / EvalMembersInterval
properties on the returned object, so the membership definition doesn't
have to be manually pulled out of a nested JSON string.

## EXAMPLES

### EXAMPLE 1

#List every Service Insight in the portal
Get-LMServiceInsight

### EXAMPLE 2

#Get one Service Insight by id, with parsed membership filters
Get-LMServiceInsight -Id 129189

### EXAMPLE 3

#Get by display name
Get-LMServiceInsight -DisplayName "WebApp Prod"

## PARAMETERS

### -BatchSize

The number of results to return per request.
Must be between 1 and 1000.
Defaults to 1000.

```yaml
Type: System.Int32
DefaultValue: 1000
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

The display name of the Service Insight to retrieve.
Part of a mutually
exclusive parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DisplayName
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

The ID of the Service Insight to retrieve.
Part of a mutually exclusive
parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The (internal) name of the Service Insight to retrieve.
Part of a
mutually exclusive parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Raw

Skip parsing predef.bizservice.* properties; return the plain
LogicMonitor.Device object as Get-LMDevice would, with all other
Service Insights included unfiltered by name/id/displayName.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns LogicMonitor.Device objects. Unless -Raw is specified

## NOTES

You must run Connect-LMAccount before running this command.
See New-LMServiceInsight for creating one.

## RELATED LINKS

