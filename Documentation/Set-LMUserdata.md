---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Set-LMUserdata
---

# Set-LMUserdata

## SYNOPSIS

Sets userdata for a LogicMonitor user, currently only setting the default dashboard is supported.

## SYNTAX

### Id (Default)

```
Set-LMUserdata -Id <string> -DashboardId <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name

```
Set-LMUserdata -Name <string> -DashboardId <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Set-LMUserdata function is used to set the user data for a LogicMonitor user.
It allows you to specify the user by either their Id or Name, and the dashboard Id for which the user data should be set.

## EXAMPLES

### EXAMPLE 1

Set-LMUserdata -Id "12345" -DashboardId "67890"
Sets the user data for the user with Id "12345" for the dashboard with Id "67890".

### EXAMPLE 2

Set-LMUserdata -Name "JohnDoe" -DashboardId "67890"
Sets the user data for the user with Name "JohnDoe" for the dashboard with Id "67890".

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

### -DashboardId

Specifies the Id of the dashboard for which the user data should be set.
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

### -Id

Specifies the Id of the user.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: System.String
DefaultValue: ''
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

Specifies the Name of the user.
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

## OUTPUTS

### Returns the response from the LogicMonitor API.

## NOTES

This function requires a valid API authentication.
Make sure you are logged in before running any commands using Connect-LMAccount.

## RELATED LINKS

