---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDatasourceMetadata

## SYNOPSIS
Retrieves metadata for a LogicMonitor datasource.

## SYNTAX

### All (Default)
```
Get-LMDatasourceMetadata [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMDatasourceMetadata [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name
```
Get-LMDatasourceMetadata [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DisplayName
```
Get-LMDatasourceMetadata [-DisplayName <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDatasourceMetadata function retrieves metadata information for a specified LogicMonitor datasource.
The datasource can be identified by ID, name, or display name.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve metadata by datasource ID
Get-LMDatasourceMetadata -Id 123
```

### EXAMPLE 2
```
#Retrieve metadata by datasource name
Get-LMDatasourceMetadata -Name "CPU"
```

## PARAMETERS

### -Id
The ID of the datasource to retrieve metadata for.
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
The name of the datasource to retrieve metadata for.
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
The display name of the datasource to retrieve metadata for.
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

### Returns metadata information for the specified datasource.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
