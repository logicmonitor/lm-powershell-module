<#
.SYNOPSIS
Tests Azure account connectivity in LogicMonitor.

.DESCRIPTION
The Invoke-LMAzureAccountTest function tests the connection and permissions for an Azure account in LogicMonitor. It verifies access to specified Azure services.

.PARAMETER ClientId
The Azure Active Directory application client ID.

.PARAMETER SecretKey
The Azure Active Directory application secret key.

.PARAMETER CheckedServices
The list of Azure services to test. Defaults to all supported services.

.PARAMETER SubscriptionIds
The Azure subscription IDs to test.

.PARAMETER GroupId
The LogicMonitor group ID to associate with the Azure account. Defaults to -1.

.PARAMETER TenantId
The Azure Active Directory tenant ID.

.PARAMETER IsChinaAccount
Indicates if this is an Azure China account. Defaults to $false.

.EXAMPLE
#Test Azure account connectivity
Invoke-LMAzureAccountTest -ClientId "client-id" -SecretKey "secret-key" -TenantId "tenant-id" -SubscriptionIds "sub-id"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns test results for each Azure service.
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
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys @()

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

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