---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMAzureSubscriptionDiscovery

## SYNOPSIS
Invokes the Azure subscription discovery process to return subscriptions for a specified client Id.

## SYNTAX

```
Invoke-LMAzureSubscriptionDiscovery [-ClientId] <String> [-SecretKey] <String> [-TenantId] <String>
 [[-IsChinaAccount] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMAzureSubscriptionDiscovery function is used to discover Azure subscriptions by making API requests to the LogicMonitor platform.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMAzureSubscriptionDiscovery -ClientId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -SecretKey "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -TenantId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

## PARAMETERS

### -ClientId
The client ID of the Azure Active Directory application.

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
The secret key of the Azure Active Directory application.

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
The tenant ID of the Azure Active Directory application.

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
Specifies whether the Azure account is a China account.
Default value is $false.

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

## OUTPUTS

## NOTES

## RELATED LINKS
