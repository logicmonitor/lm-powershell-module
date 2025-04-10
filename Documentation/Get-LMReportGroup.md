---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMReportGroup

## SYNOPSIS
Retrieves report groups from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMReportGroup [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMReportGroup [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMReportGroup [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMReportGroup [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### FilterWizard
```
Get-LMReportGroup [-FilterWizard] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMReportGroup function retrieves report group configurations from LogicMonitor.
It can retrieve all groups, a specific group by ID or name, or filter the results using either a filter object or the filter wizard.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all report groups
Get-LMReportGroup
```

### EXAMPLE 2
```
#Retrieve a specific report group by name
Get-LMReportGroup -Name "Monthly Reports"
```

## PARAMETERS

### -Id
The ID of the specific report group to retrieve.

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
The name of the specific report group to retrieve.

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
A filter object to apply when retrieving report groups.

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
Switch to enable the filter wizard for building a custom filter interactively.

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

### Returns report group objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
