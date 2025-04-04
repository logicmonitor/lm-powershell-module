---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAPIUser

## SYNOPSIS
Creates a new LogicMonitor API user.

## SYNTAX

```
New-LMAPIUser [-Username] <String> [[-UserGroups] <String[]>] [[-Note] <String>] [[-RoleNames] <String[]>]
 [[-Status] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAPIUser function creates a new API-only user in LogicMonitor with specified roles and group memberships.

## EXAMPLES

### EXAMPLE 1
```
#Create a new API user
New-LMAPIUser -Username "api.user" -UserGroups @("Group1","Group2") -RoleNames @("admin") -Note "API user for automation"
```

## PARAMETERS

### -Username
The username for the new API user.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserGroups
The user groups to add the new user to.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Note
A note describing the purpose of the API user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleNames
The roles to assign to the user.
Defaults to "readonly".

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: @("readonly")
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
The status of the user.
Valid values are "active" and "suspended".
Defaults to "active".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Active
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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns the created user object.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
