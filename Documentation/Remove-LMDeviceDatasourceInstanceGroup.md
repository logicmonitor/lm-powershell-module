---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Remove-LMDeviceDatasourceInstanceGroup
---

# Remove-LMDeviceDatasourceInstanceGroup

## SYNOPSIS

Removes a LogicMonitor device datasource instance group.

## SYNTAX

### Id-dsName-GroupName (Default)

```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceName <string> -Id <int>
 -InstanceGroupName <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsName-GroupId

```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceName <string> -Name <string>
 -InstanceGroupId <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsName-GroupName

```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceName <string> -Name <string>
 -InstanceGroupName <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsName-GroupId

```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceName <string> -Id <int> -InstanceGroupId <string>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsId-GroupId

```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceId <int> -Name <string> -InstanceGroupId <string>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsId-GroupName

```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceId <int> -Name <string>
 -InstanceGroupName <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsId-GroupId

```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceId <int> -Id <int> -InstanceGroupId <string>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsId-GroupName

```
Remove-LMDeviceDatasourceInstanceGroup -DatasourceId <int> -Id <int> -InstanceGroupName <string>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-HdsId-GroupId

```
Remove-LMDeviceDatasourceInstanceGroup -Id <int> -HdsId <string> -InstanceGroupId <string> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Id-HdsId-GroupName

```
Remove-LMDeviceDatasourceInstanceGroup -Id <int> -HdsId <string> -InstanceGroupName <string>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-HdsId-GroupId

```
Remove-LMDeviceDatasourceInstanceGroup -Name <string> -HdsId <string> -InstanceGroupId <string>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-HdsId-GroupName

```
Remove-LMDeviceDatasourceInstanceGroup -Name <string> -HdsId <string> -InstanceGroupName <string>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Remove-LMDeviceDatasourceInstanceGroup function removes a LogicMonitor device datasource instance group based on the provided parameters.
It requires valid API credentials and a logged-in session.

## EXAMPLES

### EXAMPLE 1

Remove-LMDeviceDatasourceInstanceGroup -DatasourceName "CPU" -Name "Server01" -InstanceGroupName "Group1"
Removes the instance group named "Group1" associated with the "CPU" datasource on the device named "Server01".

### EXAMPLE 2

Remove-LMDeviceDatasourceInstanceGroup -DatasourceId 123 -Id 456 -InstanceGroupName "Group2"
Removes the instance group named "Group2" associated with the datasource ID 123 on the device ID 456.

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

Specifies the ID of the datasource associated with the instance group.
This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-dsId-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsId-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsId-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsId-GroupName
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

Specifies the name of the datasource associated with the instance group.
This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-dsName-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsName-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsName-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsName-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -HdsId

Specifies the ID of the host datasource associated with the instance group.
This parameter is mandatory when using the 'Id-HdsId' or 'Name-HdsId' parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-HdsId-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-HdsId-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-HdsId-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-HdsId-GroupName
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

Specifies the ID of the device associated with the instance group.
This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets.
This parameter can also be specified using the 'DeviceId' alias.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- DeviceId
ParameterSets:
- Name: Id-HdsId-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-HdsId-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsName-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsName-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsId-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsId-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -InstanceGroupId

Specifies the ID of the instance group to be removed.
This parameter is mandatory.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-HdsId-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-HdsId-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsId-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsId-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsName-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsName-GroupId
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

Specifies the name of the instance group to be removed.
This parameter is mandatory.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-HdsId-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-HdsId-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsId-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsId-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsName-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-dsName-GroupName
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

Specifies the name of the device associated with the instance group.
This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets.
This parameter can also be specified using the 'DeviceName' alias.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- DeviceName
ParameterSets:
- Name: Name-HdsId-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-HdsId-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsId-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsId-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsName-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-dsName-GroupName
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

## OUTPUTS

### Returns a PSCustomObject containing the instance ID and a message confirming the successful removal of the instance group.

## NOTES

## RELATED LINKS

