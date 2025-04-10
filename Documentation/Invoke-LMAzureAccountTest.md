---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMAzureAccountTest

## SYNOPSIS
Tests Azure account connectivity in LogicMonitor.

## SYNTAX

```
Invoke-LMAzureAccountTest [-ClientId] <String> [-SecretKey] <String> [[-CheckedServices] <String>]
 [-SubscriptionIds] <String> [[-GroupId] <String>] [-TenantId] <String> [[-IsChinaAccount] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMAzureAccountTest function tests the connection and permissions for an Azure account in LogicMonitor.
It verifies access to specified Azure services.

## EXAMPLES

### EXAMPLE 1
```
#Test Azure account connectivity
Invoke-LMAzureAccountTest -ClientId "client-id" -SecretKey "secret-key" -TenantId "tenant-id" -SubscriptionIds "sub-id"
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

### -CheckedServices
The list of Azure services to test.
Defaults to all supported services.

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
The Azure subscription IDs to test.

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
The LogicMonitor group ID to associate with the Azure account.
Defaults to -1.

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
The Azure Active Directory tenant ID.

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
Indicates if this is an Azure China account.
Defaults to $false.

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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns test results for each Azure service.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
