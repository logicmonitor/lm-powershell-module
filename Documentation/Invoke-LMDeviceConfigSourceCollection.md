---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Invoke-LMDeviceConfigSourceCollection
---

# Invoke-LMDeviceConfigSourceCollection

## SYNOPSIS

Invokes configuration collection for a device datasource.

## SYNTAX

### Name-dsName

```
Invoke-LMDeviceConfigSourceCollection -DatasourceName <string> -Name <string> -InstanceId <string>
 [<CommonParameters>]
```

### Id-dsName

```
Invoke-LMDeviceConfigSourceCollection -DatasourceName <string> -Id <int> -InstanceId <string>
 [<CommonParameters>]
```

### Name-dsId

```
Invoke-LMDeviceConfigSourceCollection -DatasourceId <int> -Name <string> -InstanceId <string>
 [<CommonParameters>]
```

### Id-dsId

```
Invoke-LMDeviceConfigSourceCollection -DatasourceId <int> -Id <int> -InstanceId <string>
 [<CommonParameters>]
```

### Id-HdsId

```
Invoke-LMDeviceConfigSourceCollection -Id <int> -HdsId <string> -InstanceId <string>
 [<CommonParameters>]
```

### Name-HdsId

```
Invoke-LMDeviceConfigSourceCollection -Name <string> -HdsId <string> -InstanceId <string>
 [<CommonParameters>]
```

## DESCRIPTION

The Invoke-LMDeviceConfigSourceCollection function triggers configuration collection for a specified device datasource instance.

## EXAMPLES

### EXAMPLE 1

#Collect config using datasource name
Invoke-LMDeviceConfigSourceCollection -Name "Device1" -DatasourceName "Config" -InstanceId "123"

### EXAMPLE 2

#Collect config using datasource ID
Invoke-LMDeviceConfigSourceCollection -Id 456 -DatasourceId 789 -InstanceId "123"

## PARAMETERS

### -DatasourceId

The ID of the datasource.
Required for dsId parameter sets.

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

The name of the datasource.
Required for dsName parameter sets.

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

### -HdsId

The host datasource ID.
Required for HdsId parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-HdsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-HdsId
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

The ID of the device.
Required for Id parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id-HdsId
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

### -InstanceId

The ID of the datasource instance.

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

The name of the device.
Required for Name parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-HdsId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns a success message if the collection is scheduled successfully.

### System.String

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

