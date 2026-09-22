---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/22/2026
PlatyPS schema version: 2024-05-01
title: New-LMInstanceProperty
---

# New-LMInstanceProperty

## SYNOPSIS

Adds a custom property to a LogicMonitor device datasource instance.

## SYNTAX

### Id-dsName (Default)

```
New-LMInstanceProperty -Id <int> -DatasourceName <string> -InstanceName <string>
 -PropertyName <string> -PropertyValue <string> [-WhatIf] [-Confirm]
```

### Id-dsId

```
New-LMInstanceProperty -Id <int> -DatasourceId <int> -InstanceName <string> -PropertyName <string>
 -PropertyValue <string> [-WhatIf] [-Confirm]
```

### Name-dsId

```
New-LMInstanceProperty -Name <string> -DatasourceId <int> -InstanceName <string>
 -PropertyName <string> -PropertyValue <string> [-WhatIf] [-Confirm]
```

### Name-dsName

```
New-LMInstanceProperty -Name <string> -DatasourceName <string> -InstanceName <string>
 -PropertyName <string> -PropertyValue <string> [-WhatIf] [-Confirm]
```

## DESCRIPTION

The New-LMInstanceProperty function adds a custom property to a
specific instance of a datasource on a device (e.g.
one CPU core on a
CPU datasource, one disk on a Disks datasource) - not the device
itself.
Instance-level properties are how Service Insight/Service
Template membership can be scoped to individual instances rather than
whole devices (see the InstanceMemberFilter parameter on
New-/Set-LMServiceInsight, and the instance-level propertySelector on
New-LMDynamicServiceInsight), so tagging instances directly is often what
membership scoping actually needs, not just device-level tags.

Resolves the device and datasource by id or name (matching
Get-LMDeviceDatasourceInstance's own parameter conventions), then finds
the instance by name, then composes Set-LMDeviceDatasourceInstance
-PropertiesMethod Add to add the property without disturbing any
existing instance properties.

## EXAMPLES

### EXAMPLE 1

#Tag a specific CPU core instance with an application property, by device/datasource name
New-LMInstanceProperty -Name "Production-Server" -DatasourceName "CPU" -InstanceName "CPU 0" -PropertyName "application" -PropertyValue "webapp"

### EXAMPLE 2

#Same, by device/datasource id
New-LMInstanceProperty -Id 4767 -DatasourceId 314 -InstanceName "CPU 0" -PropertyName "application" -PropertyValue "webapp"

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

The datasource id (e.g.
from Get-LMDeviceDataSourceList).
Part of a
parameter set alongside -DatasourceName.

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

The datasource name (e.g.
"CPU", "Disks").
Part of a parameter set
alongside -DatasourceId.

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

### -Id

The device id.
Part of a parameter set alongside -Name.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- DeviceId
ParameterSets:
- Name: Id-dsId
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

### -InstanceName

The exact instance name to tag (e.g.
"CPU 0", the wildvalue LogicMonitor
discovered for that instance).
Required.

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

The device name.
Part of a parameter set alongside -Id.

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

### -PropertyName

The property name to add.

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

### -PropertyValue

The property value to set.

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

### Returns a LogicMonitor.DeviceDatasourceInstance object for the updated
instance.

## NOTES

You must run Connect-LMAccount before running this command.
Composes Get-LMDeviceDatasourceInstance and
Set-LMDeviceDatasourceInstance -PropertiesMethod Add rather than
calling the API directly, so device/datasource/instance name lookups
and error handling stay consistent with those cmdlets.

## RELATED LINKS

