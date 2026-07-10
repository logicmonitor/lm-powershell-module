---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Set-LMUptimeDevice
---

# Set-LMUptimeDevice

## SYNOPSIS

Updates an existing LogicMonitor Uptime device using the v3 device endpoint.

## SYNTAX

### IdGeneral (Default)

```
Set-LMUptimeDevice -Id <int> -Type <string> [-PropertiesMethod <string>] [-Description <string>]
 [-HostGroupIds <string[]>] [-PollingInterval <int>] [-AlertTriggerInterval <int>]
 [-GlobalSmAlertCond <string>] [-OverallAlertLevel <string>] [-IndividualAlertLevel <string>]
 [-IndividualSmAlertEnable <bool>] [-UseDefaultLocationSetting <bool>]
 [-UseDefaultAlertSetting <bool>] [-Properties <hashtable>] [-Template <string>]
 [-TestLocationCollectorIds <int[]>] [-TestLocationSmgIds <int[]>] [-TestLocationAll] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### IdPing

```
Set-LMUptimeDevice -Id <int> -Type <string> [-PropertiesMethod <string>] [-Description <string>]
 [-HostGroupIds <string[]>] [-PollingInterval <int>] [-AlertTriggerInterval <int>]
 [-GlobalSmAlertCond <string>] [-OverallAlertLevel <string>] [-IndividualAlertLevel <string>]
 [-IndividualSmAlertEnable <bool>] [-UseDefaultLocationSetting <bool>]
 [-UseDefaultAlertSetting <bool>] [-Properties <hashtable>] [-Template <string>]
 [-Hostname <string>] [-Count <int>] [-PercentPktsNotReceiveInTime <int>]
 [-TimeoutInMSPktsNotReceive <int>] [-TestLocationCollectorIds <int[]>]
 [-TestLocationSmgIds <int[]>] [-TestLocationAll] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### IdWeb

```
Set-LMUptimeDevice -Id <int> -Type <string> [-PropertiesMethod <string>] [-Description <string>]
 [-HostGroupIds <string[]>] [-PollingInterval <int>] [-AlertTriggerInterval <int>]
 [-GlobalSmAlertCond <string>] [-OverallAlertLevel <string>] [-IndividualAlertLevel <string>]
 [-IndividualSmAlertEnable <bool>] [-UseDefaultLocationSetting <bool>]
 [-UseDefaultAlertSetting <bool>] [-Properties <hashtable>] [-Template <string>] [-Domain <string>]
 [-Schema <string>] [-IgnoreSSL <bool>] [-PageLoadAlertTimeInMS <int>] [-AlertExpr <string>]
 [-TriggerSSLStatusAlert <bool>] [-TriggerSSLExpirationAlert <bool>] [-Steps <hashtable[]>]
 [-TestLocationCollectorIds <int[]>] [-TestLocationSmgIds <int[]>] [-TestLocationAll] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### NamePing

```
Set-LMUptimeDevice -Name <string> -Type <string> [-PropertiesMethod <string>]
 [-Description <string>] [-HostGroupIds <string[]>] [-PollingInterval <int>]
 [-AlertTriggerInterval <int>] [-GlobalSmAlertCond <string>] [-OverallAlertLevel <string>]
 [-IndividualAlertLevel <string>] [-IndividualSmAlertEnable <bool>]
 [-UseDefaultLocationSetting <bool>] [-UseDefaultAlertSetting <bool>] [-Properties <hashtable>]
 [-Template <string>] [-Hostname <string>] [-Count <int>] [-PercentPktsNotReceiveInTime <int>]
 [-TimeoutInMSPktsNotReceive <int>] [-TestLocationCollectorIds <int[]>]
 [-TestLocationSmgIds <int[]>] [-TestLocationAll] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### NameWeb

```
Set-LMUptimeDevice -Name <string> -Type <string> [-PropertiesMethod <string>]
 [-Description <string>] [-HostGroupIds <string[]>] [-PollingInterval <int>]
 [-AlertTriggerInterval <int>] [-GlobalSmAlertCond <string>] [-OverallAlertLevel <string>]
 [-IndividualAlertLevel <string>] [-IndividualSmAlertEnable <bool>]
 [-UseDefaultLocationSetting <bool>] [-UseDefaultAlertSetting <bool>] [-Properties <hashtable>]
 [-Template <string>] [-Domain <string>] [-Schema <string>] [-IgnoreSSL <bool>]
 [-PageLoadAlertTimeInMS <int>] [-AlertExpr <string>] [-TriggerSSLStatusAlert <bool>]
 [-TriggerSSLExpirationAlert <bool>] [-Steps <hashtable[]>] [-TestLocationCollectorIds <int[]>]
 [-TestLocationSmgIds <int[]>] [-TestLocationAll] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### NameGeneral

```
Set-LMUptimeDevice -Name <string> -Type <string> [-PropertiesMethod <string>]
 [-Description <string>] [-HostGroupIds <string[]>] [-PollingInterval <int>]
 [-AlertTriggerInterval <int>] [-GlobalSmAlertCond <string>] [-OverallAlertLevel <string>]
 [-IndividualAlertLevel <string>] [-IndividualSmAlertEnable <bool>]
 [-UseDefaultLocationSetting <bool>] [-UseDefaultAlertSetting <bool>] [-Properties <hashtable>]
 [-Template <string>] [-TestLocationCollectorIds <int[]>] [-TestLocationSmgIds <int[]>]
 [-TestLocationAll] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Set-LMUptimeDevice cmdlet updates internal or external Uptime monitors (web or ping) by
submitting a PATCH request to the LogicMonitor v3 device endpoint.
It resolves the device ID
from name when necessary, validates location combinations, and constructs the appropriate
payload structure before issuing the request.
The Type parameter is mandatory and determines
the response structure returned by the API.

## EXAMPLES

### EXAMPLE 1

Set-LMUptimeDevice -Id 123 -Type uptimewebcheck -PollingInterval 10 -AlertTriggerInterval 2

Updates the polling interval and alert trigger threshold for the web uptime device with ID 123.

### EXAMPLE 2

Set-LMUptimeDevice -Name "web-ext-01" -Type uptimewebcheck -TestLocationSmgIds 2,4,6 -TriggerSSLStatusAlert $true

Resolves the ID from the device name and updates external web check locations and SSL alerts.

### EXAMPLE 3

Set-LMUptimeDevice -Id 456 -Type uptimepingcheck -Description "Updated ping check"

Updates the description for the ping uptime device with ID 456.

## PARAMETERS

### -AlertExpr

Configures the SSL alert expression for web checks.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NameWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AlertTriggerInterval

Specifies the number of consecutive failures before alerting.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -Count

Sets the number of ping attempts per polling cycle.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NamePing
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdPing
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

Updates the description of the Uptime device.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -Domain

Updates the domain for web checks.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NameWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GlobalSmAlertCond

Sets the synthetic monitoring global alert condition (all, half, moreThanOne, any).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -HostGroupIds

Sets the group identifiers assigned to the Uptime device.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -Hostname

Updates the hostname/IP for ping checks.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NamePing
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdPing
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

Specifies the device identifier to update.
Accepts pipeline input by property name.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: IdPing
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
- Name: IdWeb
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
- Name: IdGeneral
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IgnoreSSL

Enables or disables SSL certificate validation warnings.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NameWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IndividualAlertLevel

Configures the individual alert level (warn, error, critical).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -IndividualSmAlertEnable

Enables or disables individual synthetic alerts.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -Name

Specifies the device name to update.
The cmdlet resolves the corresponding ID prior to issuing the request.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NamePing
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: NameWeb
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: NameGeneral
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OverallAlertLevel

Configures the overall alert level (warn, error, critical).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -PageLoadAlertTimeInMS

Sets the page load alert threshold for web checks.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NameWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PercentPktsNotReceiveInTime

Defines the allowed packet loss percentage before alerting.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NamePing
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdPing
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PollingInterval

Configures the polling interval in minutes.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -Properties

Hashtable of custom properties to apply to the Uptime device.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -PropertiesMethod

Determines how custom properties are applied when supplied.
Valid values are Add, Replace, or Refresh.

```yaml
Type: System.String
DefaultValue: Replace
SupportsWildcards: false
Aliases: []
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

### -Schema

Defines the HTTP schema (http or https) for web checks.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NameWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Steps

Provides an array of step definitions for web checks.

```yaml
Type: System.Collections.Hashtable[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NameWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Template

Specifies an optional template identifier.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -TestLocationAll

Indicates that all public locations should be used for external checks.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
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

### -TestLocationCollectorIds

Specifies collector identifiers for internal checks.

```yaml
Type: System.Int32[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -TestLocationSmgIds

Specifies synthetic monitoring group identifiers for external checks.

```yaml
Type: System.Int32[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -TimeoutInMSPktsNotReceive

Defines the timeout threshold in milliseconds for ping checks.

```yaml
Type: System.Nullable`1[System.Int32]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NamePing
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdPing
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TriggerSSLExpirationAlert

Enables or disables SSL expiration alerts.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NameWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TriggerSSLStatusAlert

Enables or disables SSL status alerts.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: NameWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: IdWeb
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Type

Specifies the Uptime monitor type.
This parameter is mandatory and determines the response
structure.
Valid values are uptimewebcheck and uptimepingcheck.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UseDefaultAlertSetting

Controls whether default alert settings are used for the Uptime device.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -UseDefaultLocationSetting

Controls whether default location settings are used for the Uptime device.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### System.Int32. You can pipe an Id to this cmdlet.

### System.Int32

## OUTPUTS

### LogicMonitor.LMUptimeDevice

## NOTES

You must run Connect-LMAccount before invoking this cmdlet.

## RELATED LINKS

- [Get-LMUptimeDevice]()
- [New-LMUptimeDevice]()
- [Remove-LMUptimeDevice]()
