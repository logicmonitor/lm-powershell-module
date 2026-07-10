---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Import-LMLogicModule
---

# Import-LMLogicModule

## SYNOPSIS

[DEPRECATED] Imports a LogicModule into LogicMonitor using legacy endpoints.

## SYNTAX

### FilePath

```
Import-LMLogicModule -FilePath <string> [-Type <string>] [-ForceOverwrite <bool>]
 [<CommonParameters>]
```

### File

```
Import-LMLogicModule -File <Object> [-Type <string>] [-ForceOverwrite <bool>] [<CommonParameters>]
```

## DESCRIPTION

DEPRECATED: This function uses legacy import endpoints and will be removed in a future version.
Please use Import-LMLogicModuleFromFile instead, which uses the newer XML/JSON import endpoints with better error handling and additional features.

The Import-LMLogicModule function imports a LogicModule from a file path or file data.
Supports various module types including datasource, propertyrules, eventsource, topologysource, configsource, logsource, functions, and oids.

## EXAMPLES

### EXAMPLE 1

#Import a datasource module
Import-LMLogicModule -FilePath "C:\LogicModules\datasource.xml" -Type "datasource" -ForceOverwrite $true

### EXAMPLE 2

#Import a property rules module
Import-LMLogicModule -File $fileData -Type "propertyrules"

## PARAMETERS

### -File

The file data of the LogicModule to import.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: File
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FilePath

The path to the file containing the LogicModule to import.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: FilePath
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ForceOverwrite

Whether to overwrite an existing LogicModule with the same name.
Defaults to $false.

```yaml
Type: System.Boolean
DefaultValue: False
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

### -Type

The type of LogicModule.
Valid values are "datasource", "propertyrules", "eventsource", "topologysource", "configsource", "logsource", "functions", "oids".
Defaults to "datasource".

```yaml
Type: System.String
DefaultValue: datasource
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns a success message if the import is successful.

### System.String

## NOTES

DEPRECATED: This cmdlet will be removed in a future version.
Use Import-LMLogicModuleFromFile instead.

You must run Connect-LMAccount before running this command.
Requires PowerShell version 6.1 or higher.

## RELATED LINKS

