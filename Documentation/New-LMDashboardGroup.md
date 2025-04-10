---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDashboardGroup

## SYNOPSIS
Creates a new LogicMonitor dashboard group.

## SYNTAX

### GroupId
```
New-LMDashboardGroup -Name <String> [-Description <String>] [-WidgetTokens <Hashtable>] -ParentGroupId <Int32>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupName
```
New-LMDashboardGroup -Name <String> [-Description <String>] [-WidgetTokens <Hashtable>]
 -ParentGroupName <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMDashboardGroup function creates a new dashboard group in LogicMonitor.
It can be created under a parent group specified by either ID or name.

## EXAMPLES

### EXAMPLE 1
```
#Create dashboard group using parent ID
New-LMDashboardGroup -Name "Operations" -Description "Operations dashboards" -ParentGroupId 123
```

### EXAMPLE 2
```
#Create dashboard group using parent name
New-LMDashboardGroup -Name "Operations" -Description "Operations dashboards" -ParentGroupName "Root"
```

## PARAMETERS

### -Name
The name of the dashboard group.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description of the dashboard group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WidgetTokens
A hashtable containing widget tokens for the dashboard group.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupId
The ID of the parent group.
Required for GroupId parameter set.

```yaml
Type: Int32
Parameter Sets: GroupId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupName
The name of the parent group.
Required for GroupName parameter set.

```yaml
Type: String
Parameter Sets: GroupName
Aliases:

Required: True
Position: Named
Default value: None
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

### Returns the created dashboard group object.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
