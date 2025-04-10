---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDatasourceGraph

## SYNOPSIS
Creates a new datasource graph in LogicMonitor.

## SYNTAX

### dsId
```
New-LMDatasourceGraph -RawObject <Object> -DatasourceId <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### dsName
```
New-LMDatasourceGraph -RawObject <Object> -DatasourceName <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMDatasourceGraph function creates a new graph for a specified datasource in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
#Create graph using datasource ID
New-LMDatasourceGraph -RawObject $graphConfig -DatasourceId 123
```

### EXAMPLE 2
```
#Create graph using datasource name
New-LMDatasourceGraph -RawObject $graphConfig -DatasourceName "MyDatasource"
```

## PARAMETERS

### -RawObject
The raw object representing the graph configuration.
Use Get-LMDatasourceGraph to see the expected format.

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
The ID of the datasource to which the graph will be added.
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
The name of the datasource to which the graph will be added.
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
