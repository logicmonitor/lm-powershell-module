---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Export-LMDashboard

## SYNOPSIS
Exports dashboards from LogicMonitor to a JSON file.

## SYNTAX

### Id (Default)
```
Export-LMDashboard [-Id <Int32>] [-PassThru] [-FilePath <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name
```
Export-LMDashboard [-Name <String>] [-PassThru] [-FilePath <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Export-LMDashboard function exports dashboard information from LogicMonitor to a JSON file.

## EXAMPLES

### EXAMPLE 1
```
#Export a dashboard to a JSON file
Export-LMDashboard -Id 123 -FilePath "C:\temp"
```

## PARAMETERS

### -Id
The ID of the dashboard to retrieve.
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
The name of the dashboard to retrieve.
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

### -PassThru
Switch to return the dashboard export as a PSCustomObject.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
The path to the output file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Location).Path
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

### Returns LogicMonitor.Dashboard objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
