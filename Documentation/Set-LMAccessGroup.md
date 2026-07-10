---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Set-LMAccessGroup
---

# Set-LMAccessGroup

## SYNOPSIS

Sets the properties of a LogicMonitor access group.

## SYNTAX

### Id

```
Set-LMAccessGroup [-Id <int>] [-NewName <string>] [-Description <string>] [-Tenant <string>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name

```
Set-LMAccessGroup [-Name <string>] [-NewName <string>] [-Description <string>] [-Tenant <string>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Set-LMAccessGroup function is used to set the properties of a LogicMonitor access group.
It allows you to specify the access group either by its ID or by its name.
You can set the new name, description, and tenant ID for the access group.

## EXAMPLES

### EXAMPLE 1

Set-LMAccessGroup -Id 123 -NewName "New Access Group" -Description "This is a new access group" -Tenant "abc123"
Sets the properties of the access group with ID 123. The new name is set to "New Access Group", the description is set to "This is a new access group", and the tenant ID is set to "abc123".

### EXAMPLE 2

Set-LMAccessGroup -Name "Old Access Group" -NewName "New Access Group" -Description "This is a new access group" -Tenant "abc123"
Sets the properties of the access group with name "Old Access Group". The new name is set to "New Access Group", the description is set to "This is a new access group", and the tenant ID is set to "abc123".

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

### -Description

Specifies the new description for the access group.

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

Specifies the ID of the access group.
This parameter is used when you want to set the properties of the access group by its ID.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

Specifies the name of the access group.
This parameter is used when you want to set the properties of the access group by its name.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NewName

Specifies the new name for the access group.

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

### -Tenant

Specifies the tenant ID for the access group.

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

## NOTES

This function requires you to be logged in and have valid API credentials.
Use the Connect-LMAccount function to log in before running this command.

## RELATED LINKS

