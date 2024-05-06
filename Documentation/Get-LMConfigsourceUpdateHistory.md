---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMConfigsourceUpdateHistory

## SYNOPSIS
Retrieves the update history for a LogicMonitor configuration source.

## SYNTAX

### Id (Default)
```
Get-LMConfigsourceUpdateHistory -Id <Int32> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMConfigsourceUpdateHistory [-Name <String>] [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DisplayName
```
Get-LMConfigsourceUpdateHistory [-DisplayName <String>] [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMConfigsourceUpdateHistory function retrieves the update history for a LogicMonitor configuration source.
It can be used to get information about the updates made to a configuration source, such as the update reasons and the modules that were updated.

## EXAMPLES

### EXAMPLE 1
```
Get-LMConfigsourceUpdateHistory -Id 1234
Retrieves the update history for the configuration source with the ID 1234.
```

### EXAMPLE 2
```
Get-LMConfigsourceUpdateHistory -Name "MyConfigSource"
Retrieves the update history for the configuration source with the name "MyConfigSource".
```

### EXAMPLE 3
```
Get-LMConfigsourceUpdateHistory -DisplayName "My Config Source"
Retrieves the update history for the configuration source with the display name "My Config Source".
```

## PARAMETERS

### -Id
The ID of the configuration source.
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
The name of the configuration source.
This parameter is used to look up the ID of the configuration source.
This parameter is used when using the 'Name' parameter set.

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
The display name of the configuration source.
This parameter is used to look up the ID of the configuration source.
This parameter is used when using the 'DisplayName' parameter set.

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
A filter object that specifies additional filtering criteria for the update history.
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
The number of results to retrieve per request.
The default value is 1000.
This parameter is optional.

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
