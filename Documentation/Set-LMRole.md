---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMRole

## SYNOPSIS
Updates a LogicMonitor role configuration.

## SYNTAX

### Default (Default)
```
Set-LMRole [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-Default
```
Set-LMRole -Id <String> [-NewName <String>] [-CustomHelpLabel <String>] [-CustomHelpURL <String>]
 [-Description <String>] [-RequireEULA] [-TwoFARequired] [-RoleGroupId <String>]
 [-DashboardsPermission <String>] [-ResourcePermission <String>] [-LMXToolBoxPermission <String>]
 [-LMXPermission <String>] [-LogsPermission <String>] [-WebsitesPermission <String>]
 [-SavedMapsPermission <String>] [-ReportsPermission <String>] [-SettingsPermission <String>]
 [-CreatePrivateDashboards] [-AllowWidgetSharing] [-ConfigTabRequiresManagePermission] [-AllowedToViewMapsTab]
 [-AllowedToManageResourceDashboards] [-ViewTraces] [-ViewSupport] [-EnableRemoteSessionForResources]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-Custom
```
Set-LMRole -Id <String> [-NewName <String>] [-CustomHelpLabel <String>] [-CustomHelpURL <String>]
 [-Description <String>] [-RequireEULA] [-TwoFARequired] [-RoleGroupId <String>]
 -CustomPrivilegesObject <PSObject> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-Default
```
Set-LMRole -Name <String> [-NewName <String>] [-CustomHelpLabel <String>] [-CustomHelpURL <String>]
 [-Description <String>] [-RequireEULA] [-TwoFARequired] [-RoleGroupId <String>]
 [-DashboardsPermission <String>] [-ResourcePermission <String>] [-LMXToolBoxPermission <String>]
 [-LMXPermission <String>] [-LogsPermission <String>] [-WebsitesPermission <String>]
 [-SavedMapsPermission <String>] [-ReportsPermission <String>] [-SettingsPermission <String>]
 [-CreatePrivateDashboards] [-AllowWidgetSharing] [-ConfigTabRequiresManagePermission] [-AllowedToViewMapsTab]
 [-AllowedToManageResourceDashboards] [-ViewTraces] [-ViewSupport] [-EnableRemoteSessionForResources]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-Custom
```
Set-LMRole -Name <String> [-NewName <String>] [-CustomHelpLabel <String>] [-CustomHelpURL <String>]
 [-Description <String>] [-RequireEULA] [-TwoFARequired] [-RoleGroupId <String>]
 -CustomPrivilegesObject <PSObject> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMRole function modifies an existing role in LogicMonitor, including its permissions and privileges.

## EXAMPLES

### EXAMPLE 1
```
Set-LMRole -Id 123 -NewName "Updated Role" -Description "New description" -DashboardsPermission "view"
Updates the role with new name, description, and dashboard permissions.
```

## PARAMETERS

### -Id
Specifies the ID of the role to modify.

```yaml
Type: String
Parameter Sets: Id-Default, Id-Custom
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the current name of the role.

```yaml
Type: String
Parameter Sets: Name-Default, Name-Custom
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Specifies the new name for the role.

```yaml
Type: String
Parameter Sets: Id-Default, Id-Custom, Name-Default, Name-Custom
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomHelpLabel
Specifies the custom help label for the role.

```yaml
Type: String
Parameter Sets: Id-Default, Id-Custom, Name-Default, Name-Custom
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomHelpURL
Specifies the custom help URL for the role.

```yaml
Type: String
Parameter Sets: Id-Default, Id-Custom, Name-Default, Name-Custom
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Specifies the description for the role.

```yaml
Type: String
Parameter Sets: Id-Default, Id-Custom, Name-Default, Name-Custom
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequireEULA
Indicates whether to require EULA acceptance.

```yaml
Type: SwitchParameter
Parameter Sets: Id-Default, Id-Custom, Name-Default, Name-Custom
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TwoFARequired
Indicates whether to require two-factor authentication.

```yaml
Type: SwitchParameter
Parameter Sets: Id-Default, Id-Custom, Name-Default, Name-Custom
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleGroupId
Specifies the role group ID.

```yaml
Type: String
Parameter Sets: Id-Default, Id-Custom, Name-Default, Name-Custom
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DashboardsPermission
Specifies dashboard permissions.
Valid values: "view", "manage", "none".

```yaml
Type: String
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourcePermission
Specifies resource permissions.
Valid values: "view", "manage", "none".

```yaml
Type: String
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LMXToolBoxPermission
{{ Fill LMXToolBoxPermission Description }}

```yaml
Type: String
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LMXPermission
{{ Fill LMXPermission Description }}

```yaml
Type: String
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogsPermission
{{ Fill LogsPermission Description }}

```yaml
Type: String
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsitesPermission
{{ Fill WebsitesPermission Description }}

```yaml
Type: String
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SavedMapsPermission
{{ Fill SavedMapsPermission Description }}

```yaml
Type: String
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportsPermission
{{ Fill ReportsPermission Description }}

```yaml
Type: String
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SettingsPermission
Specifies settings permissions.
Valid values: "view", "manage", "none", "manage-collectors", "view-collectors".

```yaml
Type: String
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatePrivateDashboards
{{ Fill CreatePrivateDashboards Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowWidgetSharing
{{ Fill AllowWidgetSharing Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigTabRequiresManagePermission
{{ Fill ConfigTabRequiresManagePermission Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowedToViewMapsTab
{{ Fill AllowedToViewMapsTab Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowedToManageResourceDashboards
{{ Fill AllowedToManageResourceDashboards Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ViewTraces
{{ Fill ViewTraces Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ViewSupport
{{ Fill ViewSupport Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableRemoteSessionForResources
{{ Fill EnableRemoteSessionForResources Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Id-Default, Name-Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomPrivilegesObject
Specifies custom privileges for the role.

```yaml
Type: PSObject
Parameter Sets: Id-Custom, Name-Custom
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

### None.
## OUTPUTS

### Returns a LogicMonitor.Role object containing the updated role configuration.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
