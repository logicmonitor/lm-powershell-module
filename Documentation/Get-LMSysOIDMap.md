---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMSysOIDMap

## SYNOPSIS
Gets LogicMonitor system OID mappings.

## SYNTAX

### All (Default)
```
Get-LMSysOIDMap [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMSysOIDMap [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMSysOIDMap [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Filter
```
Get-LMSysOIDMap [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMSysOIDMap function retrieves system OID mappings from LogicMonitor.
It can retrieve all mappings, a specific mapping by ID or name, or filter the results.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all system OID mappings
Get-LMSysOIDMap
```

### EXAMPLE 2
```
#Retrieve a specific OID mapping by name
Get-LMSysOIDMap -Name "\.1\.3\.6\.1\.4\.1\.318\.1\.1\.32"
```

## PARAMETERS

### -Id
Specifies the ID of a specific OID mapping to retrieve.

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
Specifies the name of a specific OID mapping to retrieve.

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

### -Filter
Specifies a filter to apply to the results.

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

### -BatchSize
Specifies the number of records to retrieve per API request.
Valid values are 1-1000.
Default is 1000.

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

### Returns LogicMonitor.SysOIDMap objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
