---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Set-LMDeviceGroup
---

# Set-LMDeviceGroup

## SYNOPSIS

Updates a LogicMonitor device group configuration.

## SYNTAX

### Id-ParentGroupId (Default)

```
Set-LMDeviceGroup -Id <string> [-NewName <string>] [-Description <string>] [-Properties <hashtable>]
 [-Extra <Object>] [-DefaultCollectorId <int>] [-DefaultAutoBalancedCollectorGroupId <int>]
 [-DefaultCollectorGroupId <int>] [-PropertiesMethod <string>] [-DisableAlerting <bool>]
 [-EnableNetFlow <bool>] [-AppliesTo <string>] [-ParentGroupId <int>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Id-ParentGroupName

```
Set-LMDeviceGroup -Id <string> [-NewName <string>] [-Description <string>] [-Properties <hashtable>]
 [-Extra <Object>] [-DefaultCollectorId <int>] [-DefaultAutoBalancedCollectorGroupId <int>]
 [-DefaultCollectorGroupId <int>] [-PropertiesMethod <string>] [-DisableAlerting <bool>]
 [-EnableNetFlow <bool>] [-AppliesTo <string>] [-ParentGroupName <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name-ParentGroupName

```
Set-LMDeviceGroup -Name <string> [-NewName <string>] [-Description <string>]
 [-Properties <hashtable>] [-Extra <Object>] [-DefaultCollectorId <int>]
 [-DefaultAutoBalancedCollectorGroupId <int>] [-DefaultCollectorGroupId <int>]
 [-PropertiesMethod <string>] [-DisableAlerting <bool>] [-EnableNetFlow <bool>]
 [-AppliesTo <string>] [-ParentGroupName <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-ParentGroupId

```
Set-LMDeviceGroup -Name <string> [-NewName <string>] [-Description <string>]
 [-Properties <hashtable>] [-Extra <Object>] [-DefaultCollectorId <int>]
 [-DefaultAutoBalancedCollectorGroupId <int>] [-DefaultCollectorGroupId <int>]
 [-PropertiesMethod <string>] [-DisableAlerting <bool>] [-EnableNetFlow <bool>]
 [-AppliesTo <string>] [-ParentGroupId <int>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Set-LMDeviceGroup function modifies an existing device group in LogicMonitor, allowing updates to its name, description, properties, and various other settings.

## EXAMPLES

### EXAMPLE 1

Set-LMDeviceGroup -Id 123 -NewName "Updated Group" -Description "New description"
Updates the device group with ID 123 with a new name and description.

## PARAMETERS

### -AppliesTo

Specifies the applies to expression for the device group.

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

### -DefaultAutoBalancedCollectorGroupId

Specifies the default auto-balanced collector group ID for the device group.

```yaml
Type: System.Nullable`1[System.Int32]
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

### -DefaultCollectorGroupId

Specifies the default collector group ID for the device group.

```yaml
Type: System.Nullable`1[System.Int32]
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

### -DefaultCollectorId

Specifies the default collector ID for the device group.

```yaml
Type: System.Nullable`1[System.Int32]
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

### -Description

Specifies the new description for the device group.

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

### -DisableAlerting

Specifies whether to disable alerting for the device group.

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -EnableNetFlow

Specifies whether to enable NetFlow for the device group.

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -Extra

Specifies a object of extra properties for the device group.
Used for LM Cloud resource groups

```yaml
Type: System.Object
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

Specifies the ID of the device group to modify.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id-ParentGroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-ParentGroupId
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

Specifies the current name of the device group.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-ParentGroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name-ParentGroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NewName

Specifies the new name for the device group.

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

### -ParentGroupId

Specifies the ID of the parent group.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-ParentGroupId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-ParentGroupId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ParentGroupName

Specifies the name of the parent group.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name-ParentGroupName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id-ParentGroupName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Properties

Specifies a hashtable of custom properties for the device group.

```yaml
Type: System.Collections.Hashtable
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

### -PropertiesMethod

Specifies how to handle existing properties.
Valid values are "Add", "Replace", or "Refresh".
Default is "Replace".

```yaml
Type: System.String
DefaultValue: Replace
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

### You can pipe objects containing Id properties to this function.

### System.String

## OUTPUTS

### Returns a LogicMonitor.DeviceGroup object containing the updated group information.

## NOTES

This function requires a valid LogicMonitor API authentication.

## RELATED LINKS

