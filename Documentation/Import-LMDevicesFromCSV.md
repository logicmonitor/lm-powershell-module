---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Import-LMDevicesFromCSV

## SYNOPSIS
Imports devices from a CSV file into LogicMonitor.

## SYNTAX

### Import (Default)
```
Import-LMDevicesFromCSV -FilePath <String> [-PassThru] [-CollectorId <Int32>]
 [-AutoBalancedCollectorGroupId <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Sample
```
Import-LMDevicesFromCSV [-GenerateExampleCSV] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Import-LMDevicesFromCSV function imports devices from a CSV file into LogicMonitor.
It requires a valid CSV file containing device information such as IP address, display name, host group, collector ID, and description.
The function checks if the user is logged in and has valid API credentials before importing the devices.

## EXAMPLES

### EXAMPLE 1
```
Import-LMDevicesFromCSV -FilePath "C:\Devices.csv" -CollectorId 1234
Imports devices from the "Devices.csv" file located at "C:\Devices.csv" and assigns the collector with ID 1234 to the imported devices.
```

### EXAMPLE 2
```
Import-LMDevicesFromCSV -GenerateExampleCSV
Generates an example CSV file named "SampleLMDeviceImportCSV.csv" in the current directory with sample device information.
```

## PARAMETERS

### -FilePath
Specifies the path to the CSV file containing the device information.
This parameter is mandatory when the 'Import' parameter set is used.

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
Generates an example CSV file with sample device information.
This parameter is optional and can be used with the 'Sample' parameter set.

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
Indicates whether to return the imported devices as output.
This parameter is optional and can be used with the 'Import' parameter set.

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

### -CollectorId
Specifies the collector ID to assign to the imported devices.
This parameter is optional and can be used with the 'Import' parameter set.

```yaml
Type: Int32
Parameter Sets: Import
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoBalancedCollectorGroupId
Specifies the auto-balanced collector group ID to assign to the imported devices.
This parameter is optional and can be used with the 'Import' parameter set.

```yaml
Type: Int32
Parameter Sets: Import
Aliases:

Required: False
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

## OUTPUTS

## NOTES
- This function requires valid API credentials to connect to LogicMonitor.
- The CSV file must have the following columns: ip, displayname, hostgroup. collectorid, collectorgroupid, description, property.name1, property.name2.. are optional.
- The function creates device groups if they don't exist based on the host group path specified in the CSV file.
- If the collector ID is not specified in the CSV file, the function uses the collector ID specified by the CollectorId parameter.

## RELATED LINKS
