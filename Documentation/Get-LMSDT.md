---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMSDT

## SYNOPSIS
Retrieves Scheduled Down Time (SDT) entries from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMSDT [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMSDT [-Id <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMSDT [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Filter
```
Get-LMSDT [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMSDT function retrieves SDT entries from LogicMonitor.
It can retrieve all SDT entries, a specific entry by ID or name, or filter the results.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all SDT entries
Get-LMSDT
```

### EXAMPLE 2
```
#Retrieve a specific SDT entry by name
Get-LMSDT -Name "Maintenance Window"
```

## PARAMETERS

### -Id
The ID of the specific SDT entry to retrieve.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the specific SDT entry to retrieve.

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
A filter object to apply when retrieving SDT entries.

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

### Returns LogicMonitor.SDT objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
