<#
.SYNOPSIS
Invokes a test for a GCP (Google Cloud Platform) account.

.DESCRIPTION
The Invoke-LMGCPAccountTest function is used to invoke a test for a GCP account. It checks if the user is logged in and has valid API credentials. If the user is logged in, it builds the necessary headers and URI, prepares the data, and sends a POST request to the LogicMonitor API to perform the test. The function returns the response from the API.

.PARAMETER ServiceAccountKey
The service account key for the GCP account.

.PARAMETER ProjectId
The ID of the GCP project.

.PARAMETER CheckedServices
(Optional) A comma-separated list of GCP services to be checked. The default value is a list of all LM supported GCP services.

.PARAMETER GroupId
(Optional) The ID of the group to which the GCP account belongs. The default value is -1, indicating no group.

.EXAMPLE
Invoke-LMGCPAccountTest -ServiceAccountKey "service-account-key" -ProjectId "project-id"

This example invokes a test for a GCP account using the specified service account key and project ID.

.NOTES
This function requires the user to be logged in before running any commands. Use the Connect-LMAccount function to log in before invoking this function.
#>
Function Invoke-LMGCPAccountTest {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$ServiceAccountKey,

        [Parameter(Mandatory)]
        [String]$ProjectId,

        [String]$CheckedServices = "CLOUDRUN,CLOUDDNS,REGIONALHTTPSLOADBALANCER,COMPUTEENGINEAUTOSCALER,COMPUTEENGINE,CLOUDIOT,CLOUDROUTER,CLOUDTASKS,VPNGATEWAY,CLOUDREDIS,CLOUDCOMPOSER,INTERCONNECTATTACHMENT,CLOUDFUNCTION,CLOUDBIGTABLE,CLOUDFILESTORE,CLOUDPUBSUB,CLOUDTRACE,CLOUDSTORAGE,CLOUDDATAPROC,CLOUDINTERCONNECT,CLOUDAIPLATFORM,CLOUDSQL,MANAGEDSERVICEFORMICROSOFTAD,CLOUDFIRESTORE,CLOUDDATAFLOW,CLOUDTPU,CLOUDDLP,APPENGINE,HTTPSLOADBALANCER,CLOUDSPANNER",

        [String]$GroupId = -1

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/gcp/functions/testAccount"

        Try {
            $Data = @{
                serviceAccountKey   = $ServiceAccountKey
                projectId           = $ProjectId
                checkedServices     = $CheckedServices
                groupId             = $GroupId
            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
            Write-LMHost "All services have been tested successfully" -ForegroundColor Green
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
            Else{
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
