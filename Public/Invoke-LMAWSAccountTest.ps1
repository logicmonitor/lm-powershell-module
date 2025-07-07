<#
.SYNOPSIS
Tests AWS account connectivity in LogicMonitor.

.DESCRIPTION
The Invoke-LMAWSAccountTest function tests the connection and permissions for an AWS account in LogicMonitor. It verifies access to specified AWS services.

.PARAMETER ExternalId
The external ID for AWS cross-account access.

.PARAMETER AccountId
The AWS account ID.

.PARAMETER AssumedRoleARN
The ARN of the IAM role to be assumed.

.PARAMETER CheckedServices
The list of AWS services to test. Defaults to all supported services.

.PARAMETER GroupId
The LogicMonitor group ID to associate with the AWS account. Defaults to -1.

.EXAMPLE
#Test AWS account connectivity
Invoke-LMAWSAccountTest -ExternalId "123456" -AccountId "987654" -AssumedRoleARN "arn:aws:iam::123456789012:role/MyRole"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns test results for each AWS service.
#>
function Invoke-LMAWSAccountTest {
    [CmdletBinding()]

    param (
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
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/aws/functions/testAccount"

        $Data = @{
            externalId      = $ExternalId
            accountId       = $AccountId
            assumedRoleArn  = $AssumedRoleARN
            checkedServices = $CheckedServices
            groupId         = $GroupId
        }

        #Remove empty keys so we dont overwrite them
        $Data = Format-LMData `
            -Data $Data `
            -UserSpecifiedKeys @()

        try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data | Out-Null
            Write-Information "All services have been tested successfully"
            return
        }
        catch {
            #Handle LMCloud test account permission errors
            if ($PSItem.Exception.Response.StatusCode.value__ -eq 400 -and $PSItem.Exception.Response.RequestMessage.RequestUri.AbsolutePath -like "*/testAccount") {
                $Result = @()
                ($PSItem.ErrorDetails.Message | ConvertFrom-Json).errorDetail.noPermissionServices | ForEach-Object {
                    $Result += [PSCustomObject]@{
                        Service    = $PSItem
                        TestResult = "You do not have permission to access the service"
                    }
                }
                return $Result
            }

            return
        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}