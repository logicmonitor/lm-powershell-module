---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMGCPAccountTest

## SYNOPSIS
Invokes a test for a GCP (Google Cloud Platform) account.

## SYNTAX

```
Invoke-LMGCPAccountTest [-ServiceAccountKey] <String> [-ProjectId] <String> [[-CheckedServices] <String>]
 [[-GroupId] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMGCPAccountTest function is used to invoke a test for a GCP account.
It checks if the user is logged in and has valid API credentials.
If the user is logged in, it builds the necessary headers and URI, prepares the data, and sends a POST request to the LogicMonitor API to perform the test.
The function returns the response from the API.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMGCPAccountTest -ServiceAccountKey "service-account-key" -ProjectId "project-id"
```

This example invokes a test for a GCP account using the specified service account key and project ID.

## PARAMETERS

### -ServiceAccountKey
The service account key for the GCP account.

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
The ID of the GCP project.

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
(Optional) A comma-separated list of GCP services to be checked.
The default value is a list of all LM supported GCP services.

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
(Optional) The ID of the group to which the GCP account belongs.
The default value is -1, indicating no group.

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

## OUTPUTS

## NOTES
This function requires the user to be logged in before running any commands.
Use the Connect-LMAccount function to log in before invoking this function.

## RELATED LINKS
