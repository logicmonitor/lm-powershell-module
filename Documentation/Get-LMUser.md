---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMUser

## SYNOPSIS
Retrieves LogicMonitor users based on specified parameters.

## SYNTAX

### All (Default)
```
Get-LMUser [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMUser [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMUser [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Filter
```
Get-LMUser [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### FilterWizard
```
Get-LMUser [-FilterWizard] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMUser function retrieves LogicMonitor users based on the specified parameters.
It supports filtering by ID, username, or custom filter.
The function uses the LogicMonitor REST API to make the requests.

## EXAMPLES

### EXAMPLE 1
```
Get-LMUser -Id 123
Retrieves the user with the specified ID.
```

### EXAMPLE 2
```
Get-LMUser -Name "username"
Retrieves the user with the specified username.
```

### EXAMPLE 3
```
Get-LMUser -Filter @{Property = "Value"}
Retrieves users based on the specified custom filter.
```

## PARAMETERS

### -Id
Specifies the ID of the user to retrieve.
This parameter is mutually exclusive with the Name and Filter parameters.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the username of the user to retrieve.
This parameter is mutually exclusive with the Id and Filter parameters.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Specifies a custom filter to retrieve users based on specific criteria.
This parameter is mutually exclusive with the Id and Name parameters.

```yaml
Type: Object
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterWizard
Specifies the use of the FilterWizard to assist in building a valid filter.
This parameter is mutually exclusive with the Id, Name, and Filter parameters.

```yaml
Type: SwitchParameter
Parameter Sets: FilterWizard
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
Specifies the number of users to retrieve in each batch.
The default value is 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
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

## NOTES
This function requires a valid LogicMonitor API authentication.
Use Connect-LMAccount to authenticate before running this command.

## RELATED LINKS
