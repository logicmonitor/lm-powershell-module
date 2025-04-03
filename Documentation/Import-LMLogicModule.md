---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Import-LMLogicModule

## SYNOPSIS
Imports a LogicModule into LogicMonitor.

## SYNTAX

### FilePath
```
Import-LMLogicModule -FilePath <String> [-Type <String>] [-ForceOverwrite <Boolean>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### File
```
Import-LMLogicModule -File <Object> [-Type <String>] [-ForceOverwrite <Boolean>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Import-LMLogicModule function imports a LogicModule from a file path or file data.
Supports various module types including datasource, propertyrules, eventsource, topologysource, configsource, logsource, functions, and oids.

## EXAMPLES

### EXAMPLE 1
```
#Import a datasource module
Import-LMLogicModule -FilePath "C:\LogicModules\datasource.xml" -Type "datasource" -ForceOverwrite $true
```

### EXAMPLE 2
```
#Import a property rules module
Import-LMLogicModule -File $fileData -Type "propertyrules"
```

## PARAMETERS

### -FilePath
The path to the file containing the LogicModule to import.

```yaml
Type: String
Parameter Sets: FilePath
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
The file data of the LogicModule to import.

```yaml
Type: Object
Parameter Sets: File
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of LogicModule.
Valid values are "datasource", "propertyrules", "eventsource", "topologysource", "configsource", "logsource", "functions", "oids".
Defaults to "datasource".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Datasource
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForceOverwrite
Whether to overwrite an existing LogicModule with the same name.
Defaults to $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### Returns a success message if the import is successful.
## NOTES
You must run Connect-LMAccount before running this command.
Requires PowerShell version 6.1 or higher.

## RELATED LINKS
