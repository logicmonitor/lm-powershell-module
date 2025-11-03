---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMWebsite

## SYNOPSIS
Updates a LogicMonitor website monitoring configuration with improved parameter validation.

## SYNTAX

### Website (Default)
```
Set-LMWebsite -Id <String> [-Name <String>] [-IsInternal <Boolean>] [-Description <String>]
 [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>] [-UseDefaultAlertSetting <Boolean>]
 [-UseDefaultLocationSetting <Boolean>] [-TriggerSSLStatusAlert <Boolean>]
 [-TriggerSSLExpirationAlert <Boolean>] [-GroupId <String>] [-WebsiteDomain <String>] [-HttpType <String>]
 [-SSLAlertThresholds <String[]>] [-PageLoadAlertTimeInMS <Int32>] [-FailedCount <Int32>]
 [-OverallAlertLevel <String>] [-IndividualAlertLevel <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-PollingInterval <Int32>] [-WebsiteSteps <String[]>]
 [-TestLocationAll <Boolean>] [-TestLocationCollectorIds <Int32[]>] [-TestLocationSmgIds <Int32[]>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Ping
```
Set-LMWebsite -Id <String> [-Name <String>] [-IsInternal <Boolean>] [-Description <String>]
 [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>] [-UseDefaultAlertSetting <Boolean>]
 [-UseDefaultLocationSetting <Boolean>] [-GroupId <String>] [-PingAddress <String>] [-PingCount <Int32>]
 [-PingTimeout <Int32>] [-PingPercentNotReceived <Int32>] [-FailedCount <Int32>] [-OverallAlertLevel <String>]
 [-IndividualAlertLevel <String>] [-Properties <Hashtable>] [-PropertiesMethod <String>]
 [-PollingInterval <Int32>] [-TestLocationAll <Boolean>] [-TestLocationCollectorIds <Int32[]>]
 [-TestLocationSmgIds <Int32[]>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMWebsite function modifies an existing website monitoring configuration in LogicMonitor.
It includes intelligent validation of test location parameters to ensure valid combinations are used.

## EXAMPLES

### EXAMPLE 1
```
Set-LMWebsite -Id 123 -Name "Updated Site" -Description "New description" -DisableAlerting $false
Updates the website with new name, description, and enables alerting.
```

### EXAMPLE 2
```
Set-LMWebsite -Id 123 -TestLocationAll $true
Updates the website to test from all locations.
```

## PARAMETERS

### -Id
Specifies the ID of the website to modify.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the name for the website.

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

### -IsInternal
Indicates whether the website is internal.

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

### -Description
Specifies the description for the website.

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

### -DisableAlerting
Indicates whether to disable alerting for the website.

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

### -StopMonitoring
Indicates whether to stop monitoring the website.

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
Indicates whether to use default alert settings.

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
Indicates whether to use default location settings.

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

### -TriggerSSLStatusAlert
Indicates whether to trigger SSL status alerts.

```yaml
Type: Boolean
Parameter Sets: Website
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TriggerSSLExpirationAlert
Indicates whether to trigger SSL expiration alerts.

```yaml
Type: Boolean
Parameter Sets: Website
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupId
Specifies the group ID for the website.

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

### -PingAddress
{{ Fill PingAddress Description }}

```yaml
Type: String
Parameter Sets: Ping
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsiteDomain
{{ Fill WebsiteDomain Description }}

```yaml
Type: String
Parameter Sets: Website
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HttpType
{{ Fill HttpType Description }}

```yaml
Type: String
Parameter Sets: Website
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SSLAlertThresholds
Specifies the SSL alert thresholds for the website check.
This is an alias for the alertExpr parameter.

```yaml
Type: String[]
Parameter Sets: Website
Aliases: alertExpr

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PingCount
{{ Fill PingCount Description }}

```yaml
Type: Int32
Parameter Sets: Ping
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PingTimeout
{{ Fill PingTimeout Description }}

```yaml
Type: Int32
Parameter Sets: Ping
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageLoadAlertTimeInMS
{{ Fill PageLoadAlertTimeInMS Description }}

```yaml
Type: Int32
Parameter Sets: Website
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PingPercentNotReceived
{{ Fill PingPercentNotReceived Description }}

```yaml
Type: Int32
Parameter Sets: Ping
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailedCount
{{ Fill FailedCount Description }}

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

### -OverallAlertLevel
{{ Fill OverallAlertLevel Description }}

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
{{ Fill IndividualAlertLevel Description }}

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

### -Properties
Specifies a hashtable of custom properties for the website.

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

### -PropertiesMethod
Specifies how to handle properties.
Valid values: "Add", "Replace", "Refresh".

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

### -PollingInterval
Specifies the polling interval.
Valid values: 1-10, 30, 60.

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

### -WebsiteSteps
{{ Fill WebsiteSteps Description }}

```yaml
Type: String[]
Parameter Sets: Website
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestLocationAll
Indicates whether to test from all locations.
Cannot be used with TestLocationCollectorIds or TestLocationSmgIds.

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

### -TestLocationCollectorIds
Array of collector IDs to use for testing.
Can only be used when IsInternal is true.
Cannot be used with TestLocationAll or TestLocationSmgIds.

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
Array of collector group IDs to use for testing.
Can only be used when IsInternal is false.
Cannot be used with TestLocationAll or TestLocationCollectorIds.
Available collector group IDs correspond to LogicMonitor regions:
- 2 = US - Washington DC
- 3 = Europe - Dublin
- 4 = US - Oregon
- 5 = Asia - Singapore
- 6 = Australia - Sydney

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

### None.
## OUTPUTS

### Returns a LogicMonitor.Website object containing the updated configuration.
## NOTES
This function requires a valid LogicMonitor API authentication.
It enforces strict validation rules for TestLocation parameters to prevent invalid combinations.

## RELATED LINKS
