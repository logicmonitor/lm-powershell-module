---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMCostOptimizationRecommendationCategory
---

# Get-LMCostOptimizationRecommendationCategory

## SYNOPSIS

Retrieves cloud cost optimization recommendation categories from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMCostOptimizationRecommendationCategory [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMCostOptimizationRecommendationCategory [-Filter <Object>] [-BatchSize <int>]
 [<CommonParameters>]
```

### FilterWizard

```
Get-LMCostOptimizationRecommendationCategory [-FilterWizard] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMCostOptimizationRecommendationCategory function retrieves cloud cost optimization recommendation categories from a connected LogicMonitor portal.

## EXAMPLES

### EXAMPLE 1

#Retrieve all cost optimization recommendation categories
Get-LMCostOptimizationRecommendationCategory

### EXAMPLE 2

#Retrieve cost optimization recommendation categories using a filter
Get-LMCostOptimizationRecommendationCategory -Filter 'recommendationCategory -eq "Underutilized AWS EC2 instances"'

## PARAMETERS

### -BatchSize

The number of results to return per request.
Must be between 1 and 1000.
Defaults to 50.

```yaml
Type: System.Int32
DefaultValue: 50
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

### -Filter

A filter object to apply when retrieving cost optimization recommendation categories.
Only recommendationCategory and recommendationStatus are supported for filtering using the equals operator all others are not supported at this time.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Filter
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FilterWizard

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: FilterWizard
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

### No input is accepted.

## OUTPUTS

### Returns LogicMonitor.CostOptimizationRecommendationCategory objects.

## NOTES

You must run Connect-LMAccount before running this command.
When using filters, consult the LM API docs for allowed filter fields.

## RELATED LINKS

