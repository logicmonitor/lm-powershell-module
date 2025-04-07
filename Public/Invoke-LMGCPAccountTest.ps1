<#
.SYNOPSIS
Tests GCP account connectivity in LogicMonitor.

.DESCRIPTION
The Invoke-LMGCPAccountTest function tests the connection and permissions for a Google Cloud Platform account in LogicMonitor.

.PARAMETER ServiceAccountKey
The GCP service account key JSON.

.PARAMETER ProjectId
The GCP project ID.

.PARAMETER CheckedServices
The list of GCP services to test. Defaults to all supported services.

.PARAMETER GroupId
The LogicMonitor group ID to associate with the GCP account. Defaults to -1.

.EXAMPLE
#Test GCP account connectivity
Invoke-LMGCPAccountTest -ServiceAccountKey "key-json" -ProjectId "project-id"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns test results for each GCP service.
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
