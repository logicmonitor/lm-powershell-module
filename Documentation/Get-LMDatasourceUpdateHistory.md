---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDatasourceUpdateHistory

## SYNOPSIS
Retrieves update history for a LogicMonitor datasource.

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
The Get-LMDatasourceUpdateHistory function retrieves the update history for a specified datasource.
It can identify the datasource by ID, name, or display name and supports filtering the results.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve update history by datasource ID
Get-LMDatasourceUpdateHistory -Id 123
```

### EXAMPLE 2
```
#Retrieve filtered update history by datasource name
Get-LMDatasourceUpdateHistory -Name "CPU" -Filter $filterObject
```

## PARAMETERS

### -Id
The ID of the datasource.
This parameter is mandatory when using the Id parameter set.

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

### -DisplayName
The display name of the datasource.
Part of a mutually exclusive parameter set.

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
A filter object to apply when retrieving update history.
This parameter is optional.

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

### Returns LogicMonitor.ModuleUpdateHistory objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
