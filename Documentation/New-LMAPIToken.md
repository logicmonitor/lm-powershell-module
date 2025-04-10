---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAPIToken

## SYNOPSIS
Creates a new LogicMonitor API token.

## SYNTAX

### Id
```
New-LMAPIToken -Id <String[]> [-Note <String>] [-CreateDisabled] [-Type <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Username
```
New-LMAPIToken -Username <String> [-Note <String>] [-CreateDisabled] [-Type <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAPIToken function creates a new API token for a specified user in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
#Create a token by user ID
New-LMAPIToken -Id "12345" -Note "API Token for automation"
```

### EXAMPLE 2
```
#Create a token by username
New-LMAPIToken -Username "john.doe" -Type "Bearer" -CreateDisabled
```

## PARAMETERS

### -Id
The ID of the user to create the token for.
Required for Id parameter set.

```yaml
Type: String[]
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
The username to create the token for.
Required for Username parameter set.

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

### -Note
A note describing the purpose of the API token.

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

### -CreateDisabled
Switch to create the token in a disabled state.

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

### -Type
The type of API token to create.
Valid values are "LMv1" and "Bearer".
Defaults to "LMv1".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: LMv1
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

### Returns LogicMonitor.APIToken object.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
