---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMCachedAccount

## SYNOPSIS
Retrieves information about cached LogicMonitor account credentials.

## SYNTAX

```
Get-LMCachedAccount [[-CachedAccountName] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMCachedAccount function retrieves information about cached LogicMonitor account credentials stored in the Logic.Monitor vault.
It can return information for a specific cached account or all cached accounts.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve all cached accounts
Get-LMCachedAccount
```

### EXAMPLE 2
```
#Retrieve a specific cached account
Get-LMCachedAccount -CachedAccountName "MyAccount"
```

## PARAMETERS

### -CachedAccountName
The name of the specific cached account to retrieve information for.
If not specified, returns information for all cached accounts.

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

### Returns an array of custom objects containing cached account information including CachedAccountName, Portal, Id, Modified date, and Type.
## NOTES
This function requires access to the Logic.Monitor vault where credentials are stored.

## RELATED LINKS

[Get-SecretInfo]()

