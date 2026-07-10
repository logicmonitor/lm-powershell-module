---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Remove-LMDeviceDatasourceInstance
---

# Remove-LMDeviceDatasourceInstance

## SYNOPSIS

Removes a device datasource instance from Logic Monitor.

## SYNTAX

### Name-dsName

```
Remove-LMDeviceDatasourceInstance -DatasourceName <string> -DeviceName <string>
 [-WildValue <string>] [-InstanceId <int>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsName

```
Remove-LMDeviceDatasourceInstance -DatasourceName <string> -DeviceId <int> [-WildValue <string>]
 [-InstanceId <int>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsId

```
Remove-LMDeviceDatasourceInstance -DatasourceId <int> -DeviceName <string> [-WildValue <string>]
 [-InstanceId <int>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsId

```
Remove-LMDeviceDatasourceInstance -DatasourceId <int> -DeviceId <int> [-WildValue <string>]
 [-InstanceId <int>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Remove-LMDeviceDatasourceInstance function removes a device datasource instance from Logic Monitor.
It requires valid API credentials and the user must be logged in before running this command.

## EXAMPLES

### EXAMPLE 1

Remove-LMDeviceDatasourceInstance -Name "MyDevice" -DatasourceName "MyDatasource" -WildValue "12345"
Removes the device datasource instance with the specified device name, datasource name, and wildcard value.

### EXAMPLE 2

Remove-LMDeviceDatasourceInstance -Id 123 -DatasourceId 456 -WildValue "67890"
Removes the device datasource instance with the specified device ID, datasource ID, and wildcard value.

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

Specifies the ID of the datasource.
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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DatasourceName

Specifies the name of the datasource.
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

### -DeviceId

Specifies the ID of the device.
This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DeviceName

Specifies the name of the device.
This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -InstanceId

Specifies the instance ID.
Can also use the alias Id.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

### -WildValue

Specifies the wildcard value associated with the datasource instance.

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
  ValueFromPipelineByPropertyName: true
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

### System.String

## OUTPUTS

### Returns a PSCustomObject containing the instance ID and a message confirming the successful removal of the datasource instance.

## NOTES

## RELATED LINKS

