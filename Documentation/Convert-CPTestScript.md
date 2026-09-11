---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/11/2026
PlatyPS schema version: 2024-05-01
title: Convert-CPTestScript
---

# Convert-CPTestScript

## SYNOPSIS

Converts a Catchpoint transaction script to another language.

## SYNTAX

### __AllParameterSets

```
Convert-CPTestScript [-Script] <string> [[-ScriptLanguage] <int>] [[-TargetLanguage] <int>]
 [<CommonParameters>]
```

## DESCRIPTION

Convert-CPTestScript converts a script via POST /v4/Tests/scriptconvert.
Only Selenium (1) to Playwright (3) is currently supported.

## EXAMPLES

### EXAMPLE 1

Convert-CPTestScript -Script $seleniumScript

## PARAMETERS

### -Script

Source transaction script.

```yaml
Type: System.String
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

### -ScriptLanguage

ApiTransactionScriptType enum value of the original script format.
Defaults to 1 (Selenium).

```yaml
Type: System.Int32
DefaultValue: 1
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TargetLanguage

ApiTransactionScriptType enum value of the target script format.
Defaults to 3 (Playwright).

```yaml
Type: System.Int32
DefaultValue: 3
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

### You can pipe a script string to this command.

### System.String

## OUTPUTS

### Returns a Catchpoint.Test.ScriptConversion object.

## NOTES

You must run Connect-CPAccount before running this command.

## RELATED LINKS

