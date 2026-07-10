---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: New-LMUptimeDevice
---

# New-LMUptimeDevice

## SYNOPSIS

Creates a LogicMonitor Uptime device using the v3 device endpoint.

## SYNTAX

### WebInternal (Default)

```
New-LMUptimeDevice -Name <string> -HostGroupIds <string[]> -Domain <string>
 -TestLocationCollectorIds <int[]> [-Description <string>] [-PollingInterval <int>]
 [-AlertTriggerInterval <int>] [-GlobalSmAlertCond <string>] [-OverallAlertLevel <string>]
 [-IndividualAlertLevel <string>] [-IndividualSmAlertEnable <bool>]
 [-UseDefaultLocationSetting <bool>] [-UseDefaultAlertSetting <bool>] [-Properties <Object>]
 [-Template <string>] [-FolderPath <string>] [-StatusCode <string>] [-Keyword <string>]
 [-Schema <string>] [-IgnoreSSL <bool>] [-PageLoadAlertTimeInMS <int>] [-AlertExpr <string>]
 [-TriggerSSLStatusAlert <bool>] [-TriggerSSLExpirationAlert <bool>] [-Steps <hashtable[]>]
 [-HTTPMethod <string>] [-HTTPBody <string>] [-HTTPHeaders <string>] [-StepTimeout <int>]
 [-FollowRedirection <bool>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### PingExternal

```
New-LMUptimeDevice -Name <string> -HostGroupIds <string[]> -Hostname <string>
 [-Description <string>] [-PollingInterval <int>] [-AlertTriggerInterval <int>]
 [-GlobalSmAlertCond <string>] [-OverallAlertLevel <string>] [-IndividualAlertLevel <string>]
 [-IndividualSmAlertEnable <bool>] [-UseDefaultLocationSetting <bool>]
 [-UseDefaultAlertSetting <bool>] [-Properties <Object>] [-Template <string>] [-Count <int>]
 [-PercentPktsNotReceiveInTime <int>] [-TimeoutInMSPktsNotReceive <int>]
 [-TestLocationSmgIds <int[]>] [-TestLocationAll] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### PingInternal

```
New-LMUptimeDevice -Name <string> -HostGroupIds <string[]> -Hostname <string>
 -TestLocationCollectorIds <int[]> [-Description <string>] [-PollingInterval <int>]
 [-AlertTriggerInterval <int>] [-GlobalSmAlertCond <string>] [-OverallAlertLevel <string>]
 [-IndividualAlertLevel <string>] [-IndividualSmAlertEnable <bool>]
 [-UseDefaultLocationSetting <bool>] [-UseDefaultAlertSetting <bool>] [-Properties <Object>]
 [-Template <string>] [-Count <int>] [-PercentPktsNotReceiveInTime <int>]
 [-TimeoutInMSPktsNotReceive <int>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### WebExternal

```
New-LMUptimeDevice -Name <string> -HostGroupIds <string[]> -Domain <string> [-Description <string>]
 [-PollingInterval <int>] [-AlertTriggerInterval <int>] [-GlobalSmAlertCond <string>]
 [-OverallAlertLevel <string>] [-IndividualAlertLevel <string>] [-IndividualSmAlertEnable <bool>]
 [-UseDefaultLocationSetting <bool>] [-UseDefaultAlertSetting <bool>] [-Properties <Object>]
 [-Template <string>] [-FolderPath <string>] [-StatusCode <string>] [-Keyword <string>]
 [-Schema <string>] [-IgnoreSSL <bool>] [-PageLoadAlertTimeInMS <int>] [-AlertExpr <string>]
 [-TriggerSSLStatusAlert <bool>] [-TriggerSSLExpirationAlert <bool>] [-Steps <hashtable[]>]
 [-HTTPMethod <string>] [-HTTPBody <string>] [-HTTPHeaders <string>] [-StepTimeout <int>]
 [-FollowRedirection <bool>] [-TestLocationSmgIds <int[]>] [-TestLocationAll] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The New-LMUptimeDevice cmdlet provisions an Uptime web or ping monitor (internal or external)
through the LogicMonitor v3 device endpoint.
It builds the appropriate payload shape, applies
validation to enforce supported combinations, and submits the request with the required
X-Version header.
Supported monitor types include:
- Internal Web Checks
- External Web Checks
- Internal Ping Checks
- External Ping Checks

## EXAMPLES

### EXAMPLE 1

New-LMUptimeDevice -Name "web-int-01" -HostGroupIds 17 -Domain "app.example.com" -TestLocationCollectorIds 12

Creates a new internal web uptime check against app.example.com using collector 12.

### EXAMPLE 2

New-LMUptimeDevice -Name "web-ext-01" -HostGroupIds 17 -Domain "app.example.com" -TestLocationSmgIds 2,3,4

Creates a new external web uptime check using the specified public locations.

### EXAMPLE 3

New-LMUptimeDevice -Name "ping-int-01" -HostGroupIds 17 -Hostname "intranet.local" -TestLocationCollectorIds 5

Creates an internal ping uptime check that targets intranet.local.

### EXAMPLE 4

New-LMUptimeDevice -Name "ping-ext-01" -HostGroupIds 17 -Hostname "api.example.net" -TestLocationSmgIds 2,4

Creates an external ping uptime check using the provided public locations.

### EXAMPLE 5

New-LMUptimeDevice -Name "api-post-check" -HostGroupIds 17 -Domain "api.example.com" -TestLocationSmgIds 2,3 -HTTPMethod POST -HTTPBody '{"test": true}' -HTTPHeaders "Content-Type: application/json" -StatusCode 201

Creates an external web check that performs a POST request with JSON body and custom headers.

## PARAMETERS

### -AlertExpr

Specifies the SSL alert expression for web checks.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
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

Specifies the number of consecutive failures required to trigger an alert.
Valid values are 1-10.
Default is 1.

```yaml
Type: System.Int32
DefaultValue: 1
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

Specifies ping attempts per collection for ping checks.
Valid values: 5, 10, 15, 20, 30, 50.

```yaml
Type: System.Int32
DefaultValue: 5
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PingExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: PingInternal
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

Provides an optional description for the device.

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

Specifies the domain for web checks.
Required for web parameter sets.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FolderPath

Specifies the folder path to use for web checks.
Defaults to empty string.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FollowRedirection

Indicates whether to follow HTTP redirects.
Defaults to $true.

```yaml
Type: System.Boolean
DefaultValue: True
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
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

Defines the global synthetic alert condition threshold.

```yaml
Type: System.String
DefaultValue: all
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

Specifies one or more device group identifiers to assign to the Uptime device.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PingExternal
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: PingInternal
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebExternal
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Hostname

Specifies the hostname or IP address to ping.
Required for ping parameter sets (**PingInternal** and **PingExternal**).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PingExternal
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: PingInternal
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -HTTPBody

Specifies the HTTP body content for POST requests.
Only applicable when HTTPMethod is POST.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -HTTPHeaders

Specifies custom HTTP headers for web checks as a string.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -HTTPMethod

Specifies the HTTP method for web checks.
Valid values are GET, HEAD, or POST.
Defaults to GET.

```yaml
Type: System.String
DefaultValue: GET
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IgnoreSSL

Indicates whether SSL warnings should be ignored for web checks.
Defaults to $false.

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
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

Specifies the alert level for individual checks.
Valid values are warn, error, or critical.

```yaml
Type: System.String
DefaultValue: error
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

Indicates whether individual synthetic alerts are enabled.
Defaults to $true.

```yaml
Type: System.Boolean
DefaultValue: True
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

### -Keyword

Specifies the keyword to match for web checks.
Defaults to empty string.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
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

Specifies the device name.
Required for every parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PingExternal
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: PingInternal
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebExternal
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
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

Specifies the alert level for overall checks.
Valid values are warn, error, or critical.

```yaml
Type: System.String
DefaultValue: warn
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

Specifies the page load alert threshold in milliseconds for web checks.

```yaml
Type: System.Int32
DefaultValue: 30000
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
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

Defines the packet loss percentage threshold for ping checks.

```yaml
Type: System.Int32
DefaultValue: 80
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PingExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: PingInternal
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

Sets the polling interval in minutes.
Valid values are 1-10.

```yaml
Type: System.Int32
DefaultValue: 5
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

Provides a hashtable of custom properties for the device.
Keys map to property names.

```yaml
Type: System.Object
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

### -Schema

Defines the HTTP schema (http or https) for web checks.
Defaults to https.

```yaml
Type: System.String
DefaultValue: https
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StatusCode

Specifies the expected status code for web checks.
Defaults to 200.

```yaml
Type: System.String
DefaultValue: 200
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
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

Provides the scripted step definitions for web checks.
Defaults to a single GET script step
when omitted.

```yaml
Type: System.Collections.Hashtable[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StepTimeout

Specifies the request timeout in seconds for web check steps.
Valid range is 1-300.
Defaults to 30.

```yaml
Type: System.Int32
DefaultValue: 30
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
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

Specifies an optional website template identifier.

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
- Name: PingExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebExternal
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
Required for internal parameter sets.

```yaml
Type: System.Int32[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PingInternal
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
  Position: Named
  IsRequired: true
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
- Name: PingExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebExternal
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

Defines the packet response timeout threshold in milliseconds for ping checks.

```yaml
Type: System.Int32
DefaultValue: 500
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PingExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: PingInternal
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

Indicates whether SSL expiration alerts are enabled for web checks.

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
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

Indicates whether SSL status alerts are enabled for web checks.

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WebExternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WebInternal
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UseDefaultAlertSetting

Indicates whether default alert settings should be used.
Defaults to $true.

```yaml
Type: System.Boolean
DefaultValue: True
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

Indicates whether default location settings should be used.
Defaults to $true.

```yaml
Type: System.Boolean
DefaultValue: True
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

### None. You cannot pipe objects to this cmdlet.

## OUTPUTS

### LogicMonitor.LMUptimeDevice

## NOTES

You must run Connect-LMAccount before invoking this cmdlet.
This function sends requests to
/device/devices with X-Version 3 and returns LogicMonitor.LMUptimeDevice objects.

## RELATED LINKS

- [Get-LMUptimeDevice]()
- [Set-LMUptimeDevice]()
- [Remove-LMUptimeDevice]()
- [New-LMUptimeWebStep]()
