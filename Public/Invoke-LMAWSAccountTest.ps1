<#
.SYNOPSIS
Invokes a test for an AWS account in LogicMonitor.

.DESCRIPTION
The Invoke-LMAWSAccountTest function is used to invoke a test for an AWS account in LogicMonitor. It checks if the user is logged in and has valid API credentials. If the user is logged in, it builds the necessary headers and URI, prepares the data, and sends a POST request to the LogicMonitor API to perform the test. The function returns the response from the API.

.PARAMETER ExternalId
The external ID of the AWS account.

.PARAMETER AccountId
The account ID of the AWS account.

.PARAMETER AccessId
The access ID of the AWS account.

.PARAMETER AccessKey
The access key of the AWS account.

.PARAMETER AssumedRoleARN
The assumed role ARN of the AWS account.

.PARAMETER CheckedServices
The list of services to be checked during the test. Default value is a comma-separated string of service names supported by LogicMonitor.

.PARAMETER GroupId
The device group ID to which the AWS account belongs. Default value is -1 for no group.

.EXAMPLE
Invoke-LMAWSAccountTest -ExternalId "123456" -AccountId "987654" -AccessId "AKI123" -AccessKey "abc123" -AssumedRoleARN "arn:aws:iam::123456789012:role/MyRole" -CheckedServices "EC2,S3,RDS" -GroupId 123

This example invokes a test for an AWS account with the specified parameters.

.NOTES
This function requires the user to be logged in before running any commands. Use the Connect-LMAccount function to log in before invoking this function.
#>
Function Invoke-LMAWSAccountTest {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$ExternalId,

        [Parameter()]
        [String]$AccountId,

        [Parameter(Mandatory)]
        [String]$AssumedRoleARN,

        [String]$CheckedServices = "DYNAMODB,EBS,EC2,AUTOSCALING,BACKUP,BACKUPPROTECTEDRESOURCE,TRANSFER,ELASTICACHE,ELB,RDS,REDSHIFT,S3,SNS,SQS,EMR,KINESIS,ROUTE53,ROUTE53HOSTEDZONE,CLOUDSEARCH,LAMBDA,ECR,ECS,ELASTICSEARCH,EFS,SWFWORKFLOW,SWFACTIVITY,APPLICATIONELB,CLOUDFRONT,APIGATEWAY,APIGATEWAYV2,SES,VPN,FIREHOSE,KINESISVIDEO,WORKSPACE,NETWORKELB,NATGATEWAY,DIRECTCONNECT,DIRECTCONNECT_VIRTUALINTERFACE,WORKSPACEDIRECTORY,ELASTICBEANSTALK,DMSREPLICATION,MSKCLUSTER,MSKBROKER,FSX,TRANSITGATEWAY,GLUE,APPSTREAM,MQ,ATHENA,DBCLUSTER,DOCDB,STEPFUNCTIONS,OPSWORKS,CODEBUILD,SAGEMAKER,ROUTE53RESOLVER,DMSREPLICATIONTASKS,EVENTBRIDGE,MEDIACONNECT,MEDIAPACKAGELIVE,MEDIASTORE,MEDIAPACKAGEVOD,MEDIATAILOR,MEDIACONVERT,ELASTICTRANSCODER,COGNITO,TRANSITGATEWAYATTACHMENT,QUICKSIGHT_DASHBOARDS,QUICKSIGHT_DATASETS,PRIVATELINK_ENDPOINTS,PRIVATELINK_SERVICES,GLOBAL_NETWORKS",

        [String]$GroupId = -1

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/aws/functions/testAccount"

        Try {
            $Data = @{
                externalId      = $ExternalId
                accountId       = $AccountId
                assumedRoleArn  = $AssumedRoleARN
                checkedServices = $CheckedServices
                groupId         = $GroupId
            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
            Write-Information "All services have been tested successfully" 
            Return
        }
        Catch [Exception] {
            #Handle LMCloud test account permission errors
            If ($PSItem.Exception.Response.StatusCode.value__ -eq 400 -and $PSItem.Exception.Response.RequestMessage.RequestUri.AbsolutePath -like "*/testAccount") {
                $Result = @()
                ($PSItem.ErrorDetails.Message | ConvertFrom-Json).errorDetail.noPermissionServices | ForEach-Object {
                    $Result += [PSCustomObject]@{
                        Service = $PSItem
                        TestResult = "You do not have permission to access the service"
                    }
                }
                return $Result
            }
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}