<#
.SYNOPSIS
Creates a new LogicMonitor website or ping check.

.DESCRIPTION
The New-LMWebsite function is used to create a new LogicMonitor website or ping check. It allows you to specify various parameters such as the type of check (website or ping), the name of the check, the description, and other settings related to monitoring and alerting.

.PARAMETER WebCheck
Specifies that the check type is a website check. This parameter is mutually exclusive with the PingCheck parameter.

.PARAMETER PingCheck
Specifies that the check type is a ping check. This parameter is mutually exclusive with the WebCheck parameter.

.PARAMETER Name
Specifies the name of the check.

.PARAMETER IsInternal
Specifies whether the check is internal or external. By default, it is set to $false.

.PARAMETER Description
Specifies the description of the check.

.PARAMETER DisableAlerting
Specifies whether alerting is disabled for the check.

.PARAMETER StopMonitoring
Specifies whether monitoring is stopped for the check.

.PARAMETER UseDefaultAlertSetting
Specifies whether to use the default alert settings for the check.

.PARAMETER UseDefaultLocationSetting
Specifies whether to use the default location settings for the check.

.PARAMETER TriggerSSLStatusAlert
Specifies whether to trigger an alert when the SSL status of the website check changes.

.PARAMETER TriggerSSLExpirationAlert
Specifies whether to trigger an alert when the SSL certificate of the website check is about to expire.

.PARAMETER GroupId
Specifies the ID of the group to which the check belongs.

.PARAMETER PingAddress
Specifies the address to ping for the ping check.

.PARAMETER WebsiteDomain
Specifies the domain of the website to check.

.PARAMETER HttpType
Specifies the HTTP type to use for the website check. The valid values are "http" and "https". The default value is "https".

.PARAMETER SSLAlertThresholds
Specifies the SSL alert thresholds for the website check.

.PARAMETER PingCount
Specifies the number of pings to send for the ping check. The valid values are 5, 10, 15, 20, 30, and 60.

.PARAMETER PingTimeout
Specifies the timeout for the ping check.

.PARAMETER PageLoadAlertTimeInMS
Specifies the page load alert time in milliseconds for the website check.

.PARAMETER IgnoreSSL
Specifies whether to ignore SSL errors for the website check.

.PARAMETER PingPercentNotReceived
Specifies the percentage of packets not received in time for the ping check. The valid values are 10, 20, 30, 40, 50, 60, 70, 80, 90, and 100.

.PARAMETER FailedCount
Specifies the number of consecutive failed checks required to trigger an alert. The valid values are 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 30, and 60.

.PARAMETER OverallAlertLevel
Specifies the overall alert level for the check. The valid values are "warn", "error", and "critical".

.PARAMETER IndividualAlertLevel
Specifies the individual alert level for the check. The valid values are "warn", "error", and "critical".

.PARAMETER Properties
Specifies additional custom properties for the check.

.PARAMETER PropertiesMethod
Specifies the method to use for handling custom properties. The valid values are "Add", "Replace", and "Refresh".

.PARAMETER PollingInterval
Specifies the polling interval for the check.

.PARAMETER WebsiteSteps
Specifies the steps to perform for the website check.

.PARAMETER CheckPoints
Specifies the check points for the check. This is a legacy parameter and will be deprecated in a future release.

.PARAMETER TestLocationAll
Specifies whether to test all locations. This parameter is only valid for external checks.

.PARAMETER TestLocationCollectorIds
Specifies the collector IDs for the test locations.

.PARAMETER TestLocationSmgIds
Specifies the SMG IDs for the test locations.

.EXAMPLE
New-LMWebsite -WebCheck -Name "Example Website" -WebsiteDomain "example.com" -HttpType "https" -GroupId "12345" -OverallAlertLevel "error" -IndividualAlertLevel "warn"

This example creates a new LogicMonitor website check for the website "example.com" with HTTPS protocol. It assigns the check to the group with ID "12345" and sets the overall alert level to "error" and the individual alert level to "warn".

.EXAMPLE
New-LMWebsite -PingCheck -Name "Example Ping" -PingAddress "192.168.1.1" -PingCount 5 -PingTimeout 1000 -GroupId "12345" -OverallAlertLevel "warn" -IndividualAlertLevel "warn"

This example creates a new LogicMonitor ping check for the IP address "192.168.1.1". It sends 5 pings with a timeout of 1000 milliseconds. It assigns the check to the group with ID "12345" and sets the overall alert level and individual alert level to "warn".

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Website object.
#>
function New-LMWebsite {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = "Website")]
        [Switch]$WebCheck,

        [Parameter(Mandatory, ParameterSetName = "Ping")]
        [Switch]$PingCheck,

        [Parameter(Mandatory)]
        [String]$Name,

        [Nullable[boolean]]$IsInternal = $false,

        [String]$Description,

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$StopMonitoring,

        [Nullable[boolean]]$UseDefaultAlertSetting = $true,

        [Nullable[boolean]]$UseDefaultLocationSetting = $true,

        [Parameter(ParameterSetName = "Website")]
        [Nullable[boolean]]$TriggerSSLStatusAlert,

        [Parameter(ParameterSetName = "Website")]
        [Nullable[boolean]]$TriggerSSLExpirationAlert,

        [String]$GroupId,

        [Parameter(Mandatory, ParameterSetName = "Ping")]
        [String]$PingAddress,

        [Parameter(Mandatory, ParameterSetName = "Website")]
        [String]$WebsiteDomain,

        [Parameter(ParameterSetName = "Website")]
        [ValidateSet("http", "https")]
        [String]$HttpType = "https",

        [Parameter(ParameterSetName = "Website")]
        [String[]]$SSLAlertThresholds,

        [Parameter(ParameterSetName = "Ping")]
        [ValidateSet(5, 10, 15, 20, 30, 60)]
        [Nullable[Int]]$PingCount,

        [Parameter(ParameterSetName = "Ping")]
        [Nullable[Int]]$PingTimeout,

        [Parameter(ParameterSetName = "Website")]
        [Nullable[Int]]$PageLoadAlertTimeInMS,

        [Parameter(ParameterSetName = "Website")]
        [Nullable[boolean]]$IgnoreSSL,

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
        [Object[]]$WebsiteSteps,

        [Parameter(ParameterSetName = "Website")]
        [Object[]]$CheckPoints,

        [Nullable[boolean]]$TestLocationAll, #Only valid for external checks

        [Int[]]$TestLocationCollectorIds,

        [Int[]]$TestLocationSmgIds
    )

    begin {
        # Function to validate test location parameters
        function ValidateTestLocationParameters {
            param (
                [Nullable[boolean]]$IsInternal,
                [Nullable[boolean]]$TestLocationAll,
                [Int[]]$TestLocationCollectorIds,
                [Int[]]$TestLocationSmgIds
            )

            $isValid = $true
            $errorMessage = ""

            # Check for mutually exclusive parameters
            if ($TestLocationSmgIds -and $IsInternal) {
                $errorMessage = "TestLocationSmgIds can only be used when IsInternal is false"
                $isValid = $false
            }
            elseif (!$IsInternal -and $TestLocationCollectorIds) {
                $errorMessage = "TestLocationCollectorIds can only be used when IsInternal is true"
                $isValid = $false
            }
            elseif ($TestLocationAll -and $TestLocationCollectorIds) {
                $errorMessage = "TestLocationAll cannot be used with TestLocationCollectorIds"
                $isValid = $false
            }
            elseif ($TestLocationAll -and $TestLocationSmgIds) {
                $errorMessage = "TestLocationAll cannot be used with TestLocationSmgIds"
                $isValid = $false
            }

            return @{
                IsValid      = $isValid
                ErrorMessage = $errorMessage
            }
        }
    }

    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            # Validate test location parameters
            $validationResult = ValidateTestLocationParameters -IsInternal $IsInternal -TestLocationAll $TestLocationAll -TestLocationCollectorIds $TestLocationCollectorIds -TestLocationSmgIds $TestLocationSmgIds
            if (-not $validationResult.IsValid) {
                Write-Error $validationResult.ErrorMessage
                return
            }

            if ($Webcheck) {
                $Type = "webcheck"
            }
            elseif ($PingCheck) {
                $Type = "pingcheck"
            }


            $Steps = @()
            if ($Type -eq "webcheck") {
                if ($WebsiteSteps) {
                    $Steps = $WebsiteSteps
                }
                else {
                    $Steps += [PSCustomObject]@{
                        useDefaultRoot    = $true
                        url               = ""
                        HTTPVersion       = "1.1"
                        HTTPMethod        = "GET"
                        HTTPHeaders       = ""
                        HTTPBody          = ""
                        followRedirection = $true
                        fullpageLoad      = $false
                        requireAuth       = $false
                        matchType         = "plain"
                        invertMatch       = $false
                        path              = ""
                        keyword           = ""
                        statusCode        = ""
                        type              = "config"
                        postDataEditType  = "raw"
                        auth              = @{
                            type     = "basic"
                            domain   = ""
                            userName = ""
                            password = ""
                        }
                    }
                }
            }

            #Build custom props hashtable
            $customProperties = @()
            if ($Properties) {
                foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }

            #Build header and uri
            $ResourcePath = "/website/websites"

            $AlertExp = ""
            if ($SSLAlertThresholds) {
                $AlertExp = "< " + $SSLAlertThresholds -join " "
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
                ignoreSSL                   = $IgnoreSSL
                percentPktsNotReceiveInTime = $PingPercentNotReceived
                timeoutInMSPktsNotReceive   = $PingTimeout
                transition                  = $FailedCount
                pageLoadAlertTimeInMS       = $PageLoadAlertTimeInMS
                alertExpr                   = $AlertExp
                schema                      = $HttpType
                domain                      = $WebsiteDomain
                type                        = $Type
                steps                       = $Steps
            }

            # Build testLocation object based on which parameter is provided
            $testLocation = $null
            if ($TestLocationAll) {
                $testLocation = @{ all = $true }
            }
            elseif ($TestLocationCollectorIds) {
                $testLocation = @{ 
                    collectorIds = $TestLocationCollectorIds
                }
            }
            elseif ($TestLocationSmgIds) {
                $testLocation = @{ smgIds = $TestLocationSmgIds }
            }
            elseif ($CheckPoints) {
                # Legacy support for CheckPoints parameter
                $TestLocations = [PSCustomObject]@{
                    all          = $true
                    smgIds       = @()
                    collectorIds = @($CheckPoints.smgId.GetEnumerator() | ForEach-Object { if ($_ -ne 0) { [Int]$_ } })
                }
                $testLocation = $TestLocations
                $Data.checkpoints = $CheckPoints
            }

            # Add testLocation to data if it exists
            if ($testLocation) {
                $Data.testLocation = $testLocation
            }

            # Set default based on specified testLocations
            if($TestLocationCollectorIds -or $TestLocationSmgIds){
                $Data.useDefaultLocationSetting = $false
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys @() `
                -AlwaysKeepKeys @('testLocation', 'steps', 'checkpoints') `
                -ConditionalValueKeep @{ 'PropertiesMethod' = @(@{ Value = 'Refresh'; KeepKeys = @('customProperties') }) } `
                -Context @{ PropertiesMethod = $PropertiesMethod }

            $Message = "Name: $Name | Type: $Type"

            if ($PSCmdlet.ShouldProcess($Message, "Create Website")) {
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request using new centralized method with retry logic
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Website" )

            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
