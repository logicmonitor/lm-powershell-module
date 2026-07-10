---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Invoke-LMAWSAccountTest
---

# Invoke-LMAWSAccountTest

## SYNOPSIS

Tests AWS account connectivity in LogicMonitor.

## SYNTAX

### __AllParameterSets

```
Invoke-LMAWSAccountTest [-ExternalId] <string> [[-AccountId] <string>] [-AssumedRoleARN] <string>
 [[-CheckedServices] <string>] [[-GroupId] <string>] [<CommonParameters>]
```

## DESCRIPTION

The Invoke-LMAWSAccountTest function tests the connection and permissions for an AWS account in LogicMonitor.
It verifies access to specified AWS services.

## EXAMPLES

### EXAMPLE 1

#Test AWS account connectivity
Invoke-LMAWSAccountTest -ExternalId "123456" -AccountId "987654" -AssumedRoleARN "arn:aws:iam::123456789012:role/MyRole"

## PARAMETERS

### -AccountId

The AWS account ID.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AssumedRoleARN

The ARN of the IAM role to be assumed.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -CheckedServices

The list of AWS services to test.
Defaults to all supported services.

```yaml
Type: System.String
DefaultValue: DYNAMODB,EBS,EC2,AUTOSCALING,BACKUP,BACKUPPROTECTEDRESOURCE,TRANSFER,ELASTICACHE,ELB,RDS,REDSHIFT,S3,SNS,SQS,EMR,KINESIS,ROUTE53,ROUTE53HOSTEDZONE,CLOUDSEARCH,LAMBDA,ECR,ECS,ELASTICSEARCH,EFS,SWFWORKFLOW,SWFACTIVITY,APPLICATIONELB,CLOUDFRONT,APIGATEWAY,APIGATEWAYV2,SES,VPN,FIREHOSE,KINESISVIDEO,WORKSPACE,NETWORKELB,NATGATEWAY,DIRECTCONNECT,DIRECTCONNECT_VIRTUALINTERFACE,WORKSPACEDIRECTORY,ELASTICBEANSTALK,DMSREPLICATION,MSKCLUSTER,MSKBROKER,FSX,TRANSITGATEWAY,GLUE,APPSTREAM,MQ,ATHENA,DBCLUSTER,DOCDB,STEPFUNCTIONS,OPSWORKS,CODEBUILD,SAGEMAKER,ROUTE53RESOLVER,DMSREPLICATIONTASKS,EVENTBRIDGE,MEDIACONNECT,MEDIAPACKAGELIVE,MEDIASTORE,MEDIAPACKAGEVOD,MEDIATAILOR,MEDIACONVERT,ELASTICTRANSCODER,COGNITO,TRANSITGATEWAYATTACHMENT,QUICKSIGHT_DASHBOARDS,QUICKSIGHT_DATASETS,PRIVATELINK_ENDPOINTS,PRIVATELINK_SERVICES,GLOBAL_NETWORKS
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ExternalId

The external ID for AWS cross-account access.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GroupId

The LogicMonitor group ID to associate with the AWS account.
Defaults to -1.

```yaml
Type: System.String
DefaultValue: -1
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns test results for each AWS service.

### System.Object

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

