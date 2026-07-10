---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Invoke-LMCloudGroupNetScan
---

# Invoke-LMCloudGroupNetScan

## SYNOPSIS

Invokes a NetScan task for a cloud device group.

## SYNTAX

### GroupId

```
Invoke-LMCloudGroupNetScan -Id <string> [<CommonParameters>]
```

### GroupName

```
Invoke-LMCloudGroupNetScan -Name <string> [<CommonParameters>]
```

## DESCRIPTION

The Invoke-LMCloudGroupNetScan function schedules a NetScan task for a specified cloud device group (AWS, Azure, or GCP) in LogicMonitor.

## EXAMPLES

### EXAMPLE 1

#Run NetScan on a cloud group by ID
Invoke-LMCloudGroupNetScan -Id "12345"

### EXAMPLE 2

#Run NetScan on a cloud group by name
Invoke-LMCloudGroupNetScan -Name "AWS-Production"

## PARAMETERS

### -Id

The ID of the cloud device group.
Required for GroupId parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the cloud device group.
Required for GroupName parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: GroupName
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

## OUTPUTS

### Returns a success message if the task is scheduled successfully.

### System.String

## NOTES

You must run Connect-LMAccount before running this command.
The target group must be a cloud group (AWS, Azure, or GCP).

## RELATED LINKS

