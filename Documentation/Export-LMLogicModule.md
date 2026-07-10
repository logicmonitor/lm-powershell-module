---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Export-LMLogicModule
---

# Export-LMLogicModule

## SYNOPSIS

Exports LogicMonitor LogicModules for backup or transfer.

## SYNTAX

### Id (Default)

```
Export-LMLogicModule -LogicModuleId <int> -Type <string> [-DownloadPath <string>]
 [<CommonParameters>]
```

### Name

```
Export-LMLogicModule -LogicModuleName <string> -Type <string> [-DownloadPath <string>]
 [<CommonParameters>]
```

## DESCRIPTION

The Export-LMLogicModule function exports LogicModules from LogicMonitor.
It supports exporting various types of modules including datasources, property rules, event sources, and more.

## EXAMPLES

### EXAMPLE 1

#Export a LogicModule by ID
Export-LMLogicModule -LogicModuleId 1907 -Type "eventsources"

### EXAMPLE 2

#Export a LogicModule by name
Export-LMLogicModule -LogicModuleName "SNMP_Network_Interfaces" -Type "datasources"

## PARAMETERS

### -DownloadPath

The path where the exported LogicModule will be saved.
Defaults to current directory.

```yaml
Type: System.String
DefaultValue: (Get-Location).Path
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

### -LogicModuleId

The ID of the LogicModule to export.
This parameter is mandatory when using the Id parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- Id
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

### -LogicModuleName

The name of the LogicModule to export.
This parameter is mandatory when using the Name parameter set.

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

### -Type

The type of LogicModule to export.
Valid values are: "datasources", "propertyrules", "eventsources", "topologysources", "configsources", "logsources", "functions", "oids".

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

### System.Int32

## OUTPUTS

### Returns a success message if the export is completed successfully.

### System.String

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

