---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Export-LMLogicModule

## SYNOPSIS
Exports LogicMonitor LogicModules for backup or transfer.

## SYNTAX

### Id (Default)
```
Export-LMLogicModule -LogicModuleId <Int32> -Type <String> [-DownloadPath <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Export-LMLogicModule -LogicModuleName <String> -Type <String> [-DownloadPath <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Export-LMLogicModule function exports LogicModules from LogicMonitor.
It supports exporting various types of modules including datasources, property rules, event sources, and more.

## EXAMPLES

### EXAMPLE 1
```
#Export a LogicModule by ID
Export-LMLogicModule -LogicModuleId 1907 -Type "eventsources"
```

### EXAMPLE 2
```
#Export a LogicModule by name
Export-LMLogicModule -LogicModuleName "SNMP_Network_Interfaces" -Type "datasources"
```

## PARAMETERS

### -LogicModuleId
The ID of the LogicModule to export.
This parameter is mandatory when using the Id parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases: Id

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LogicModuleName
The name of the LogicModule to export.
This parameter is mandatory when using the Name parameter set.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of LogicModule to export.
Valid values are: "datasources", "propertyrules", "eventsources", "topologysources", "configsources", "logsources", "functions", "oids".

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

### -DownloadPath
The path where the exported LogicModule will be saved.
Defaults to current directory.

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

### Returns a success message if the export is completed successfully.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
