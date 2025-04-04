---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMReportGroup

## SYNOPSIS
Updates a LogicMonitor report group configuration.

## SYNTAX

### Id
```
Set-LMReportGroup [-Id <Int32>] [-NewName <String>] [-Description <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Set-LMReportGroup [-Name <String>] [-NewName <String>] [-Description <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMReportGroup function modifies an existing report group in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
Set-LMReportGroup -Id 123 -NewName "Updated Reports" -Description "New description"
Updates the report group with ID 123 with a new name and description.
```

## PARAMETERS

### -Id
Specifies the ID of the report group to modify.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the current name of the report group.

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

### -NewName
Specifies the new name for the report group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Specifies the new description for the report group.

```yaml
Type: String
Parameter Sets: (All)
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

### None.
## OUTPUTS

### Returns a LogicMonitor.NetScanGroup object containing the updated group information.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
