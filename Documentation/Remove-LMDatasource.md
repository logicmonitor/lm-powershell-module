---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Remove-LMDatasource
---

# Remove-LMDatasource

## SYNOPSIS

Removes a LogicMonitor datasource.

## SYNTAX

### Id (Default)

```
Remove-LMDatasource -Id <int> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name

```
Remove-LMDatasource -Name <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### DisplayName

```
Remove-LMDatasource -DisplayName <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Remove-LMDatasource function removes a LogicMonitor datasource based on the specified parameters.
It requires the user to be logged in and have valid API credentials.

## EXAMPLES

### EXAMPLE 1

Remove-LMDatasource -Id 123
Removes the datasource with the ID 123.

### EXAMPLE 2

Remove-LMDatasource -Name "MyDatasource"
Removes the datasource with the name "MyDatasource".

### EXAMPLE 3

Remove-LMDatasource -DisplayName "My Datasource"
Removes the datasource with the display name "My Datasource".

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

### -DisplayName

Specifies the display name of the datasource to be removed.
This parameter is mandatory when using the 'DisplayName' parameter set and can be provided as a string.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DisplayName
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

Specifies the ID of the datasource to be removed.
This parameter is mandatory and can be provided as an integer.

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

Specifies the name of the datasource to be removed.
This parameter is mandatory when using the 'Name' parameter set and can be provided as a string.

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

### You can pipe input to this function.

### System.Int32

## OUTPUTS

### Returns a PSCustomObject containing the ID of the removed datasource and a success message confirming the removal.

## NOTES

## RELATED LINKS

