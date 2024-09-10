<#
.SYNOPSIS
    Invokes a test on an Azure account.

.DESCRIPTION
    The Invoke-LMAzureAccountTest function is used to invoke a test on an Azure account. It checks if the user is logged in and has valid API credentials. If the user is logged in, it builds the necessary headers and URI, and then sends a POST request to the specified endpoint. The function returns the response from the API.

.PARAMETER ClientId
    The client ID of the Azure account.

.PARAMETER SecretKey
    The secret key of the Azure account.

.PARAMETER CheckedServices
    The list of services to be checked. Default value is a list of commonly used Azure services.

.PARAMETER SubscriptionIds
    The subscription IDs associated with the Azure account.

.PARAMETER GroupId
    The group ID. Default value is -1.

.PARAMETER TenantId
    The tenant ID of the Azure account.

.PARAMETER IsChinaAccount
    Specifies whether the Azure account is a China account. Default value is $false.

.EXAMPLE
    Invoke-LMAzureAccountTest -ClientId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -SecretKey "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -SubscriptionIds "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    This example invokes a test on an Azure account using the specified client ID, secret key, and subscription IDs.
#>
Function Invoke-LMAzureAccountTest {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$ClientId,

        [Parameter(Mandatory)]
        [String]$SecretKey,

        [String]$CheckedServices = "VIRTUALMACHINE,SQLDATABASE,APPSERVICE,EVENTHUB,REDISCACHE,REDISCACHEENTERPRISE,VIRTUALMACHINESCALESET,VIRTUALMACHINESCALESETVM,APPLICATIONGATEWAY,IOTHUB,FUNCTION,SERVICEBUS,MARIADB,MYSQL,MYSQLFLEXIBLE,POSTGRESQL,POSTGRESQLFLEXIBLE,POSTGRESQLCITUS,ANALYSISSERVICE,TABLESTORAGE,BLOBSTORAGE,FILESTORAGE,QUEUESTORAGE,STORAGEACCOUNT,APIMANAGEMENT,COSMOSDB,APPSERVICEPLAN,VIRTUALNETWORKGATEWAY,AUTOMATIONACCOUNT,EXPRESSROUTECIRCUIT,DATALAKEANALYTICS,DATALAKESTORE,APPLICATIONINSIGHTS,FIREWALL,SQLELASTICPOOL,SQLMANAGEDINSTANCE,HDINSIGHT,RECOVERYSERVICES,BACKUPPROTECTEDITEMS,RECOVERYPROTECTEDITEMS,NETWORKINTERFACE,BATCHACCOUNT,LOGICAPPS,DATAFACTORY,PUBLICIP,STREAMANALYTICS,EVENTGRID,LOADBALANCERS,SERVICEFABRICMESH,COGNITIVESEARCH,COGNITIVESERVICES,MLWORKSPACES,FRONTDOORS,KEYVAULT,RELAYNAMESPACES,NOTIFICATIONHUBS,APPSERVICEENVIRONMENT,TRAFFICMANAGER,SIGNALR,VIRTUALDESKTOP,SYNAPSEWORKSPACES,NETAPPPOOLS,DATABRICKS,LOGANALYTICSWORKSPACES,VIRTUALHUBS,VPNGATEWAYS,CDNPROFILE,POWERBIEMBEDDED,CONTAINERREGISTRY,NATGATEWAYS,BOTSERVICES,VIRTUALNETWORKS",

        [Parameter(Mandatory)]
        [String]$SubscriptionIds,

        [String]$GroupId = -1,

        [Parameter(Mandatory)]
        [String]$TenantId,

        [String]$IsChinaAccount = $false

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/azure/functions/testAccount"

        Try {
            $Data = @{
                clientId        = $ClientId
                secretKey       = $SecretKey
                checkedServices = $CheckedServices
                subscriptionIds = $SubscriptionIds
                groupId         = $GroupId
                tenantId        = $TenantId
                isChinaAccount  = $IsChinaAccount

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
                ($PSItem.ErrorDetails.Message | ConvertFrom-Json).errorDetail.noPermissionServices.services.serviceName | ForEach-Object {
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