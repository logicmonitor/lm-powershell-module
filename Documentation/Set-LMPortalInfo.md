---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMPortalInfo

## SYNOPSIS
Updates LogicMonitor portal settings.

## SYNTAX

```
Set-LMPortalInfo [[-Whitelist] <String>] [-ClearWhitelist] [[-RequireTwoFA] <Boolean>]
 [[-IncludeACKinAlertTotals] <Boolean>] [[-IncludeSDTinAlertTotals] <Boolean>]
 [[-EnableRemoteSession] <Boolean>] [[-CompanyDisplayName] <String>] [[-UserSessionTimeoutInMin] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMPortalInfo function modifies various portal-wide settings in LogicMonitor, including whitelisting, two-factor authentication, alert totals, and session timeouts.

## EXAMPLES

### EXAMPLE 1
```
Set-LMPortalInfo -RequireTwoFA $true -UserSessionTimeoutInMin 60 -CompanyDisplayName "My Company"
Updates the portal settings to require 2FA, set session timeout to 60 minutes, and update company display name.
```

## PARAMETERS

### -Whitelist
Specifies IP addresses/ranges to whitelist for portal access.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClearWhitelist
Indicates whether to clear the existing whitelist.

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

### -RequireTwoFA
Specifies whether to require two-factor authentication for all users.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeACKinAlertTotals
Specifies whether to include acknowledged alerts in alert totals.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeSDTinAlertTotals
Specifies whether to include alerts in SDT in alert totals.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableRemoteSession
Specifies whether to enable remote session functionality.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompanyDisplayName
Specifies the company name to display in the portal.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserSessionTimeoutInMin
Specifies the session timeout in minutes.
Valid values: 30, 60, 120, 240, 480, 1440, 10080, 43200.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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

### Returns the response from the API containing the updated portal settings.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
