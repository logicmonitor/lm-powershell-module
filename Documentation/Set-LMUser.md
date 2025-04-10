---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMUser

## SYNOPSIS
Updates a LogicMonitor user configuration.

## SYNTAX

### Id (Default)
```
Set-LMUser -Id <String> [-NewUsername <String>] [-Email <String>] [-UserGroups <String[]>]
 [-AcceptEULA <Boolean>] [-Password <String>] [-FirstName <String>] [-LastName <String>]
 [-ForcePasswordChange <Boolean>] [-Phone <String>] [-Note <String>] [-RoleNames <String[]>]
 [-SmsEmail <String>] [-SmsEmailFormat <String>] [-Status <String>] [-Timezone <String>]
 [-TwoFAEnabled <Boolean>] [-Views <String[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Username
```
Set-LMUser -Username <String> [-NewUsername <String>] [-Email <String>] [-UserGroups <String[]>]
 [-AcceptEULA <Boolean>] [-Password <String>] [-FirstName <String>] [-LastName <String>]
 [-ForcePasswordChange <Boolean>] [-Phone <String>] [-Note <String>] [-RoleNames <String[]>]
 [-SmsEmail <String>] [-SmsEmailFormat <String>] [-Status <String>] [-Timezone <String>]
 [-TwoFAEnabled <Boolean>] [-Views <String[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMUser function modifies an existing user in LogicMonitor, including their roles, permissions, and settings.

## EXAMPLES

### EXAMPLE 1
```
Set-LMUser -Id 123 -NewUsername "newuser" -Email "user@domain.com" -Status "active"
Updates the user with new username, email, and status.
```

## PARAMETERS

### -Id
Specifies the ID of the user to modify.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Username
Specifies the current username.

```yaml
Type: String
Parameter Sets: Username
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewUsername
Specifies the new username.

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

### -Email
Specifies the email address for the user.

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

### -UserGroups
Specifies an array of user group names to assign to the user.

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

### -AcceptEULA
Indicates whether the user has accepted the EULA.

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

### -Password
Specifies the new password for the user.

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

### -FirstName
Specifies the user's first name.

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

### -LastName
Specifies the user's last name.

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

### -ForcePasswordChange
Indicates whether to force the user to change their password at next login.

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

### -Phone
Specifies the user's phone number.

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

### -Note
Specifies a note for the user.

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

### -RoleNames
Specifies an array of role names to assign to the user.

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

### -SmsEmail
{{ Fill SmsEmail Description }}

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

### -SmsEmailFormat
{{ Fill SmsEmailFormat Description }}

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

### -Status
Specifies the user's status.
Valid values: "active", "suspended".

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

### -Timezone
{{ Fill Timezone Description }}

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

### -TwoFAEnabled
{{ Fill TwoFAEnabled Description }}

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

### -Views
Specifies the views the user has access to.
Valid values: "Alerts", "Dashboards", "Logs", "Maps", "Reports", "Resources", "Settings", "Websites", "All".

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

### Returns a LogicMonitor.User object containing the updated user configuration.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
