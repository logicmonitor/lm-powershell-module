---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMWebsiteData

## SYNOPSIS
Retrieves monitoring data for a specific website from LogicMonitor.

## SYNTAX

### Id (Default)
```
Get-LMWebsiteData -Id <Int32> [-StartDate <DateTime>] [-EndDate <DateTime>] [-CheckpointId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMWebsiteData -Name <String> [-StartDate <DateTime>] [-EndDate <DateTime>] [-CheckpointId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMWebsiteData function retrieves monitoring data for a specified website and checkpoint in LogicMonitor.
The website can be identified by either ID or name.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve website data by ID
Get-LMWebsiteData -Id 123
```

### EXAMPLE 2
```
#Retrieve website data with custom date range
Get-LMWebsiteData -Name "www.example.com" -StartDate (Get-Date).AddDays(-1)
```

## PARAMETERS

### -Id
The ID of the website to retrieve data from.
Required for Id parameter set.

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
The name of the website to retrieve data from.
Required for Name parameter set.

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

### -StartDate
The start date for retrieving website data.
Defaults to 60 minutes ago if not specified.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
The end date for retrieving website data.
Defaults to current time if not specified.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CheckpointId
The ID of the specific checkpoint to retrieve data from.
Defaults to 0.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
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

### Returns website monitoring data objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
