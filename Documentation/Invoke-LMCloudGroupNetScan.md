---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMCloudGroupNetScan

## SYNOPSIS
Invokes a NetScan task for a cloud device group.

## SYNTAX

### GroupId
```
Invoke-LMCloudGroupNetScan -Id <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupName
```
Invoke-LMCloudGroupNetScan -Name <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMCloudGroupNetScan function schedules a NetScan task for a specified cloud device group (AWS, Azure, or GCP) in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
#Run NetScan on a cloud group by ID
Invoke-LMCloudGroupNetScan -Id "12345"
```

### EXAMPLE 2
```
#Run NetScan on a cloud group by name
Invoke-LMCloudGroupNetScan -Name "AWS-Production"
```

## PARAMETERS

### -Id
The ID of the cloud device group.
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

### -Name
The name of the cloud device group.
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
The target group must be a cloud group (AWS, Azure, or GCP).

## RELATED LINKS
