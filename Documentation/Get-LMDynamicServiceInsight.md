---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 09/22/2026
PlatyPS schema version: 2024-05-01
title: Get-LMDynamicServiceInsight
---

# Get-LMDynamicServiceInsight

## SYNOPSIS

Retrieves service template information from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMDynamicServiceInsight
```

### Id

```
Get-LMDynamicServiceInsight -Id <string>
```

## DESCRIPTION

The Get-LMDynamicServiceInsight function retrieves service templates from LogicMonitor.
This function only supports the v4 API.

With no parameters, returns a summary listing of every template (a
fixed, limited set of columns - does not include fields like
cardinality, propertySelector, properties, serviceNamingPattern,
membershipEvaluationInterval, criticality, staticGroup, or
filterType).
Pass -Id to fetch one template's full detail, including
those fields - needed before doing a partial edit of an existing
template (see Set-LMDynamicServiceInsight), since editing anything other
than the isEnabled flag requires resending the complete object.

## EXAMPLES

### EXAMPLE 1

#Retrieve all service templates (summary view)
Get-LMDynamicServiceInsight

### EXAMPLE 2

#Retrieve one template's full detail
Get-LMDynamicServiceInsight -Id 7

## PARAMETERS

### -Id

The ID of a single Service Template to retrieve in full detail.
Part
of a mutually exclusive parameter set; omit to list all templates
(summary view only).

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

### Returns LogicMonitor.ServiceTemplate objects.

## NOTES

You must run Connect-LMAccount before running this command.
This command is reserved for internal use only.

## RELATED LINKS

