---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceNetflowPort

## SYNOPSIS
Retrieves Netflow port data for a LogicMonitor device.

## SYNTAX

### Id (Default)
```
Get-LMDeviceNetflowPort -Id <Int32> [-Filter <Object>] [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMDeviceNetflowPort [-Name <String>] [-Filter <Object>] [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceNetflowPort function retrieves Netflow port information for a specified device.
It supports time range filtering and can identify the device by either ID or name.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve Netflow ports by device ID
Get-LMDeviceNetflowPort -Id 123
```

### EXAMPLE 2
```
#Retrieve Netflow ports with date range
Get-LMDeviceNetflowPort -Name "Router1" -StartDate (Get-Date).AddDays(-7)
```

## PARAMETERS

### -Id
The ID of the device to retrieve Netflow ports from.
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
The name of the device to retrieve Netflow ports from.
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
A filter object to apply when retrieving ports.
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

### -StartDate
The start date for retrieving Netflow data.
Defaults to 24 hours ago if not specified.

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
The end date for retrieving Netflow data.
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

### Returns Netflow port objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
