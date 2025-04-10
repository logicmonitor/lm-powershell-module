---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMGCPAccountTest

## SYNOPSIS
Tests GCP account connectivity in LogicMonitor.

## SYNTAX

```
Invoke-LMGCPAccountTest [-ServiceAccountKey] <String> [-ProjectId] <String> [[-CheckedServices] <String>]
 [[-GroupId] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMGCPAccountTest function tests the connection and permissions for a Google Cloud Platform account in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
#Test GCP account connectivity
Invoke-LMGCPAccountTest -ServiceAccountKey "key-json" -ProjectId "project-id"
```

## PARAMETERS

### -ServiceAccountKey
The GCP service account key JSON.

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

### -ProjectId
The GCP project ID.

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
The list of GCP services to test.
Defaults to all supported services.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: CLOUDRUN,CLOUDDNS,REGIONALHTTPSLOADBALANCER,COMPUTEENGINEAUTOSCALER,COMPUTEENGINE,CLOUDIOT,CLOUDROUTER,CLOUDTASKS,VPNGATEWAY,CLOUDREDIS,CLOUDCOMPOSER,INTERCONNECTATTACHMENT,CLOUDFUNCTION,CLOUDBIGTABLE,CLOUDFILESTORE,CLOUDPUBSUB,CLOUDTRACE,CLOUDSTORAGE,CLOUDDATAPROC,CLOUDINTERCONNECT,CLOUDAIPLATFORM,CLOUDSQL,MANAGEDSERVICEFORMICROSOFTAD,CLOUDFIRESTORE,CLOUDDATAFLOW,CLOUDTPU,CLOUDDLP,APPENGINE,HTTPSLOADBALANCER,CLOUDSPANNER
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupId
The LogicMonitor group ID to associate with the GCP account.
Defaults to -1.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: -1
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

### Returns test results for each GCP service.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
