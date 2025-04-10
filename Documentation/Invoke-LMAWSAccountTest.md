---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMAWSAccountTest

## SYNOPSIS
Tests AWS account connectivity in LogicMonitor.

## SYNTAX

```
Invoke-LMAWSAccountTest [-ExternalId] <String> [[-AccountId] <String>] [-AssumedRoleARN] <String>
 [[-CheckedServices] <String>] [[-GroupId] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMAWSAccountTest function tests the connection and permissions for an AWS account in LogicMonitor.
It verifies access to specified AWS services.

## EXAMPLES

### EXAMPLE 1
```
#Test AWS account connectivity
Invoke-LMAWSAccountTest -ExternalId "123456" -AccountId "987654" -AssumedRoleARN "arn:aws:iam::123456789012:role/MyRole"
```

## PARAMETERS

### -ExternalId
The external ID for AWS cross-account access.

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
The AWS account ID.

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
The ARN of the IAM role to be assumed.

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
The list of AWS services to test.
Defaults to all supported services.

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
The LogicMonitor group ID to associate with the AWS account.
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

### Returns test results for each AWS service.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
