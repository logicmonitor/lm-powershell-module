---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceGroupSDTHistory

## SYNOPSIS
Retrieves Scheduled Downtime (SDT) history for a LogicMonitor device group.

## SYNTAX

### Id (Default)
```
Get-LMDeviceGroupSDTHistory -Id <Int32> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMDeviceGroupSDTHistory [-Name <String>] [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceGroupSDTHistory function retrieves the historical Scheduled Downtime entries for a specified device group in LogicMonitor.
The device group can be identified by either ID or name, and the results can be filtered.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve SDT history by group ID
Get-LMDeviceGroupSDTHistory -Id 123
```

### EXAMPLE 2
```
#Retrieve filtered SDT history by group name
Get-LMDeviceGroupSDTHistory -Name "Production" -Filter $filterObject
```

## PARAMETERS

### -Id
The ID of the device group to retrieve SDT history from.
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
The name of the device group to retrieve SDT history from.
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
This parameter is optional.

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

### Returns SDT history objects for the specified device group.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
