---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMCostOptimizationRecommendation
---

# Get-LMCostOptimizationRecommendation

## SYNOPSIS

Retrieves cloud cost optimization recommendations from LogicMonitor.

## SYNTAX

### All (Default)

```
Get-LMCostOptimizationRecommendation [-BatchSize <int>] [<CommonParameters>]
```

### Id

```
Get-LMCostOptimizationRecommendation [-Id <string>] [-BatchSize <int>] [<CommonParameters>]
```

### Filter

```
Get-LMCostOptimizationRecommendation [-Filter <Object>] [-BatchSize <int>] [<CommonParameters>]
```

### FilterWizard

```
Get-LMCostOptimizationRecommendation [-FilterWizard] [-BatchSize <int>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMCostOptimizationRecommendation function retrieves cloud cost optimization recommendations from a connected LogicMonitor portal.

## EXAMPLES

### EXAMPLE 1

#Retrieve all cost optimization recommendations
Get-LMCostOptimizationRecommendation

### EXAMPLE 2

#Retrieve cost optimization recommendations using a filter
Get-LMCostOptimizationRecommendation -Filter 'recommendationCategory -eq "Underutilized AWS EC2 instances"'

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

A filter object to apply when retrieving cost optimization recommendations.

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

### -Id

The alphanumeric ID of the cost optimization recommendation to retrieve.
Example: 1-2-EBS_UNATTACHED

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
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

### Returns LogicMonitor.CostOptimizationRecommendations objects.

## NOTES

You must run Connect-LMAccount before running this command.
When using filters, consult the LM API docs for allowed filter fields.

## RELATED LINKS

