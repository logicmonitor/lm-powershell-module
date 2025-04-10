---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMCollector

## SYNOPSIS
Retrieves LogicMonitor collectors.

## SYNTAX

### All (Default)
```
Get-LMCollector [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMCollector [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMCollector [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Filter
```
Get-LMCollector [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### FilterWizard
```
Get-LMCollector [-FilterWizard] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMCollector function retrieves collector information from LogicMonitor.
It can return a single collector by ID or name, or multiple collectors using filters or the filter wizard.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve a collector by ID
Get-LMCollector -Id 123
```

### EXAMPLE 2
```
#Retrieve collectors using the filter wizard
Get-LMCollector -FilterWizard
```

## PARAMETERS

### -Id
The ID of the collector to retrieve.
Part of a mutually exclusive parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the collector to retrieve.
Part of a mutually exclusive parameter set.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A filter object to apply when retrieving collectors.
Part of a mutually exclusive parameter set.

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

### -FilterWizard
Switch to use the filter wizard interface for building the filter.
Part of a mutually exclusive parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: FilterWizard
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
The number of results to return per request.
Must be between 1 and 1000.
Defaults to 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns LogicMonitor.Collector objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
