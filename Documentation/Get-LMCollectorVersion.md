---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMCollectorVersion

## SYNOPSIS
Retrieves available LogicMonitor collector versions.

## SYNTAX

### All (Default)
```
Get-LMCollectorVersion [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Filter
```
Get-LMCollectorVersion [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Top
```
Get-LMCollectorVersion [-TopVersions] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMCollectorVersions function retrieves information about available LogicMonitor collector versions.
It can return all versions, top versions only, or versions filtered by specific criteria.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all collector versions
Get-LMCollectorVersions
```

### EXAMPLE 2
```
#Retrieve only top versions
Get-LMCollectorVersions -TopVersions
```

## PARAMETERS

### -Filter
A filter object to apply when retrieving collector versions.
This parameter is part of a mutually exclusive parameter set.

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

### -TopVersions
Switch to retrieve only the top versions of collectors.
This parameter is part of a mutually exclusive parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: Top
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

### Returns an array of collector version objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
