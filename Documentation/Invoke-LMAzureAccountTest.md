---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMAzureAccountTest

## SYNOPSIS
Invokes a test on an Azure account.

## SYNTAX

```
Invoke-LMAzureAccountTest [-ClientId] <String> [-SecretKey] <String> [[-CheckedServices] <String>]
 [-SubscriptionIds] <String> [[-GroupId] <String>] [-TenantId] <String> [[-IsChinaAccount] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMAzureAccountTest function is used to invoke a test on an Azure account.
It checks if the user is logged in and has valid API credentials.
If the user is logged in, it builds the necessary headers and URI, and then sends a POST request to the specified endpoint.
The function returns the response from the API.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMAzureAccountTest -ClientId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -SecretKey "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -SubscriptionIds "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

This example invokes a test on an Azure account using the specified client ID, secret key, and subscription IDs.

## PARAMETERS

### -ClientId
The client ID of the Azure account.

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
The secret key of the Azure account.

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

### -CheckedServices
The list of services to be checked.
Default value is a list of commonly used Azure services.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: VIRTUALMACHINE,SQLDATABASE,APPSERVICE,EVENTHUB,REDISCACHE,REDISCACHEENTERPRISE,VIRTUALMACHINESCALESET,VIRTUALMACHINESCALESETVM,APPLICATIONGATEWAY,IOTHUB,FUNCTION,SERVICEBUS,MARIADB,MYSQL,MYSQLFLEXIBLE,POSTGRESQL,POSTGRESQLFLEXIBLE,POSTGRESQLCITUS,ANALYSISSERVICE,TABLESTORAGE,BLOBSTORAGE,FILESTORAGE,QUEUESTORAGE,STORAGEACCOUNT,APIMANAGEMENT,COSMOSDB,APPSERVICEPLAN,VIRTUALNETWORKGATEWAY,AUTOMATIONACCOUNT,EXPRESSROUTECIRCUIT,DATALAKEANALYTICS,DATALAKESTORE,APPLICATIONINSIGHTS,FIREWALL,SQLELASTICPOOL,SQLMANAGEDINSTANCE,HDINSIGHT,RECOVERYSERVICES,BACKUPPROTECTEDITEMS,RECOVERYPROTECTEDITEMS,NETWORKINTERFACE,BATCHACCOUNT,LOGICAPPS,DATAFACTORY,PUBLICIP,STREAMANALYTICS,EVENTGRID,LOADBALANCERS,SERVICEFABRICMESH,COGNITIVESEARCH,COGNITIVESERVICES,MLWORKSPACES,FRONTDOORS,KEYVAULT,RELAYNAMESPACES,NOTIFICATIONHUBS,APPSERVICEENVIRONMENT,TRAFFICMANAGER,SIGNALR,VIRTUALDESKTOP,SYNAPSEWORKSPACES,NETAPPPOOLS,DATABRICKS,LOGANALYTICSWORKSPACES,VIRTUALHUBS,VPNGATEWAYS,CDNPROFILE,POWERBIEMBEDDED,CONTAINERREGISTRY,NATGATEWAYS,BOTSERVICES,VIRTUALNETWORKS
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionIds
The subscription IDs associated with the Azure account.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupId
The group ID.
Default value is -1.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantId
The tenant ID of the Azure account.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
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
Position: 7
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
