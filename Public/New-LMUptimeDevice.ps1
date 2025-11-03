<#
.SYNOPSIS
Creates a LogicMonitor Uptime device using the v3 device endpoint.

.DESCRIPTION
The New-LMUptimeDevice cmdlet provisions an Uptime web or ping monitor (internal or external)
through the LogicMonitor v3 device endpoint. It builds the appropriate payload shape, applies
validation to enforce supported combinations, and submits the request with the required
X-Version header. Supported monitor types include:
- Internal Web Checks
- External Web Checks
- Internal Ping Checks
- External Ping Checks

.PARAMETER Name
Specifies the device name. Required for every parameter set.

.PARAMETER HostGroupIds
Specifies one or more device group identifiers to assign to the Uptime device.

.PARAMETER Description
Provides an optional description for the device.

.PARAMETER PollingInterval
Sets the polling interval in minutes. Valid values are 1-10, 30 or 60.

.PARAMETER AlertTriggerInterval
Specifies the number of consecutive failures required to trigger an alert. Valid values are 1-10, 30, 60. Default is 1.

.PARAMETER GlobalSmAlertCond
Defines the global synthetic alert condition threshold.

.PARAMETER OverallAlertLevel
Specifies the alert level for overall checks. Valid values are warn, error, or critical.

.PARAMETER IndividualAlertLevel
Specifies the alert level for individual checks. Valid values are warn, error, or critical.

.PARAMETER IndividualSmAlertEnable
Indicates whether individual synthetic alerts are enabled. Defaults to $true.

.PARAMETER UseDefaultLocationSetting
Indicates whether default location settings should be used. Defaults to $true.

.PARAMETER UseDefaultAlertSetting
Indicates whether default alert settings should be used. Defaults to $true.

.PARAMETER Properties
Provides a hashtable of custom properties for the device. Keys map to property names.

.PARAMETER Template
Specifies an optional website template identifier.

.PARAMETER Domain
Specifies the domain for web checks. Required for web parameter sets.

.PARAMETER Schema
Defines the HTTP schema (http or https) for web checks. Defaults to https.

.PARAMETER IgnoreSSL
Indicates whether SSL warnings should be ignored for web checks. Defaults to $true.

.PARAMETER PageLoadAlertTimeInMS
Specifies the page load alert threshold in milliseconds for web checks.

.PARAMETER AlertExpr
Specifies the SSL alert expression for web checks.

.PARAMETER TriggerSSLStatusAlert
Indicates whether SSL status alerts are enabled for web checks.

.PARAMETER TriggerSSLExpirationAlert
Indicates whether SSL expiration alerts are enabled for web checks.

.PARAMETER Steps
Provides the scripted step definitions for web checks. Defaults to a single GET script step
when omitted.

.PARAMETER StatusCode
Specifies the expected status code for web checks. Defaults to 200.

.PARAMETER Keyword
Specifies the keyword to match for web checks. Defaults to empty string.

.PARAMETER FolderPath
Specifies the folder path to use for web checks. Defaults to empty string.

.PARAMETER Host
Specifies the host or IP for ping checks. Required for ping parameter sets.

.PARAMETER Count
Specifies ping attempts per collection for ping checks. Valid values: 5, 10, 15, 20, 30, 50.

.PARAMETER PercentPktsNotReceiveInTime
Defines the packet loss percentage threshold for ping checks.

.PARAMETER TimeoutInMSPktsNotReceive
Defines the packet response timeout threshold in milliseconds for ping checks.

.PARAMETER TestLocationCollectorIds
Specifies collector identifiers for internal checks. Required for internal parameter sets.

.PARAMETER TestLocationSmgIds
Specifies synthetic monitoring group identifiers for external checks.

.PARAMETER TestLocationAll
Indicates that all public locations should be used for external checks.

.EXAMPLE
New-LMUptimeDevice -Name "web-int-01" -HostGroupIds 17 -Domain "app.example.com" -TestLocationCollectorIds 12

Creates a new internal web uptime check against app.example.com using collector 12.

.EXAMPLE
New-LMUptimeDevice -Name "web-ext-01" -HostGroupIds 17 -Domain "app.example.com" -TestLocationSmgIds 2,3,4

Creates a new external web uptime check using the specified public locations.

.EXAMPLE
New-LMUptimeDevice -Name "ping-int-01" -HostGroupIds 17 -Host "intranet.local" -TestLocationCollectorIds 5

Creates an internal ping uptime check that targets intranet.local.

.EXAMPLE
New-LMUptimeDevice -Name "ping-ext-01" -HostGroupIds 17 -Host "api.example.net" -TestLocationSmgIds 2,4

Creates an external ping uptime check using the provided public locations.

.NOTES
You must run Connect-LMAccount before invoking this cmdlet. This function sends requests to
/device/devices with X-Version 3 and returns LogicMonitor.LMUptimeDevice objects.

.OUTPUTS
LogicMonitor.LMUptimeDevice
#>
function New-LMUptimeDevice {

    [CmdletBinding(DefaultParameterSetName = 'WebInternal', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'WebInternal')]
        [Parameter(Mandatory, ParameterSetName = 'WebExternal')]
        [Parameter(Mandatory, ParameterSetName = 'PingInternal')]
        [Parameter(Mandatory, ParameterSetName = 'PingExternal')]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'WebInternal')]
        [Parameter(Mandatory, ParameterSetName = 'WebExternal')]
        [Parameter(Mandatory, ParameterSetName = 'PingInternal')]
        [Parameter(Mandatory, ParameterSetName = 'PingExternal')]
        [ValidateNotNullOrEmpty()]
        [String[]]$HostGroupIds,

        [String]$Description,

        [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)]
        [Int]$PollingInterval = 5,

        [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 30, 60)]
        [Int]$AlertTriggerInterval = 1,

        [ValidateSet('all', 'half', 'moreThanOne', 'any')]
        [String]$GlobalSmAlertCond = 'all',

        [ValidateSet('warn', 'error', 'critical')]
        [String]$OverallAlertLevel = 'warn',

        [ValidateSet('warn', 'error', 'critical')]
        [String]$IndividualAlertLevel = 'error',

        [Bool]$IndividualSmAlertEnable = $true,

        [Bool]$UseDefaultLocationSetting = $true,

        [Bool]$UseDefaultAlertSetting = $true,

        [Object]$Properties,

        [String]$Template,

        [Parameter(Mandatory, ParameterSetName = 'WebInternal')]
        [Parameter(Mandatory, ParameterSetName = 'WebExternal')]
        [ValidateNotNullOrEmpty()]
        [String]$Domain,

        [Parameter(ParameterSetName = 'WebInternal')]
        [Parameter(ParameterSetName = 'WebExternal')]
        [String]$FolderPath = '',

        [Parameter(ParameterSetName = 'WebInternal')]
        [Parameter(ParameterSetName = 'WebExternal')]
        [String]$StatusCode = '200',

        [Parameter(ParameterSetName = 'WebInternal')]
        [Parameter(ParameterSetName = 'WebExternal')]
        [String]$Keyword = '',

        [Parameter(ParameterSetName = 'WebInternal')]
        [Parameter(ParameterSetName = 'WebExternal')]
        [ValidateSet('http', 'https')]
        [String]$Schema = 'https',

        [Parameter(ParameterSetName = 'WebInternal')]
        [Parameter(ParameterSetName = 'WebExternal')]
        [Bool]$IgnoreSSL = $true,

        [Parameter(ParameterSetName = 'WebInternal')]
        [Parameter(ParameterSetName = 'WebExternal')]
        [ValidateRange(1000, 600000)]
        [Int]$PageLoadAlertTimeInMS = 30000,

        [Parameter(ParameterSetName = 'WebInternal')]
        [Parameter(ParameterSetName = 'WebExternal')]
        [String]$AlertExpr,

        [Parameter(ParameterSetName = 'WebInternal')]
        [Parameter(ParameterSetName = 'WebExternal')]
        [Bool]$TriggerSSLStatusAlert = $false,

        [Parameter(ParameterSetName = 'WebInternal')]
        [Parameter(ParameterSetName = 'WebExternal')]
        [Bool]$TriggerSSLExpirationAlert = $false,

        [Parameter(ParameterSetName = 'WebInternal')]
        [Parameter(ParameterSetName = 'WebExternal')]
        [Hashtable[]]$Steps,

        [Parameter(Mandatory, ParameterSetName = 'PingInternal')]
        [Parameter(Mandatory, ParameterSetName = 'PingExternal')]
        [ValidateNotNullOrEmpty()]
        [String]$Hostname,

        [Parameter(ParameterSetName = 'PingInternal')]
        [Parameter(ParameterSetName = 'PingExternal')]
        [ValidateSet(5, 10, 15, 20, 30, 50)]
        [Int]$Count = 5,

        [Parameter(ParameterSetName = 'PingInternal')]
        [Parameter(ParameterSetName = 'PingExternal')]
        [ValidateRange(0, 100)]
        [Int]$PercentPktsNotReceiveInTime = 80,

        [Parameter(ParameterSetName = 'PingInternal')]
        [Parameter(ParameterSetName = 'PingExternal')]
        [ValidateRange(1, 60000)]
        [Int]$TimeoutInMSPktsNotReceive = 500,

        [Parameter(Mandatory, ParameterSetName = 'WebInternal')]
        [Parameter(Mandatory, ParameterSetName = 'PingInternal')]
        [ValidateNotNullOrEmpty()]
        [Int[]]$TestLocationCollectorIds,

        [Parameter(ParameterSetName = 'WebExternal')]
        [Parameter(ParameterSetName = 'PingExternal')]
        [Int[]]$TestLocationSmgIds,

        [Parameter(ParameterSetName = 'WebExternal')]
        [Parameter(ParameterSetName = 'PingExternal')]
        [Switch]$TestLocationAll
    )

    begin {
        function New-LMUptimeDefaultWebStep {
            param (
                [String]$StepName = '__step0'
            )

            return @(
                @{
                    type              = 'config'
                    enable            = $true
                    useDefaultRoot    = $true
                    url               = ''
                    HTTPVersion       = '1.1'
                    HTTPMethod        = 'GET'
                    name              = $StepName
                    followRedirection = $true
                    fullpageLoad      = $false
                    requireAuth       = $false
                    auth              = @{
                        domain   = ''
                        password = ''
                        type     = 'basic'
                        userName = ''
                    }
                    HTTPHeaders       = ''
                    reqType           = 'config'
                    respType          = 'config'
                    matchType         = 'plain'
                    keyword           = $Keyword
                    invertMatch       = 'false'
                    statusCode        = $StatusCode
                    path              = $FolderPath
                }
            )
        }
    }

    process {
        if (-not $Script:LMAuth.Valid) {
            Write-Error 'Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.'
            return
        }

        $parameterSet = $PSCmdlet.ParameterSetName
        $isWeb = $parameterSet -like 'Web*'
        $isInternal = $parameterSet -like '*Internal'

        $testLocationAllValue = $null
        $collectorIdsValue = $null
        $smgIdsValue = $null
        $wasAllSpecified = $false
        $wasCollectorSpecified = $false
        $wasSmgSpecified = $false

        if ($PSBoundParameters.ContainsKey('TestLocationAll')) {
            $testLocationAllValue = [bool]$TestLocationAll
            $wasAllSpecified = $true
        }

        if ($PSBoundParameters.ContainsKey('TestLocationCollectorIds')) {
            $collectorIdsValue = $TestLocationCollectorIds
            $wasCollectorSpecified = $true
        }

        if ($PSBoundParameters.ContainsKey('TestLocationSmgIds')) {
            $smgIdsValue = $TestLocationSmgIds
            $wasSmgSpecified = $true
        }

        $explicitLocationSpecified = $wasAllSpecified -or $wasCollectorSpecified -or $wasSmgSpecified
        if ($explicitLocationSpecified) {
            $UseDefaultLocationSetting = $false
        }

        if (-not $UseDefaultLocationSetting -and -not $explicitLocationSpecified) {
            Write-Error 'When UseDefaultLocationSetting is set to $false you must provide one of TestLocationAll, TestLocationCollectorIds, or TestLocationSmgIds.'
            return
        }

        $testLocation = $null
        try {
            $testLocation = Resolve-LMUptimeTestLocation -IsInternal $isInternal -TestLocationAll $testLocationAllValue -TestLocationCollectorIds $collectorIdsValue -TestLocationSmgIds $smgIdsValue -AllowUnset:$UseDefaultLocationSetting -WasTestLocationAllSpecified:$wasAllSpecified -WasCollectorIdsSpecified:$wasCollectorSpecified -WasSmgIdsSpecified:$wasSmgSpecified
        }
        catch {
            Write-Error $_.Exception.Message
            return
        }

        $customProperties = ConvertTo-LMCustomPropertyArray -Properties $Properties

        $stepsToSend = $null
        if ($isWeb) {
            if ($PSBoundParameters.ContainsKey('Steps') -and $Steps) {
                $stepsToSend = @()
                foreach ($step in $Steps) { $stepsToSend += $step }
            }
            else {
                $stepsToSend = @(New-LMUptimeDefaultWebStep)
            }

            $index = 0
            foreach ($step in $stepsToSend) {
                if (-not $step.ContainsKey('name') -or [string]::IsNullOrWhiteSpace($step.name)) {
                    $step.name = "__step$index"
                }

                $index++
            }
        }

        $resolvedGlobalSmAlertCond = $null
        try {
            $resolvedGlobalSmAlertCond = Resolve-LMUptimeGlobalSmAlertCond -Value $GlobalSmAlertCond
        }
        catch {
            Write-Error $_.Exception.Message
            return
        }

        $resourcePath = '/device/devices'
        $deviceType = if ($isWeb) { 18 } else { 19 }
        $deviceKind = if ($isWeb) { 'webcheck' } else { 'pingcheck' }

        $payload = @{
            type                      = $deviceKind
            model                     = 'websiteDevice'
            deviceType                = $deviceType
            id                        = 0
            name                      = $Name
            description               = $Description
            groupIds                  = @($HostGroupIds | ForEach-Object { [String]$_ })
            isInternal                = $isInternal
            individualSmAlertEnable   = [bool]$IndividualSmAlertEnable
            individualAlertLevel      = $IndividualAlertLevel
            overallAlertLevel         = $OverallAlertLevel
            pollingInterval           = $PollingInterval
            transition                = $AlertTriggerInterval
            globalSmAlertCond         = $resolvedGlobalSmAlertCond
            useDefaultLocationSetting = [bool]$UseDefaultLocationSetting
            useDefaultAlertSetting    = [bool]$UseDefaultAlertSetting
            testLocation              = $testLocation
            properties                = $customProperties
            template                  = $Template
        }

        if ($isWeb) {
            $payload.domain = $Domain
            $payload.schema = $Schema
            $payload.ignoreSSL = [bool]$IgnoreSSL
            $payload.pageLoadAlertTimeInMS = $PageLoadAlertTimeInMS
            $payload.alertExpr = $AlertExpr
            $payload.triggerSSLStatusAlert = [bool]$TriggerSSLStatusAlert
            $payload.triggerSSLExpirationAlert = [bool]$TriggerSSLExpirationAlert
            if ($stepsToSend) {
                $normalizedSteps = @()
                foreach ($step in $stepsToSend) { $normalizedSteps += $step }
                $payload.steps = $normalizedSteps
            }
        }
        else {
            $payload.host = $Hostname
            $payload.count = $Count
            $payload.percentPktsNotReceiveInTime = $PercentPktsNotReceiveInTime
            $payload.timeoutInMSPktsNotReceive = $TimeoutInMSPktsNotReceive
        }

        foreach ($key in @($payload.Keys)) {
            if ($null -eq $payload[$key]) {
                $payload.Remove($key)
            }
        }

        $jsonPayload = Format-LMData -Data $payload -UserSpecifiedKeys @() -AlwaysKeepKeys @('groupIds', 'properties', 'steps', 'testLocation') -JsonDepth 20

        $message = "Name: $Name | Type: $deviceKind | Internal: $isInternal"

        if ($PSCmdlet.ShouldProcess($message, 'Create Uptime Device')) {
            $headers = New-LMHeader -Auth $Script:LMAuth -Method 'POST' -ResourcePath $resourcePath -Data $jsonPayload -Version 3
            $uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)$resourcePath"

            Resolve-LMDebugInfo -Url $uri -Headers $headers[0] -Command $MyInvocation -Payload $jsonPayload

            $response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $uri -Method 'POST' -Headers $headers[0] -WebSession $headers[1] -Body $jsonPayload

            return (Add-ObjectTypeInfo -InputObject $response -TypeName 'LogicMonitor.LMUptimeDevice')
        }
    }
    end {}
}

