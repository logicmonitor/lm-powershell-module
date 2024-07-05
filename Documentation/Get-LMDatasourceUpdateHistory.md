---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDatasourceUpdateHistory

## SYNOPSIS
Retrieves the update history of a LogicMonitor datasource.

## SYNTAX

### Id (Default)
```
Get-LMDatasourceUpdateHistory -Id <Int32> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMDatasourceUpdateHistory [-Name <String>] [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DisplayName
```
Get-LMDatasourceUpdateHistory [-DisplayName <String>] [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDatasourceUpdateHistory function retrieves the update history of a LogicMonitor datasource.
It can be used to get information about the updates made to a datasource, such as the reasons for the updates.

## EXAMPLES

### EXAMPLE 1
```
Get-LMDatasourceUpdateHistory -Id 1234
Retrieves the update history of the datasource with ID 1234.
```

### EXAMPLE 2
```
Get-LMDatasourceUpdateHistory -Name "MyDatasource"
Retrieves the update history of the datasource with the name "MyDatasource".
```

### EXAMPLE 3
```
Get-LMDatasourceUpdateHistory -DisplayName "My Datasource"
Retrieves the update history of the datasource with the display name "My Datasource".
```

## PARAMETERS

### -Id
The ID of the datasource.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the datasource.
This parameter is used to look up the ID of the datasource.
If the name is provided, the function will automatically retrieve the ID of the datasource.
This parameter is used in the 'Name' parameter set.

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

### -DisplayName
The display name of the datasource.
This parameter is used to look up the ID of the datasource.
If the display name is provided, the function will automatically retrieve the ID of the datasource.
This parameter is used in the 'DisplayName' parameter set.

```yaml
Type: String
Parameter Sets: DisplayName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A filter object that can be used to filter the results.
The filter object should contain properties that match the properties of the datasource.
Only datasources that match the filter will be included in the results.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
The number of results to retrieve in each batch.
The default value is 1000.

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

## OUTPUTS

## NOTES

## RELATED LINKS
