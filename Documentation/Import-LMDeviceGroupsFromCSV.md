---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Import-LMDeviceGroupsFromCSV

## SYNOPSIS
Imports list of device groups based on specified CSV file.

## SYNTAX

### Import (Default)
```
Import-LMDeviceGroupsFromCSV -FilePath <String> [-PassThru] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Sample
```
Import-LMDeviceGroupsFromCSV [-GenerateExampleCSV] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Imports list of device groups based on specified CSV file.
You can generate a sample of the CSV file by specifying the -GenerateExampleCSV parameter.

## EXAMPLES

### EXAMPLE 1
```
Import-LMDeviceGroupsFromCSV -FilePath ./ImportList.csv -PassThru
```

## PARAMETERS

### -FilePath
Path to the CSV file containing device groups to import.
Required for Import parameter set.

```yaml
Type: String
Parameter Sets: Import
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GenerateExampleCSV
Generates a sample CSV file to use as a template for importing device groups.

```yaml
Type: SwitchParameter
Parameter Sets: Sample
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Returns the imported device group objects.
By default, no output is returned.

```yaml
Type: SwitchParameter
Parameter Sets: Import
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

### None. Does not accept pipeline input.
## OUTPUTS

## NOTES
Assumes csv with the headers name,fullpath,description,appliesTo,property1,property2,property\[n\].
Name and fullpath are the only required fields.

## RELATED LINKS
