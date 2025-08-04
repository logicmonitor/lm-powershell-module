---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMCostOptimizationRecommendationCategory

## SYNOPSIS
Retrieves cloud cost optimization recommendation categories from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMCostOptimizationRecommendationCategory [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMCostOptimizationRecommendationCategory [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMCostOptimizationRecommendationCategory function retrieves cloud cost optimization recommendation categories from a connected LogicMonitor portal.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all cost optimization recommendation categories
Get-LMCostOptimizationRecommendationCategory
```

### EXAMPLE 2
```
#Retrieve cost optimization recommendation categories using a filter
Get-LMCostOptimizationRecommendationCategory -Filter 'recommendationCategory -eq "Underutilized AWS EC2 instances"'
```

## PARAMETERS

### -Filter
A filter object to apply when retrieving cost optimization recommendation categories.
Only recommendationCategory and recommendationStatus are supported for filtering using the equals operator all others are not supported at this time.

```yaml
Type: Object
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
The number of results to return per request.
Must be between 1 and 1000.
Defaults to 50.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 50
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### No input is accepted.
## OUTPUTS

### Returns LogicMonitor.CostOptimizationRecommendationCategory objects.
## NOTES
You must run Connect-LMAccount before running this command.
When using filters, consult the LM API docs for allowed filter fields.

## RELATED LINKS
