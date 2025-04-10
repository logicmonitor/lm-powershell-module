---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMAzureSubscriptionDiscovery

## SYNOPSIS
Discovers Azure subscriptions for a given tenant.

## SYNTAX

```
Invoke-LMAzureSubscriptionDiscovery [-ClientId] <String> [-SecretKey] <String> [-TenantId] <String>
 [[-IsChinaAccount] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMAzureSubscriptionDiscovery function discovers available Azure subscriptions for a specified Azure tenant using provided credentials.

## EXAMPLES

### EXAMPLE 1
```
#Discover Azure subscriptions
Invoke-LMAzureSubscriptionDiscovery -ClientId "client-id" -SecretKey "secret-key" -TenantId "tenant-id"
```

## PARAMETERS

### -ClientId
The Azure Active Directory application client ID.

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

### -SecretKey
The Azure Active Directory application secret key.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantId
The Azure Active Directory tenant ID.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsChinaAccount
Indicates if this is an Azure China account.
Defaults to $false.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

### Returns a list of discovered Azure subscriptions.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
