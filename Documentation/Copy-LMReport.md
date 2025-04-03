---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Copy-LMReport

## SYNOPSIS
Creates a copy of a LogicMonitor report.

## SYNTAX

```
Copy-LMReport [-Name] <String> [[-Description] <String>] [[-ParentGroupId] <String>] [-ReportObject] <Object>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Copy-LMReport function creates a new report based on an existing report's configuration.
It allows you to specify a new name, description, and parent group while maintaining other settings from the source report.

## EXAMPLES

### EXAMPLE 1
```
#Copy a report with basic settings
Copy-LMReport -Name "New Report" -ReportObject $reportObject
```

### EXAMPLE 2
```
#Copy a report with all optional parameters
Copy-LMReport -Name "New Report" -Description "New report description" -ParentGroupId 12345 -ReportObject $reportObject
```

## PARAMETERS

### -Name
The name for the new report.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
An optional description for the new report.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupId
The ID of the parent group for the new report.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportObject
The source report object to copy settings from.
This parameter is mandatory.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns the newly created report object.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
