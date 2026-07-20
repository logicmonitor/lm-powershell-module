---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Convert-EAIEvent
---

# Convert-EAIEvent

## SYNOPSIS

Converts third-party objects into Edwin CEF event payloads.

## SYNTAX

### __AllParameterSets

```
Convert-EAIEvent [-InputObject] <Object> [-PropertyMap] <hashtable> [[-SeverityMap] <hashtable>]
 [[-DefaultEventSource] <string>] [<CommonParameters>]
```

## DESCRIPTION

Convert-EAIEvent maps arbitrary input objects to Edwin CEF payloads using a property map.
Map values can be source property names or scriptblocks for computed values.

## EXAMPLES

### EXAMPLE 1

$data | Convert-EAIEvent -PropertyMap @{
    event_ci = 'HostName'
    event_name = 'AlertTitle'
    event_description = 'Details'
    event_object = 'Component'
    event_severity = 'Severity'
    event_source = { 'VendorX' }
}

## PARAMETERS

### -DefaultEventSource

Optional default event_source value when not mapped.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -InputObject

The third-party object to convert.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PropertyMap

Hashtable mapping CEF field names to source property names or scriptblocks.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SeverityMap

Optional hashtable mapping vendor severity aliases to Edwin severity names or values.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
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

### System.Object

## OUTPUTS

### PSCustomObject with cef and enrichments properties.

## NOTES

## RELATED LINKS

