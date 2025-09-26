---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMUptimeDevice

## SYNOPSIS
Updates an existing LogicMonitor Uptime device using the v3 device endpoint.

## SYNTAX

### IdGeneral (Default)
```
Set-LMUptimeDevice -Id <Int32> [-PropertiesMethod <String>] [-Description <String>] [-HostGroupIds <String[]>]
 [-PollingInterval <Int32>] [-AlertTriggerInterval <Int32>] [-GlobalSmAlertCond <String>]
 [-OverallAlertLevel <String>] [-IndividualAlertLevel <String>] [-IndividualSmAlertEnable <Boolean>]
 [-UseDefaultLocationSetting <Boolean>] [-UseDefaultAlertSetting <Boolean>] [-Properties <Hashtable>]
 [-Template <String>] [-TestLocationCollectorIds <Int32[]>] [-TestLocationSmgIds <Int32[]>] [-TestLocationAll]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### IdPing
```
Set-LMUptimeDevice -Id <Int32> [-PropertiesMethod <String>] [-Description <String>] [-HostGroupIds <String[]>]
 [-PollingInterval <Int32>] [-AlertTriggerInterval <Int32>] [-GlobalSmAlertCond <String>]
 [-OverallAlertLevel <String>] [-IndividualAlertLevel <String>] [-IndividualSmAlertEnable <Boolean>]
 [-UseDefaultLocationSetting <Boolean>] [-UseDefaultAlertSetting <Boolean>] [-Properties <Hashtable>]
 [-Template <String>] [-Hostname <String>] [-Count <Int32>] [-PercentPktsNotReceiveInTime <Int32>]
 [-TimeoutInMSPktsNotReceive <Int32>] [-TestLocationCollectorIds <Int32[]>] [-TestLocationSmgIds <Int32[]>]
 [-TestLocationAll] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### IdWeb
```
Set-LMUptimeDevice -Id <Int32> [-PropertiesMethod <String>] [-Description <String>] [-HostGroupIds <String[]>]
 [-PollingInterval <Int32>] [-AlertTriggerInterval <Int32>] [-GlobalSmAlertCond <String>]
 [-OverallAlertLevel <String>] [-IndividualAlertLevel <String>] [-IndividualSmAlertEnable <Boolean>]
 [-UseDefaultLocationSetting <Boolean>] [-UseDefaultAlertSetting <Boolean>] [-Properties <Hashtable>]
 [-Template <String>] [-Domain <String>] [-Schema <String>] [-IgnoreSSL <Boolean>]
 [-PageLoadAlertTimeInMS <Int32>] [-AlertExpr <String>] [-TriggerSSLStatusAlert <Boolean>]
 [-TriggerSSLExpirationAlert <Boolean>] [-Steps <Hashtable[]>] [-TestLocationCollectorIds <Int32[]>]
 [-TestLocationSmgIds <Int32[]>] [-TestLocationAll] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### NamePing
```
Set-LMUptimeDevice -Name <String> [-PropertiesMethod <String>] [-Description <String>]
 [-HostGroupIds <String[]>] [-PollingInterval <Int32>] [-AlertTriggerInterval <Int32>]
 [-GlobalSmAlertCond <String>] [-OverallAlertLevel <String>] [-IndividualAlertLevel <String>]
 [-IndividualSmAlertEnable <Boolean>] [-UseDefaultLocationSetting <Boolean>]
 [-UseDefaultAlertSetting <Boolean>] [-Properties <Hashtable>] [-Template <String>] [-Hostname <String>]
 [-Count <Int32>] [-PercentPktsNotReceiveInTime <Int32>] [-TimeoutInMSPktsNotReceive <Int32>]
 [-TestLocationCollectorIds <Int32[]>] [-TestLocationSmgIds <Int32[]>] [-TestLocationAll]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### NameWeb
```
Set-LMUptimeDevice -Name <String> [-PropertiesMethod <String>] [-Description <String>]
 [-HostGroupIds <String[]>] [-PollingInterval <Int32>] [-AlertTriggerInterval <Int32>]
 [-GlobalSmAlertCond <String>] [-OverallAlertLevel <String>] [-IndividualAlertLevel <String>]
 [-IndividualSmAlertEnable <Boolean>] [-UseDefaultLocationSetting <Boolean>]
 [-UseDefaultAlertSetting <Boolean>] [-Properties <Hashtable>] [-Template <String>] [-Domain <String>]
 [-Schema <String>] [-IgnoreSSL <Boolean>] [-PageLoadAlertTimeInMS <Int32>] [-AlertExpr <String>]
 [-TriggerSSLStatusAlert <Boolean>] [-TriggerSSLExpirationAlert <Boolean>] [-Steps <Hashtable[]>]
 [-TestLocationCollectorIds <Int32[]>] [-TestLocationSmgIds <Int32[]>] [-TestLocationAll]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### NameGeneral
```
Set-LMUptimeDevice -Name <String> [-PropertiesMethod <String>] [-Description <String>]
 [-HostGroupIds <String[]>] [-PollingInterval <Int32>] [-AlertTriggerInterval <Int32>]
 [-GlobalSmAlertCond <String>] [-OverallAlertLevel <String>] [-IndividualAlertLevel <String>]
 [-IndividualSmAlertEnable <Boolean>] [-UseDefaultLocationSetting <Boolean>]
 [-UseDefaultAlertSetting <Boolean>] [-Properties <Hashtable>] [-Template <String>]
 [-TestLocationCollectorIds <Int32[]>] [-TestLocationSmgIds <Int32[]>] [-TestLocationAll]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMUptimeDevice cmdlet updates internal or external Uptime monitors (web or ping) by
submitting a PATCH request to the LogicMonitor v3 device endpoint.
It resolves the device ID
from name when necessary, validates location combinations, and constructs the appropriate
payload structure before issuing the request.

## EXAMPLES

### EXAMPLE 1
```
Set-LMUptimeDevice -Id 123 -PollingInterval 10 -Transition 2
```

Updates the polling interval and transition threshold for the uptime device with ID 123.

### EXAMPLE 2
```
Set-LMUptimeDevice -Name "web-ext-01" -TestLocationSmgIds 2,4,6 -TriggerSSLStatusAlert $true
```

Resolves the ID from the device name and updates external web check locations and SSL alerts.

## PARAMETERS

### -Id
Specifies the device identifier to update.
Accepts pipeline input by property name.

```yaml
Type: Int32
Parameter Sets: IdGeneral, IdPing, IdWeb
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the device name to update.
The cmdlet resolves the corresponding ID prior to issuing the request.

```yaml
Type: String
Parameter Sets: NamePing, NameWeb, NameGeneral
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertiesMethod
Determines how custom properties are applied when supplied.
Valid values are Add, Replace, or Refresh.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Replace
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Updates the description of the Uptime device.

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

### -HostGroupIds
Sets the group identifiers assigned to the Uptime device.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PollingInterval
Configures the polling interval in minutes.

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

### -AlertTriggerInterval
Specifies the number of consecutive failures before alerting.

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

### -GlobalSmAlertCond
Sets the synthetic monitoring global alert condition (all, half, moreThanOne, any).

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

### -OverallAlertLevel
Configures the overall alert level (warn, error, critical).

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

### -IndividualAlertLevel
Configures the individual alert level (warn, error, critical).

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

### -IndividualSmAlertEnable
Enables or disables individual synthetic alerts.

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

### -UseDefaultLocationSetting
Controls whether default location settings are used for the Uptime device.

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

### -UseDefaultAlertSetting
Controls whether default alert settings are used for the Uptime device.

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

### -Properties
Hashtable of custom properties to apply to the Uptime device.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Template
Specifies an optional template identifier.

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
Updates the domain for web checks.

```yaml
Type: String
Parameter Sets: IdWeb, NameWeb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Schema
Defines the HTTP schema (http or https) for web checks.

```yaml
Type: String
Parameter Sets: IdWeb, NameWeb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IgnoreSSL
Enables or disables SSL certificate validation warnings.

```yaml
Type: Boolean
Parameter Sets: IdWeb, NameWeb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageLoadAlertTimeInMS
Sets the page load alert threshold for web checks.

```yaml
Type: Int32
Parameter Sets: IdWeb, NameWeb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertExpr
Configures the SSL alert expression for web checks.

```yaml
Type: String
Parameter Sets: IdWeb, NameWeb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TriggerSSLStatusAlert
Enables or disables SSL status alerts.

```yaml
Type: Boolean
Parameter Sets: IdWeb, NameWeb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TriggerSSLExpirationAlert
Enables or disables SSL expiration alerts.

```yaml
Type: Boolean
Parameter Sets: IdWeb, NameWeb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Steps
Provides an array of step definitions for web checks.

```yaml
Type: Hashtable[]
Parameter Sets: IdWeb, NameWeb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostname
Updates the hostname/IP for ping checks.

```yaml
Type: String
Parameter Sets: IdPing, NamePing
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Count
Sets the number of ping attempts per polling cycle.

```yaml
Type: Int32
Parameter Sets: IdPing, NamePing
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PercentPktsNotReceiveInTime
Defines the allowed packet loss percentage before alerting.

```yaml
Type: Int32
Parameter Sets: IdPing, NamePing
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutInMSPktsNotReceive
Defines the timeout threshold in milliseconds for ping checks.

```yaml
Type: Int32
Parameter Sets: IdPing, NamePing
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestLocationCollectorIds
Specifies collector identifiers for internal checks.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestLocationSmgIds
Specifies synthetic monitoring group identifiers for external checks.

```yaml
Type: Int32[]
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Requests are issued to
/device/devices/{id} with X-Version 3 and return LogicMonitor.LMUptimeDevice objects.

## RELATED LINKS
