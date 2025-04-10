<#
.SYNOPSIS
Updates a LogicMonitor website monitoring configuration.

.DESCRIPTION
The Set-LMWebsite function modifies an existing website monitoring configuration in LogicMonitor.

.PARAMETER Id
Specifies the ID of the website to modify.

.PARAMETER Name
Specifies the name for the website.

.PARAMETER IsInternal
Indicates whether the website is internal.

.PARAMETER Description
Specifies the description for the website.

.PARAMETER DisableAlerting
Indicates whether to disable alerting for the website.

.PARAMETER StopMonitoring
Indicates whether to stop monitoring the website.

.PARAMETER UseDefaultAlertSetting
Indicates whether to use default alert settings.

.PARAMETER UseDefaultLocationSetting
Indicates whether to use default location settings.

.PARAMETER TriggerSSLStatusAlert
Indicates whether to trigger SSL status alerts.

.PARAMETER TriggerSSLExpirationAlert
Indicates whether to trigger SSL expiration alerts.

.PARAMETER GroupId
Specifies the group ID for the website.

.PARAMETER Properties
Specifies a hashtable of custom properties for the website.

.PARAMETER PropertiesMethod
Specifies how to handle properties. Valid values: "Add", "Replace", "Refresh".

.PARAMETER PollingInterval
Specifies the polling interval. Valid values: 1-10, 30, 60.

.EXAMPLE
Set-LMWebsite -Id 123 -Name "Updated Site" -Description "New description" -DisableAlerting $false
Updates the website with new name, description, and enables alerting.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.Website object containing the updated configuration.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

Function Set-LMWebsite {

    [CmdletBinding(DefaultParameterSetName = "Website")]
    Param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$Id,

        [String]$Name,

        [Nullable[boolean]]$IsInternal,

        [String]$Description,

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$StopMonitoring,

        [Nullable[boolean]]$UseDefaultAlertSetting,

        [Nullable[boolean]]$UseDefaultLocationSetting,

        [Parameter(ParameterSetName = "Website")]
        [Nullable[boolean]]$TriggerSSLStatusAlert,
        
        [Parameter(ParameterSetName = "Website")]
        [Nullable[boolean]]$TriggerSSLExpirationAlert,

        [String]$GroupId,

        [Parameter(ParameterSetName = "Ping")]
        [String]$PingAddress,

        [Parameter(ParameterSetName = "Website")]
        [String]$WebsiteDomain,

        [ValidateSet("http", "https")]
        [Parameter(ParameterSetName = "Website")]
        [String]$HttpType,

        [Parameter(ParameterSetName = "Website")]
        [String[]]$SSLAlertThresholds,
        
        [Parameter(ParameterSetName = "Ping")]
        [ValidateSet(5, 10, 15, 20, 30, 60)]
        [Nullable[Int]]$PingCount,

        [Parameter(ParameterSetName = "Ping")]
        [Nullable[Int]]$PingTimeout,

        [Parameter(ParameterSetName = "Website")]
        [Nullable[Int]]$PageLoadAlertTimeInMS,

        [Parameter(ParameterSetName = "Ping")]
        [ValidateSet(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)]
        [Nullable[Int]]$PingPercentNotReceived,

        [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 30, 60)]
        [Nullable[Int]]$FailedCount,

        [ValidateSet("warn", "error", "critical")]
        [String]$OverallAlertLevel,

        [ValidateSet("warn", "error", "critical")]
        [String]$IndividualAlertLevel,

        [Hashtable]$Properties,

        [ValidateSet("Add", "Replace", "Refresh")] # Add will append to existing prop, Replace will update existing props if specified and add new props, refresh will replace existing props with new
        [String]$PropertiesMethod = "Replace",

        [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)]
        [Nullable[Int]]$PollingInterval,

        [Parameter(ParameterSetName = "Website")]
        [String[]]$WebsiteSteps
    )

    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Id by name
            If ($Name) {
                $LookupResult = (Get-LMWebsite -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build custom props hashtable
            $customProperties = @()
            If ($Properties) {
                Foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }
                    
            #Build header and uri
            $ResourcePath = "/website/websites/$Id"

            Try {
                $alertExpr = $null
                If ($SSLAlertThresholds) {
                    $alertExpr = "< " + $SSLAlertThresholds -join " "
                }

                $Data = @{
                    name                        = $Name
                    description                 = $Description
                    disableAlerting             = $DisableAlerting
                    isInternal                  = $IsInternal
                    properties                  = $customProperties
                    stopMonitoring              = $StopMonitoring
                    groupId                     = $GroupId
                    pollingInterval             = $PollingInterval
                    overallAlertLevel           = $OverallAlertLevel
                    individualAlertLevel        = $IndividualAlertLevel
                    useDefaultAlertSetting      = $UseDefaultAlertSetting
                    useDefaultLocationSetting   = $UseDefaultLocationSetting
                    host                        = $PingAddress
                    triggerSSLStatusAlert       = $TriggerSSLStatusAlert
                    triggerSSLExpirationAlert   = $TriggerSSLExpirationAlert
                    count                       = $PingCount
                    percentPktsNotReceiveInTime = $PingPercentNotReceived
                    timeoutInMSPktsNotReceive   = $PingTimeout
                    transition                  = $FailedCount
                    pageLoadAlertTimeInMS       = $PageLoadAlertTimeInMS
                    alertExpr                   = $alertExpr
                    schema                      = $HttpType
                    domain                      = $WebsiteDomain
                    steps                       = $WebsiteSteps

                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { If ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Website" )
            }
            Catch [Exception] {
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
    End {}
}
