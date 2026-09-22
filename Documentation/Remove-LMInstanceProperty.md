---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/22/2026
PlatyPS schema version: 2024-05-01
title: Remove-LMInstanceProperty
---

# Remove-LMInstanceProperty

## SYNOPSIS

Removes a custom property from a LogicMonitor device datasource instance.

## SYNTAX

### Id-dsName (Default)

```
Remove-LMInstanceProperty -Id <int> -DatasourceName <string> -InstanceName <string>
 -PropertyName <string> [-WhatIf] [-Confirm]
```

### Id-dsId

```
Remove-LMInstanceProperty -Id <int> -DatasourceId <int> -InstanceName <string>
 -PropertyName <string> [-WhatIf] [-Confirm]
```

### Name-dsId

```
Remove-LMInstanceProperty -Name <string> -DatasourceId <int> -InstanceName <string>
 -PropertyName <string> [-WhatIf] [-Confirm]
```

### Name-dsName

```
Remove-LMInstanceProperty -Name <string> -DatasourceName <string> -InstanceName <string>
 -PropertyName <string> [-WhatIf] [-Confirm]
```

## DESCRIPTION

The Remove-LMInstanceProperty function removes a single custom property
from a specific instance of a datasource on a device (e.g.
one CPU core
on a CPU datasource, one disk on a Disks datasource) - not the device
itself.
Complements New-LMInstanceProperty.

There is no per-key delete endpoint for instance properties - the
underlying API only supports replacing the whole customProperties set
(PropertiesMethod "Refresh").
This function reads the instance's current
properties, drops the one matching -PropertyName, and sends the
remaining set back via Set-LMDeviceDatasourceInstance -PropertiesMethod
Refresh, so every other existing instance property is preserved
untouched.

## EXAMPLES

### EXAMPLE 1

#Remove an application property from a specific CPU core instance, by device/datasource name
Remove-LMInstanceProperty -Name "Production-Server" -DatasourceName "CPU" -InstanceName "CPU 0" -PropertyName "application"

### EXAMPLE 2

#Same, by device/datasource id
Remove-LMInstanceProperty -Id 4767 -DatasourceId 314 -InstanceName "CPU 0" -PropertyName "application"

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

The exact instance name to untag (e.g.
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

The property name to remove.

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
Set-LMDeviceDatasourceInstance -PropertiesMethod Refresh rather than
calling the API directly, so device/datasource/instance name lookups
and error handling stay consistent with those cmdlets.
Because the API
has no partial-delete for instance properties, this is a read-then-
refresh-the-rest operation, not a true single-field delete - a race
against a concurrent property write to the same instance is possible in
principle, same limitation Set-LMDeviceDatasourceInstance itself has.

## RELATED LINKS

