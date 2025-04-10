---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMActiveDiscovery

## SYNOPSIS
Invokes an active discovery task for LogicMonitor devices.

## SYNTAX

### Id
```
Invoke-LMActiveDiscovery -Id <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Invoke-LMActiveDiscovery -Name <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupId
```
Invoke-LMActiveDiscovery -GroupId <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupName
```
Invoke-LMActiveDiscovery -GroupName <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMActiveDiscovery function schedules an active discovery task for LogicMonitor devices.
It can target individual devices or device groups using either ID or name.

## EXAMPLES

### EXAMPLE 1
```
#Run active discovery on a device by ID
Invoke-LMActiveDiscovery -Id 12345
```

### EXAMPLE 2
```
#Run active discovery on a device group by name
Invoke-LMActiveDiscovery -GroupName "Production-Servers"
```

## PARAMETERS

### -Id
The ID of the device to run active discovery on.
Required for Id parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The name of the device to run active discovery on.
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

### -GroupId
The ID of the device group to run active discovery on.
Required for GroupId parameter set.

```yaml
Type: String
Parameter Sets: GroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupName
The name of the device group to run active discovery on.
Required for GroupName parameter set.

```yaml
Type: String
Parameter Sets: GroupName
Aliases:

Required: True
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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns a success message if the task is scheduled successfully.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
