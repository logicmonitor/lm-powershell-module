---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAppliesToFunction

## SYNOPSIS
Retrieves AppliesTo functions from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMAppliesToFunction [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMAppliesToFunction [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name
```
Get-LMAppliesToFunction [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMAppliesToFunction [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMAppliesToFunction function retrieves AppliesTo functions from LogicMonitor based on specified criteria.
These functions are used in LogicModule configurations to determine which devices they apply to.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve an AppliesTo function by ID
Get-LMAppliesToFunction -Id 123
```

### EXAMPLE 2
```
#Retrieve an AppliesTo function by name
Get-LMAppliesToFunction -Name "MyFunction"
```

### EXAMPLE 3
```
#Retrieve AppliesTo functions using a filter
Get-LMAppliesToFunction -Filter $filterObject
```

## PARAMETERS

### -Id
The ID of the AppliesTo function to retrieve.
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
The name of the AppliesTo function to retrieve.
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
A filter object to apply when retrieving functions.
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

### Returns LogicMonitor.AppliesToFunction objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
