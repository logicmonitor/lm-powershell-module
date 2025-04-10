---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDashboardGroup

## SYNOPSIS
Retrieves dashboard groups from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMDashboardGroup [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMDashboardGroup [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name
```
Get-LMDashboardGroup [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ParentId
```
Get-LMDashboardGroup [-ParentGroupId <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ParentName
```
Get-LMDashboardGroup [-ParentGroupName <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMDashboardGroup [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### FilterWizard
```
Get-LMDashboardGroup [-FilterWizard] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDashboardGroup function retrieves dashboard group information from LogicMonitor based on specified parameters.
It can return a single dashboard group by ID or multiple groups based on name, parent group, or using filters.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve a dashboard group by ID
Get-LMDashboardGroup -Id 123
```

### EXAMPLE 2
```
#Retrieve dashboard groups by parent group
Get-LMDashboardGroup -ParentGroupName "Production"
```

## PARAMETERS

### -Id
The ID of the dashboard group to retrieve.
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
The name of the dashboard group to retrieve.
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

### -ParentGroupId
The ID of the parent group to filter results by.
Part of a mutually exclusive parameter set.

```yaml
Type: String
Parameter Sets: ParentId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupName
The name of the parent group to filter results by.
Part of a mutually exclusive parameter set.

```yaml
Type: String
Parameter Sets: ParentName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A filter object to apply when retrieving dashboard groups.
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

### Returns LogicMonitor.DashboardGroup objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
