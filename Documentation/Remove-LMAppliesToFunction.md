---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Remove-LMAppliesToFunction
---

# Remove-LMAppliesToFunction

## SYNOPSIS

Removes an AppliesTo function from LogicMonitor.

## SYNTAX

### Name

```
Remove-LMAppliesToFunction -Name <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id

```
Remove-LMAppliesToFunction -Id <int> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Remove-LMAppliesToFunction function removes an AppliesTo function from LogicMonitor.
It can be used to remove a function either by its name or its ID.

## EXAMPLES

### EXAMPLE 1

Remove-LMAppliesToFunction -Name "MyAppliesToFunction"
Removes the AppliesTo function with the name "MyAppliesToFunction".

### EXAMPLE 2

Remove-LMAppliesToFunction -Id 12345
Removes the AppliesTo function with the ID 12345.

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

### -Id

Specifies the ID of the AppliesTo function to be removed.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
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

Specifies the name of the AppliesTo function to be removed.
This parameter is mandatory when using the 'Name' parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name
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

### None. You cannot pipe objects to this function.

### System.Int32

## OUTPUTS

### Returns a PSCustomObject containing the ID of the removed AppliesTo function and a success message confirming the removal.

## NOTES

This function requires a valid LogicMonitor API authentication.
Make sure to log in using Connect-LMAccount before running this command.

## RELATED LINKS

