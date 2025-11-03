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
Set-LMRole [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
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
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-Custom
```
Set-LMRole -Id <String> [-NewName <String>] [-CustomHelpLabel <String>] [-CustomHelpURL <String>]
 [-Description <String>] [-RequireEULA] [-TwoFARequired] [-RoleGroupId <String>]
 -CustomPrivilegesObject <PSObject> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
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
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-Custom
```
Set-LMRole -Name <String> [-NewName <String>] [-CustomHelpLabel <String>] [-CustomHelpURL <String>]
 [-Description <String>] [-RequireEULA] [-TwoFARequired] [-RoleGroupId <String>]
 -CustomPrivilegesObject <PSObject> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
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
Specifies LMX ToolBox permissions.
Valid values: "view", "manage", "commit", "publish", "none".
Default is "none".

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
Specifies LMX permissions.
Valid values: "view", "install", "none".
Default is "none".

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
Specifies logs permissions.
Valid values: "view", "manage", "none".
Default is "none".

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
Specifies websites permissions.
Valid values: "view", "manage", "none".
Default is "none".

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
Specifies saved maps permissions.
Valid values: "view", "manage", "none".
Default is "none".

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
Specifies reports permissions.
Valid values: "view", "manage", "none".
Default is "none".

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
Indicates whether the role can create private dashboards.

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
Indicates whether the role can share widgets.

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
Indicates whether the config tab requires manage permission.

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
Indicates whether the role is allowed to view the maps tab.

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
Indicates whether the role is allowed to manage resource dashboards.

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
Indicates whether the role can view traces.

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
Indicates whether the role can view support options.

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
Indicates whether remote sessions are enabled for resources.

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

### Returns a LogicMonitor.Role object containing the updated role configuration.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
