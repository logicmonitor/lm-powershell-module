---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMAWSAccountTest

## SYNOPSIS
Invokes a test for an AWS account in LogicMonitor.

## SYNTAX

```
Invoke-LMAWSAccountTest [-ExternalId] <String> [[-AccountId] <String>] [-AssumedRoleARN] <String>
 [[-CheckedServices] <String>] [[-GroupId] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMAWSAccountTest function is used to invoke a test for an AWS account in LogicMonitor.
It checks if the user is logged in and has valid API credentials.
If the user is logged in, it builds the necessary headers and URI, prepares the data, and sends a POST request to the LogicMonitor API to perform the test.
The function returns the response from the API.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMAWSAccountTest -ExternalId "123456" -AccountId "987654" -AssumedRoleARN "arn:aws:iam::123456789012:role/MyRole" -CheckedServices "EC2,S3,RDS" -GroupId 123
```

This example invokes a test for an AWS account with the specified parameters.

## PARAMETERS

### -ExternalId
The external ID of the AWS account.

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

### -AccountId
The account ID of the AWS account.

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

### -AssumedRoleARN
The assumed role ARN of the AWS account.

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

### -CheckedServices
The list of services to be checked during the test.
Default value is a comma-separated string of service names supported by LogicMonitor.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: DYNAMODB,EBS,EC2,AUTOSCALING,BACKUP,BACKUPPROTECTEDRESOURCE,TRANSFER,ELASTICACHE,ELB,RDS,REDSHIFT,S3,SNS,SQS,EMR,KINESIS,ROUTE53,ROUTE53HOSTEDZONE,CLOUDSEARCH,LAMBDA,ECR,ECS,ELASTICSEARCH,EFS,SWFWORKFLOW,SWFACTIVITY,APPLICATIONELB,CLOUDFRONT,APIGATEWAY,APIGATEWAYV2,SES,VPN,FIREHOSE,KINESISVIDEO,WORKSPACE,NETWORKELB,NATGATEWAY,DIRECTCONNECT,DIRECTCONNECT_VIRTUALINTERFACE,WORKSPACEDIRECTORY,ELASTICBEANSTALK,DMSREPLICATION,MSKCLUSTER,MSKBROKER,FSX,TRANSITGATEWAY,GLUE,APPSTREAM,MQ,ATHENA,DBCLUSTER,DOCDB,STEPFUNCTIONS,OPSWORKS,CODEBUILD,SAGEMAKER,ROUTE53RESOLVER,DMSREPLICATIONTASKS,EVENTBRIDGE,MEDIACONNECT,MEDIAPACKAGELIVE,MEDIASTORE,MEDIAPACKAGEVOD,MEDIATAILOR,MEDIACONVERT,ELASTICTRANSCODER,COGNITO,TRANSITGATEWAYATTACHMENT,QUICKSIGHT_DASHBOARDS,QUICKSIGHT_DATASETS,PRIVATELINK_ENDPOINTS,PRIVATELINK_SERVICES,GLOBAL_NETWORKS
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupId
The device group ID to which the AWS account belongs.
Default value is -1 for no group.

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
