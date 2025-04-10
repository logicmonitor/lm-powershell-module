---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMNetscanExecutionDevices

## SYNOPSIS
Retrieves devices discovered during a Netscan execution.

## SYNTAX

### Id (Default)
```
Get-LMNetscanExecutionDevices -Id <Int32> -NspId <String> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMNetscanExecutionDevices -NspName <String> [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMNetscanExecutionDevices function retrieves devices discovered during a specific Netscan execution in LogicMonitor.
The Netscan can be identified by either ID or name.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve devices from a specific execution
Get-LMNetscanExecutionDevices -Id 456 -NspId 123
```

### EXAMPLE 2
```
#Retrieve devices using Netscan name
Get-LMNetscanExecutionDevices -Id 456 -NspName "Network-Discovery"
```

## PARAMETERS

### -Id
The ID of the execution to retrieve devices from.
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

### -NspId
The ID of the Netscan.
Required when using Id parameter set.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NspName
The name of the Netscan.
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

### -Filter
A filter object to apply when retrieving devices.

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

### Returns LogicMonitor.NetScanExecutionDevice objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
