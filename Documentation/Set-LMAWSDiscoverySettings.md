---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Set-LMAWSDiscoverySettings
---

# Set-LMAWSDiscoverySettings

## SYNOPSIS

Updates AWS Cloud discovery settings for specified AWS accounts in LogicMonitor.

## SYNTAX

### Id (Default)

```
Set-LMAWSDiscoverySettings -AccountId <int> -ServiceName <string> -Regions <string[]>
 [-AutoDelete <bool>] [-DeleteDelayDays <int>] [-DisableAlerting <bool>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name

```
Set-LMAWSDiscoverySettings -Name <string> -ServiceName <string> -Regions <string[]>
 [-AutoDelete <bool>] [-DeleteDelayDays <int>] [-DisableAlerting <bool>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Csv

```
Set-LMAWSDiscoverySettings -CsvPath <string> -ServiceName <string> -Regions <string[]>
 [-AutoDelete <bool>] [-DeleteDelayDays <int>] [-DisableAlerting <bool>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The Set-LMAWSDiscoverySettings function modifies AWS Cloud discovery settings such as monitored regions, automatic deletion policies, and alerting preferences for AWS services within LogicMonitor.
The function supports updating a single AWS account by AccountId or multiple accounts by importing AccountIds from a CSV file.

## EXAMPLES

### EXAMPLE 1

Set-LMAWSDiscoverySettings -AccountId 317 -ServiceName "EC2" -Regions "us-east-1","us-west-2"
Updates EC2 discovery settings for AWS account group ID 317 to monitor only us-east-1 and us-west-2 regions.

### EXAMPLE 2

Set-LMAWSDiscoverySettings -Name "Production AWS Account" -ServiceName "RDS" -Regions "us-east-1","us-east-2" -AutoDelete -DeleteDelayDays 10
Updates RDS discovery settings for the AWS account named "Production AWS Account" with automatic deletion enabled after 10 days.

### EXAMPLE 3

Set-LMAWSDiscoverySettings -CsvPath "C:\aws_accounts.csv" -ServiceName "EC2" -Regions "us-east-1","us-east-2"
Bulk updates EC2 discovery settings for multiple AWS accounts listed in the CSV file.

### EXAMPLE 4

Set-LMAWSDiscoverySettings -AccountId 317 -ServiceName "Lambda" -Regions "us-east-1" -AutoDelete -DeleteDelayDays 5 -DisableAlerting
Updates Lambda discovery settings with automatic deletion after 5 days and alerting disabled on termination.

## PARAMETERS

### -AccountId

Specifies the LogicMonitor device group ID of the AWS account for which to update discovery settings.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AutoDelete

Specifies whether to enable automatic deletion of terminated AWS resources.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Csv
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -CsvPath

Specifies the path to a CSV file containing multiple AWS AccountIds to update in bulk.
The CSV must have an "AccountId" column.
This parameter is part of the 'Csv' parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Csv
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DeleteDelayDays

Specifies the number of days to wait before automatically deleting terminated resources.
Defaults to 7.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Csv
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DisableAlerting

Specifies whether to disable alerting automatically after resource termination.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Csv
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

Specifies the name of the AWS account device group.
This parameter is mandatory when using the 'Name' parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Regions

Specifies an array of AWS regions (e.g., "us-east-1","us-east-2") to monitor for the specified service.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Csv
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ServiceName

Specifies the AWS service name (e.g., "EC2", "RDS", "Lambda") whose discovery settings are to be updated.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Csv
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Name
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Id
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### You can pipe objects containing AccountId properties to this function.

### System.Int32

## OUTPUTS

### Returns a LogicMonitor.DeviceGroup object containing the updated AWS account group information.

## NOTES

This function requires a valid LogicMonitor API authentication.
Use Connect-LMAccount before running this command.

## RELATED LINKS

