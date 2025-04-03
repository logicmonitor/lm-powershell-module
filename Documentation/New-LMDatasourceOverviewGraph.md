---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDatasourceOverviewGraph

## SYNOPSIS
Creates a new datasource overview graph in LogicMonitor.

## SYNTAX

### dsId
```
New-LMDatasourceOverviewGraph -RawObject <Object> -DatasourceId <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### dsName
```
New-LMDatasourceOverviewGraph -RawObject <Object> -DatasourceName <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMDatasourceOverviewGraph function creates a new overview graph for a specified datasource in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
#Create overview graph using datasource ID
New-LMDatasourceOverviewGraph -RawObject $graphConfig -DatasourceId 123
```

### EXAMPLE 2
```
#Create overview graph using datasource name
New-LMDatasourceOverviewGraph -RawObject $graphConfig -DatasourceName "MyDatasource"
```

## PARAMETERS

### -RawObject
The raw object representing the graph configuration.
Use Get-LMDatasourceOverviewGraph to see the expected format.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceId
The ID of the datasource for which to create the overview graph.
Required for dsId parameter set.

```yaml
Type: Object
Parameter Sets: dsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceName
The name of the datasource for which to create the overview graph.
Required for dsName parameter set.

```yaml
Type: Object
Parameter Sets: dsName
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

### Returns LogicMonitor.DatasourceGraph object.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
