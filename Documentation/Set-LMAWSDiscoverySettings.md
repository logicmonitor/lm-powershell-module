---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMAWSDiscoverySettings

## SYNOPSIS
Updates AWS Cloud discovery settings for specified AWS accounts in LogicMonitor.

## SYNTAX

### Id (Default)
```
Set-LMAWSDiscoverySettings -AccountId <Int32> -ServiceName <String> -Regions <String[]> [-AutoDelete <Boolean>]
 [-DeleteDelayDays <Int32>] [-DisableAlerting <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Name
```
Set-LMAWSDiscoverySettings -Name <String> -ServiceName <String> -Regions <String[]> [-AutoDelete <Boolean>]
 [-DeleteDelayDays <Int32>] [-DisableAlerting <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Csv
```
Set-LMAWSDiscoverySettings -CsvPath <String> -ServiceName <String> -Regions <String[]> [-AutoDelete <Boolean>]
 [-DeleteDelayDays <Int32>] [-DisableAlerting <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMAWSDiscoverySettings function modifies AWS Cloud discovery settings such as monitored regions, automatic deletion policies, and alerting preferences for AWS services within LogicMonitor.
The function supports updating a single AWS account by AccountId or multiple accounts by importing AccountIds from a CSV file.

## EXAMPLES

### EXAMPLE 1
```
Set-LMAWSDiscoverySettings -AccountId 317 -ServiceName "EC2" -Regions "us-east-1","us-west-2"
Updates EC2 discovery settings for AWS account group ID 317 to monitor only us-east-1 and us-west-2 regions.
```

### EXAMPLE 2
```
Set-LMAWSDiscoverySettings -Name "Production AWS Account" -ServiceName "RDS" -Regions "us-east-1","us-east-2" -AutoDelete -DeleteDelayDays 10
Updates RDS discovery settings for the AWS account named "Production AWS Account" with automatic deletion enabled after 10 days.
```

### EXAMPLE 3
```
Set-LMAWSDiscoverySettings -CsvPath "C:\aws_accounts.csv" -ServiceName "EC2" -Regions "us-east-1","us-east-2"
Bulk updates EC2 discovery settings for multiple AWS accounts listed in the CSV file.
```

### EXAMPLE 4
```
Set-LMAWSDiscoverySettings -AccountId 317 -ServiceName "Lambda" -Regions "us-east-1" -AutoDelete -DeleteDelayDays 5 -DisableAlerting
Updates Lambda discovery settings with automatic deletion after 5 days and alerting disabled on termination.
```

## PARAMETERS

### -AccountId
Specifies the LogicMonitor device group ID of the AWS account for which to update discovery settings.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases: Id

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the name of the AWS account device group.
This parameter is mandatory when using the 'Name' parameter set.

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

### -CsvPath
Specifies the path to a CSV file containing multiple AWS AccountIds to update in bulk.
The CSV must have an "AccountId" column.
This parameter is part of the 'Csv' parameter set.

```yaml
Type: String
Parameter Sets: Csv
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceName
Specifies the AWS service name (e.g., "EC2", "RDS", "Lambda") whose discovery settings are to be updated.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Regions
Specifies an array of AWS regions (e.g., "us-east-1","us-east-2") to monitor for the specified service.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoDelete
Specifies whether to enable automatic deletion of terminated AWS resources.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeleteDelayDays
Specifies the number of days to wait before automatically deleting terminated resources.
Defaults to 7.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableAlerting
Specifies whether to disable alerting automatically after resource termination.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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

### You can pipe objects containing AccountId properties to this function.
## OUTPUTS

### Returns a LogicMonitor.DeviceGroup object containing the updated AWS account group information.
## NOTES
This function requires a valid LogicMonitor API authentication.
Use Connect-LMAccount before running this command.

## RELATED LINKS
