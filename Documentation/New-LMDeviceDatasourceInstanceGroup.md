---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: New-LMDeviceDatasourceInstanceGroup
---

# New-LMDeviceDatasourceInstanceGroup

## SYNOPSIS

Creates a new instance group for a LogicMonitor device datasource.

## SYNTAX

### Name-dsName

```
New-LMDeviceDatasourceInstanceGroup -InstanceGroupName <string> -DatasourceName <string>
 -Name <string> [-Description <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsName

```
New-LMDeviceDatasourceInstanceGroup -InstanceGroupName <string> -DatasourceName <string> -Id <int>
 [-Description <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsId

```
New-LMDeviceDatasourceInstanceGroup -InstanceGroupName <string> -DatasourceId <int> -Name <string>
 [-Description <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsId

```
New-LMDeviceDatasourceInstanceGroup -InstanceGroupName <string> -DatasourceId <int> -Id <int>
 [-Description <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The New-LMDeviceDatasourceInstanceGroup function creates a new instance group for a LogicMonitor device datasource.
It requires the user to be logged in and have valid API credentials.

## EXAMPLES

### EXAMPLE 1

New-LMDeviceDatasourceInstanceGroup -InstanceGroupName "Group1" -Description "Instance group for Device1" -DatasourceName "DataSource1" -Name "Device1"
Creates a new instance group named "Group1" with the description "Instance group for Device1" for the device named "Device1" and the datasource named "DataSource1".

### EXAMPLE 2

New-LMDeviceDatasourceInstanceGroup -InstanceGroupName "Group2" -Description "Instance group for Device2" -DatasourceId 123 -Id 456
Creates a new instance group named "Group2" with the description "Instance group for Device2" for the device with ID 456 and the datasource with ID 123.

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

### -DatasourceId

The ID of the datasource associated with the instance group.
This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DatasourceName

The name of the datasource associated with the instance group.
This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

The description of the instance group.

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

### -Id

The ID of the device associated with the instance group.
This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- DeviceId
ParameterSets:
- Name: Id-dsName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -InstanceGroupName

The name of the instance group to create.
This parameter is mandatory.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -Name

The name of the device associated with the instance group.
This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- DeviceName
ParameterSets:
- Name: Name-dsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsName
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

### Returns LogicMonitor.DeviceDatasourceInstanceGroup object.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

