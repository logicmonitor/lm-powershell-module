---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Set-LMNormalizedProperty
---

# Set-LMNormalizedProperty

## SYNOPSIS

Updates normalized properties in LogicMonitor.

## SYNTAX

### Add

```
Set-LMNormalizedProperty -Alias <string> -Add -Properties <array> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Remove

```
Set-LMNormalizedProperty -Alias <string> -Remove -Properties <array> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The Set-LMNormalizedProperty cmdlet updates normalized properties in LogicMonitor.
Normalized properties allow you to map multiple host properties to a single alias that can be used across your environment.

## EXAMPLES

### EXAMPLE 1

Set-LMNormalizedProperty -Add -Alias "location" -Properties @("location", "snmp.sysLocation", "auto.meraki.location")
Updates a normalized property with alias "location" to include the new properties.

### EXAMPLE 2

Set-LMNormalizedProperty -Remove -Alias "location" -Properties @("auto.meraki.location")
Removes the "auto.meraki.location" property from the "location" alias.

## PARAMETERS

### -Add

Indicates that properties should be added to the existing normalized property.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Add
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Alias

The alias name for the normalized property.

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

### -Properties

An array of host property names to map to the alias.

```yaml
Type: System.Array
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

### -Remove

Indicates that properties should be removed from the existing normalized property.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Remove
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

### Returns a message indicating the success of the operation.

## NOTES

This function requires a valid LogicMonitor API authentication and uses API v4.

## RELATED LINKS

