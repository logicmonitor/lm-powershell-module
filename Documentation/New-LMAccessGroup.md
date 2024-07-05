---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAccessGroup

## SYNOPSIS
Creates a new LogicMonitor access group.

## SYNTAX

```
New-LMAccessGroup [-Name] <String> [[-Description] <String>] [[-Tenant] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAccessGroup function is used to create a new access group in LogicMonitor.
An access group is a collection of users with similar permissions and access rights for managing modules in the LM exchange and my module toolbox.

## EXAMPLES

### EXAMPLE 1
```
New-LMAccessGroup -Name "Group1" -Description "Access group for administrators" -Tenant "12345"
```

This example creates a new access group named "Group1" with the description "Access group for administrators" and assigns it to the tenant with ID "12345".

## PARAMETERS

### -Name
The name of the access group.
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

### -Description
The description of the access group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
The ID of the tenant to which the access group belongs.

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
For this function to work, you need to be logged in and have valid API credentials.
Use the Connect-LMAccount function to log in before running any commands.

## RELATED LINKS
