---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMUptimeDevice

## SYNOPSIS
Creates a LogicMonitor Uptime device using the v3 device endpoint.

## SYNTAX

### WebInternal (Default)
```
New-LMUptimeDevice -Name <String> -GroupIds <String[]> [-Description <String>] [-PollingInterval <Int32>]
 [-AlertTriggerInterval <Int32>] [-GlobalSmAlertCond <String>] [-OverallAlertLevel <String>]
 [-IndividualAlertLevel <String>] [-IndividualSmAlertEnable <Boolean>] [-UseDefaultLocationSetting <Boolean>]
 [-UseDefaultAlertSetting <Boolean>] [-Properties <Object>] [-Template <String>] -Domain <String>
 [-FolderPath <String>] [-StatusCode <String>] [-Keyword <String>] [-Schema <String>] [-IgnoreSSL <Boolean>]
 [-PageLoadAlertTimeInMS <Int32>] [-AlertExpr <String>] [-TriggerSSLStatusAlert <Boolean>]
 [-TriggerSSLExpirationAlert <Boolean>] [-Steps <Hashtable[]>] -TestLocationCollectorIds <Int32[]>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### PingExternal
```
New-LMUptimeDevice -Name <String> -GroupIds <String[]> [-Description <String>] [-PollingInterval <Int32>]
 [-AlertTriggerInterval <Int32>] [-GlobalSmAlertCond <String>] [-OverallAlertLevel <String>]
 [-IndividualAlertLevel <String>] [-IndividualSmAlertEnable <Boolean>] [-UseDefaultLocationSetting <Boolean>]
 [-UseDefaultAlertSetting <Boolean>] [-Properties <Object>] [-Template <String>] -Hostname <String>
 [-Count <Int32>] [-PercentPktsNotReceiveInTime <Int32>] [-TimeoutInMSPktsNotReceive <Int32>]
 [-TestLocationSmgIds <Int32[]>] [-TestLocationAll] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### PingInternal
```
New-LMUptimeDevice -Name <String> -GroupIds <String[]> [-Description <String>] [-PollingInterval <Int32>]
 [-AlertTriggerInterval <Int32>] [-GlobalSmAlertCond <String>] [-OverallAlertLevel <String>]
 [-IndividualAlertLevel <String>] [-IndividualSmAlertEnable <Boolean>] [-UseDefaultLocationSetting <Boolean>]
 [-UseDefaultAlertSetting <Boolean>] [-Properties <Object>] [-Template <String>] -Hostname <String>
 [-Count <Int32>] [-PercentPktsNotReceiveInTime <Int32>] [-TimeoutInMSPktsNotReceive <Int32>]
 -TestLocationCollectorIds <Int32[]> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### WebExternal
```
New-LMUptimeDevice -Name <String> -GroupIds <String[]> [-Description <String>] [-PollingInterval <Int32>]
 [-AlertTriggerInterval <Int32>] [-GlobalSmAlertCond <String>] [-OverallAlertLevel <String>]
 [-IndividualAlertLevel <String>] [-IndividualSmAlertEnable <Boolean>] [-UseDefaultLocationSetting <Boolean>]
 [-UseDefaultAlertSetting <Boolean>] [-Properties <Object>] [-Template <String>] -Domain <String>
 [-FolderPath <String>] [-StatusCode <String>] [-Keyword <String>] [-Schema <String>] [-IgnoreSSL <Boolean>]
 [-PageLoadAlertTimeInMS <Int32>] [-AlertExpr <String>] [-TriggerSSLStatusAlert <Boolean>]
 [-TriggerSSLExpirationAlert <Boolean>] [-Steps <Hashtable[]>] [-TestLocationSmgIds <Int32[]>]
 [-TestLocationAll] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
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
```
New-LMUptimeDevice -Name "web-int-01" -GroupIds 17 -Domain "app.example.com" -TestLocationCollectorIds 12
```

Creates a new internal web uptime check against app.example.com using collector 12.

### EXAMPLE 2
```
New-LMUptimeDevice -Name "web-ext-01" -GroupIds 17 -Domain "app.example.com" -TestLocationSmgIds 2,3,4
```

Creates a new external web uptime check using the specified public locations.

### EXAMPLE 3
```
New-LMUptimeDevice -Name "ping-int-01" -GroupIds 17 -Host "intranet.local" -TestLocationCollectorIds 5
```

Creates an internal ping uptime check that targets intranet.local.

### EXAMPLE 4
```
New-LMUptimeDevice -Name "ping-ext-01" -GroupIds 17 -Host "api.example.net" -TestLocationSmgIds 2,4
```

Creates an external ping uptime check using the provided public locations.

## PARAMETERS

### -Name
Specifies the device name.
Required for every parameter set.

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

### -GroupIds
Specifies one or more device group identifiers to assign to the Uptime device.

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

### -Description
Provides an optional description for the device.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PollingInterval
Sets the polling interval in minutes.
Valid values are 1-10, 30, or 60.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertTriggerInterval
{{ Fill AlertTriggerInterval Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -GlobalSmAlertCond
Defines the global synthetic alert condition threshold.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -OverallAlertLevel
Specifies the alert level for overall checks.
Valid values are warn, error, or critical.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Warn
Accept pipeline input: False
Accept wildcard characters: False
```

### -IndividualAlertLevel
Specifies the alert level for individual checks.
Valid values are warn, error, or critical.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Error
Accept pipeline input: False
Accept wildcard characters: False
```

### -IndividualSmAlertEnable
Indicates whether individual synthetic alerts are enabled.
Defaults to $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseDefaultLocationSetting
Indicates whether default location settings should be used.
Defaults to $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseDefaultAlertSetting
Indicates whether default alert settings should be used.
Defaults to $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
Provides a hashtable of custom properties for the device.
Keys map to property names.

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

### -Template
Specifies an optional website template identifier.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
Specifies the domain for web checks.
Required for web parameter sets.

```yaml
Type: String
Parameter Sets: WebInternal, WebExternal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FolderPath
Specifies the folder path to use for web checks.
Defaults to empty string.

```yaml
Type: String
Parameter Sets: WebInternal, WebExternal
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatusCode
Specifies the expected status code for web checks.
Defaults to 200.

```yaml
Type: String
Parameter Sets: WebInternal, WebExternal
Aliases:

Required: False
Position: Named
Default value: 200
Accept pipeline input: False
Accept wildcard characters: False
```

### -Keyword
Specifies the keyword to match for web checks.
Defaults to empty string.

```yaml
Type: String
Parameter Sets: WebInternal, WebExternal
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Schema
Defines the HTTP schema (http or https) for web checks.
Defaults to https.

```yaml
Type: String
Parameter Sets: WebInternal, WebExternal
Aliases:

Required: False
Position: Named
Default value: Https
Accept pipeline input: False
Accept wildcard characters: False
```

### -IgnoreSSL
Indicates whether SSL warnings should be ignored for web checks.
Defaults to $true.

```yaml
Type: Boolean
Parameter Sets: WebInternal, WebExternal
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageLoadAlertTimeInMS
Specifies the page load alert threshold in milliseconds for web checks.

```yaml
Type: Int32
Parameter Sets: WebInternal, WebExternal
Aliases:

Required: False
Position: Named
Default value: 30000
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertExpr
Specifies the SSL alert expression for web checks.

```yaml
Type: String
Parameter Sets: WebInternal, WebExternal
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TriggerSSLStatusAlert
Indicates whether SSL status alerts are enabled for web checks.

```yaml
Type: Boolean
Parameter Sets: WebInternal, WebExternal
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TriggerSSLExpirationAlert
Indicates whether SSL expiration alerts are enabled for web checks.

```yaml
Type: Boolean
Parameter Sets: WebInternal, WebExternal
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Steps
Provides the scripted step definitions for web checks.
Defaults to a single GET script step
when omitted.

```yaml
Type: Hashtable[]
Parameter Sets: WebInternal, WebExternal
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostname
{{ Fill Hostname Description }}

```yaml
Type: String
Parameter Sets: PingExternal, PingInternal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Count
Specifies ping attempts per collection for ping checks.
Valid values: 5, 10, 15, 20, 30, 60.

```yaml
Type: Int32
Parameter Sets: PingExternal, PingInternal
Aliases:

Required: False
Position: Named
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -PercentPktsNotReceiveInTime
Defines the packet loss percentage threshold for ping checks.

```yaml
Type: Int32
Parameter Sets: PingExternal, PingInternal
Aliases:

Required: False
Position: Named
Default value: 80
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutInMSPktsNotReceive
Defines the packet response timeout threshold in milliseconds for ping checks.

```yaml
Type: Int32
Parameter Sets: PingExternal, PingInternal
Aliases:

Required: False
Position: Named
Default value: 500
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestLocationCollectorIds
Specifies collector identifiers for internal checks.
Required for internal parameter sets.

```yaml
Type: Int32[]
Parameter Sets: WebInternal, PingInternal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestLocationSmgIds
Specifies synthetic monitoring group identifiers for external checks.

```yaml
Type: Int32[]
Parameter Sets: PingExternal, WebExternal
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestLocationAll
Indicates that all public locations should be used for external checks.

```yaml
Type: SwitchParameter
Parameter Sets: PingExternal, WebExternal
Aliases:

Required: False
Position: Named
Default value: False
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

## OUTPUTS

### LogicMonitor.LMUptimeDevice
## NOTES
You must run Connect-LMAccount before invoking this cmdlet.
This function sends requests to
/device/devices with X-Version 3 and returns LogicMonitor.LMUptimeDevice objects.

## RELATED LINKS
