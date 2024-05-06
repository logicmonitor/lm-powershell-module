---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMUserdata

## SYNOPSIS
Sets userdata for a LogicMonitor user.
Currently only setting the default dashboard is supported.

## SYNTAX

### Id (Default)
```
Set-LMUserdata -Id <String> -DashboardId <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name
```
Set-LMUserdata -Name <String> -DashboardId <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-LMUserdata function is used to set the user data for a LogicMonitor user.
It allows you to specify the user by either their Id or Name, and the dashboard Id for which the user data should be set.

## EXAMPLES

### EXAMPLE 1
```
Set-LMUserdata -Id "12345" -DashboardId "67890"
Sets the user data for the user with Id "12345" for the dashboard with Id "67890".
```

### EXAMPLE 2
```
Set-LMUserdata -Name "JohnDoe" -DashboardId "67890"
Sets the user data for the user with Name "JohnDoe" for the dashboard with Id "67890".
```

## PARAMETERS

### -Id
Specifies the Id of the user.
This parameter is mandatory when using the 'Id' parameter set.

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

### -Name
Specifies the Name of the user.
This parameter is mandatory when using the 'Name' parameter set.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DashboardId
Specifies the Id of the dashboard for which the user data should be set.
This parameter is mandatory.

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

### System.Object
### Returns the response from the LogicMonitor API.
## NOTES
This function requires a valid API authentication.
Make sure you are logged in before running any commands using Connect-LMAccount.

## RELATED LINKS
