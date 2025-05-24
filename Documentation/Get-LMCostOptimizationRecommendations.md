---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMCostOptimizationRecommendations

## SYNOPSIS
Retrieves cloud cost optimization recommendations from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMCostOptimizationRecommendations [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Id
```
Get-LMCostOptimizationRecommendations [-Id <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMCostOptimizationRecommendations [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMCostOptimizationRecommendations function retrieves cloud cost optimization recommendations from a connected LogicMonitor portal.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all cost optimization recommendations
Get-LMCostOptimizationRecommendations
```

### EXAMPLE 2
```
#Retrieve cost optimization recommendations using a filter
Get-LMCostOptimizationRecommendations -Filter 'recommendationCategory -eq "Underutilized AWS EC2 instances"'
```

## PARAMETERS

### -Id
The alphanumeric ID of the cost optimization recommendation to retrieve.
Example: 1-2-EBS_UNATTACHED

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A filter object to apply when retrieving cost optimization recommendations.

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

### Returns LogicMonitor.CostOptimizationRecommendations objects.
## NOTES
You must run Connect-LMAccount before running this command.
When using filters, consult the LM API docs for allowed filter fields.

## RELATED LINKS
