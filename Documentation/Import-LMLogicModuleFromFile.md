---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Import-LMLogicModuleFromFile
---

# Import-LMLogicModuleFromFile

## SYNOPSIS

Imports a LogicModule into LogicMonitor using the V2 import endpoints.

## SYNTAX

### FilePath

```
Import-LMLogicModuleFromFile -FilePath <string> [-Type <string>] [-Format <string>]
 [-FieldsToPreserve <string>] [-HandleConflict <string>] [<CommonParameters>]
```

### File

```
Import-LMLogicModuleFromFile -File <Object> [-Type <string>] [-Format <string>]
 [-FieldsToPreserve <string>] [-HandleConflict <string>] [<CommonParameters>]
```

## DESCRIPTION

The Import-LMLogicModuleFromFile function imports a LogicModule from a file path or file data using the new XML and JSON import endpoints.
Supports various module types including datasources, configsources, eventsources, batchjobs, logsources, oids, topologysources, functions, and diagnosticsources.

## EXAMPLES

### EXAMPLE 1

#Import a datasource module from XML
Import-LMLogicModuleFromFile -FilePath "C:\LogicModules\datasource.xml" -Type "datasources" -Format "xml"

### EXAMPLE 2

#Import a logsource module from JSON with conflict handling
Import-LMLogicModuleFromFile -FilePath "C:\LogicModules\logsource.json" -Type "logsources" -Format "json" -HandleConflict "FORCE_OVERWRITE"

### EXAMPLE 3

#Import an eventsource from file data (read file content first with -Raw parameter)
$fileData = Get-Content -Path "C:\LogicModules\eventsource.xml" -Raw
Import-LMLogicModuleFromFile -File $fileData -Type "eventsources" -Format "xml"

### EXAMPLE 4

#Import with fields to preserve
Import-LMLogicModuleFromFile -FilePath "C:\LogicModules\datasource.json" -Type "datasources" -Format "json" -FieldsToPreserve "description,appliesTo"

## PARAMETERS

### -FieldsToPreserve

Optional.
Comma-separated list of fields to preserve during import.
Only applies to JSON imports.
Defaults to preserving none of the fields.
Valid values are "NAME", "APPLIES_TO_SCRIPT", "COLLECTION_INTERVAL", "ACTIVE_DISCOVERY_INTERVAL", "ACTIVE_DISCOVERY_FILTERS", "MODULE_GROUP", "DISPLAY_NAME", "USE_WILD_VALUE_AS_UUID", "DATAPOINT_ALERT_THRESHOLDS", "TAGS".
"NAME" will preserve the name of the LogicModule.
"APPLIES_TO_SCRIPT" will preserve the appliesToScript of the LogicModule.
"COLLECTION_INTERVAL" will preserve the collectionInterval of the LogicModule.
"ACTIVE_DISCOVERY_INTERVAL" will preserve the activeDiscoveryInterval of the LogicModule.
"ACTIVE_DISCOVERY_FILTERS" will preserve the activeDiscoveryFilters of the LogicModule.
"MODULE_GROUP" will preserve the moduleGroup of the LogicModule.
"DISPLAY_NAME" will preserve the displayName of the LogicModule.
"USE_WILD_VALUE_AS_UUID" will preserve the useWildValueAsUuid of the LogicModule.
"DATAPOINT_ALERT_THRESHOLDS" will preserve the datapointAlertThresholds of the LogicModule.
"TAGS" will preserve the tags of the LogicModule.

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

### -File

The raw file content of the LogicModule to import as a string.
Use Get-Content with -Raw parameter to read file content properly (e.g., Get-Content 'file.json' -Raw).

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
The function will read the file content automatically.

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

### -Format

The format of the LogicModule file.
Valid values are "xml" or "json".
Defaults to "json".

```yaml
Type: System.String
DefaultValue: json
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

### -HandleConflict

Optional.
Specifies how to handle conflicts during import.
Only applies to JSON imports.
Defaults to "FORCE_OVERWRITE".
Valid values are "FORCE_OVERWRITE" or "ERROR".
"FORCE_OVERWRITE" will overwrite the existing LogicModule with the same name.
"ERROR" will throw an error if a conflict is found.

```yaml
Type: System.String
DefaultValue: FORCE_OVERWRITE
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
Valid values are "datasources", "configsources", "eventsources", "batchjobs", "logsources", "oids", "topologysources", "functions", "diagnosticsources".
Defaults to "datasources".

```yaml
Type: System.String
DefaultValue: datasources
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

You must run Connect-LMAccount before running this command.
Requires PowerShell version 6.1 or higher.

Note: Some module types only support specific formats:
- logsources, oids, functions, diagnosticsources: JSON only
- Other types: Both XML and JSON supported

## RELATED LINKS

