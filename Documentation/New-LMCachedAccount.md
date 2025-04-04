---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMCachedAccount

## SYNOPSIS
Creates a cached LogicMonitor account connection.

## SYNTAX

### LMv1 (Default)
```
New-LMCachedAccount -AccessId <String> -AccessKey <String> -AccountName <String> [-CachedAccountName <String>]
 [-OverwriteExisting <Boolean>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Bearer
```
New-LMCachedAccount -AccountName <String> -BearerToken <String> [-CachedAccountName <String>]
 [-OverwriteExisting <Boolean>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMCachedAccount function stores LogicMonitor portal credentials securely for use with Connect-LMAccount.

## EXAMPLES

### EXAMPLE 1
```
#Cache LMv1 credentials
New-LMCachedAccount -AccessId "id123" -AccessKey "key456" -AccountName "company"
```

### EXAMPLE 2
```
#Cache Bearer token
New-LMCachedAccount -BearerToken "token123" -AccountName "company" -CachedAccountName "prod"
```

## PARAMETERS

### -AccessId
The Access ID from your LogicMonitor API credentials.

```yaml
Type: String
Parameter Sets: LMv1
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessKey
The Access Key from your LogicMonitor API credentials.

```yaml
Type: String
Parameter Sets: LMv1
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountName
The portal subdomain (e.g., "company" for company.logicmonitor.com).

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

### -BearerToken
The Bearer token for authentication (alternative to AccessId/AccessKey).

```yaml
Type: String
Parameter Sets: Bearer
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CachedAccountName
The name to use for the cached account.
Defaults to AccountName.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $AccountName
Accept pipeline input: False
Accept wildcard characters: False
```

### -OverwriteExisting
Whether to overwrite an existing cached account.
Defaults to false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### None. Returns success message if account is cached successfully.
## NOTES
This command creates a secure vault to store credentials if one doesn't exist.

## RELATED LINKS
