---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Find-LMDashboardWidget

## SYNOPSIS
Find list of dashboard widgets containing mention of specified datasources

## SYNTAX

```
Find-LMDashboardWidget [-DatasourceNames] <String[]> [[-GroupPathSearchString] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Find list of dashboard widgets containing mention of specified datasources

## EXAMPLES

### EXAMPLE 1
```
Find-LMDashboardWidget -DatasourceNames @("SNMP_NETWORK_INTERFACES","VMWARE_VCETNER_VM_PERFORMANCE")
```

## PARAMETERS

### -DatasourceNames
Array of datasource names to search for in dashboard widgets.
Can also use the alias DatasourceName.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: DatasourceName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -GroupPathSearchString
Wildcard search string to filter dashboards by group path.
Defaults to "*" (all dashboards).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: *
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

### DatasourceNames in an array. You can also pipe datasource names to this widget.
## OUTPUTS

## NOTES
Created groups will be placed in a main group called Azure Resources by Subscription in the parent group specified by the -ParentGroupId parameter

## RELATED LINKS
