---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMWebsiteGroupSDTHistory

## SYNOPSIS
Retrieves historical Scheduled Down Time (SDT) entries for a website group from LogicMonitor.

## SYNTAX

### Id (Default)
```
Get-LMWebsiteGroupSDTHistory -Id <Int32> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMWebsiteGroupSDTHistory [-Name <String>] [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMWebsiteGroupSDTHistory function retrieves historical SDT entries for a specified website group in LogicMonitor.
The group can be identified by either ID or name.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve SDT history by group ID
Get-LMWebsiteGroupSDTHistory -Id 123
```

### EXAMPLE 2
```
#Retrieve SDT history for a specific group
Get-LMWebsiteGroupSDTHistory -Name "Production-Websites"
```

## PARAMETERS

### -Id
The ID of the website group to retrieve SDT history from.
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
The name of the website group to retrieve SDT history from.
Required for Name parameter set.

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
A filter object to apply when retrieving SDT history.

```yaml
Type: Object
Parameter Sets: (All)
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

### Returns historical website group SDT objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
