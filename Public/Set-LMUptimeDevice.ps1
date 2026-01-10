<#
.SYNOPSIS
Updates an existing LogicMonitor Uptime device using the v3 device endpoint.

.DESCRIPTION
The Set-LMUptimeDevice cmdlet updates internal or external Uptime monitors (web or ping) by
submitting a PATCH request to the LogicMonitor v3 device endpoint. It resolves the device ID
from name when necessary, validates location combinations, and constructs the appropriate
payload structure before issuing the request. The Type parameter is mandatory and determines
the response structure returned by the API.

.PARAMETER Id
Specifies the device identifier to update. Accepts pipeline input by property name.

.PARAMETER Name
Specifies the device name to update. The cmdlet resolves the corresponding ID prior to issuing the request.

.PARAMETER Type
Specifies the Uptime monitor type. This parameter is mandatory and determines the response
structure. Valid values are uptimewebcheck and uptimepingcheck.

.PARAMETER PropertiesMethod
Determines how custom properties are applied when supplied. Valid values are Add, Replace, or Refresh.

.PARAMETER Description
Updates the description of the Uptime device.

.PARAMETER HostGroupIds
Sets the group identifiers assigned to the Uptime device.

.PARAMETER PollingInterval
Configures the polling interval in minutes.

.PARAMETER AlertTriggerInterval
Specifies the number of consecutive failures before alerting.

.PARAMETER GlobalSmAlertCond
Sets the synthetic monitoring global alert condition (all, half, moreThanOne, any).

.PARAMETER OverallAlertLevel
Configures the overall alert level (warn, error, critical).

.PARAMETER IndividualAlertLevel
Configures the individual alert level (warn, error, critical).

.PARAMETER IndividualSmAlertEnable
Enables or disables individual synthetic alerts.

.PARAMETER UseDefaultLocationSetting
Controls whether default location settings are used for the Uptime device.

.PARAMETER UseDefaultAlertSetting
Controls whether default alert settings are used for the Uptime device.

.PARAMETER Properties
Hashtable of custom properties to apply to the Uptime device.

.PARAMETER Template
Specifies an optional template identifier.

.PARAMETER Domain
Updates the domain for web checks.

.PARAMETER Schema
Defines the HTTP schema (http or https) for web checks.

.PARAMETER IgnoreSSL
Enables or disables SSL certificate validation warnings.

.PARAMETER PageLoadAlertTimeInMS
Sets the page load alert threshold for web checks.

.PARAMETER AlertExpr
Configures the SSL alert expression for web checks.

.PARAMETER TriggerSSLStatusAlert
Enables or disables SSL status alerts.

.PARAMETER TriggerSSLExpirationAlert
Enables or disables SSL expiration alerts.

.PARAMETER Steps
Provides an array of step definitions for web checks.

.PARAMETER Hostname
Updates the hostname/IP for ping checks.

.PARAMETER Count
Sets the number of ping attempts per polling cycle.

.PARAMETER PercentPktsNotReceiveInTime
Defines the allowed packet loss percentage before alerting.

.PARAMETER TimeoutInMSPktsNotReceive
Defines the timeout threshold in milliseconds for ping checks.

.PARAMETER TestLocationCollectorIds
Specifies collector identifiers for internal checks.

.PARAMETER TestLocationSmgIds
Specifies synthetic monitoring group identifiers for external checks.

.PARAMETER TestLocationAll
Indicates that all public locations should be used for external checks.

.EXAMPLE
Set-LMUptimeDevice -Id 123 -Type uptimewebcheck -PollingInterval 10 -AlertTriggerInterval 2

Updates the polling interval and alert trigger threshold for the web uptime device with ID 123.

.EXAMPLE
Set-LMUptimeDevice -Name "web-ext-01" -Type uptimewebcheck -TestLocationSmgIds 2,4,6 -TriggerSSLStatusAlert $true

Resolves the ID from the device name and updates external web check locations and SSL alerts.

.EXAMPLE
Set-LMUptimeDevice -Id 456 -Type uptimepingcheck -Description "Updated ping check"

Updates the description for the ping uptime device with ID 456.

.NOTES
You must run Connect-LMAccount before invoking this cmdlet. Requests are issued to

.OUTPUTS
LogicMonitor.LMUptimeDevice
#>
function Set-LMUptimeDevice {

    [CmdletBinding(DefaultParameterSetName = 'IdGeneral', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'IdGeneral', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'IdWeb', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'IdPing', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'NameGeneral')]
        [Parameter(Mandatory, ParameterSetName = 'NameWeb')]
        [Parameter(Mandatory, ParameterSetName = 'NamePing')]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory)]
        [ValidateSet('uptimewebcheck', 'uptimepingcheck')]
        [String]$Type,

        [ValidateSet('Add', 'Replace', 'Refresh')]
        [String]$PropertiesMethod = 'Replace',

        [String]$Description,

        [String[]]$HostGroupIds,

        [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)]
        [Nullable[Int]]$PollingInterval,

        [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 30, 60)]
        [Nullable[Int]]$AlertTriggerInterval,

        [ValidateSet('all', 'half', 'moreThanOne', 'any')]
        [String]$GlobalSmAlertCond,

        [ValidateSet('warn', 'error', 'critical')]
        [String]$OverallAlertLevel,

        [ValidateSet('warn', 'error', 'critical')]
        [String]$IndividualAlertLevel,

        [Nullable[bool]]$IndividualSmAlertEnable,

        [Nullable[bool]]$UseDefaultLocationSetting,

        [Nullable[bool]]$UseDefaultAlertSetting,

        [Hashtable]$Properties,

        [String]$Template,

        [Parameter(ParameterSetName = 'IdWeb')]
        [Parameter(ParameterSetName = 'NameWeb')]
        [String]$Domain,

        [Parameter(ParameterSetName = 'IdWeb')]
        [Parameter(ParameterSetName = 'NameWeb')]
        [ValidateSet('http', 'https')]
        [String]$Schema,

        [Parameter(ParameterSetName = 'IdWeb')]
        [Parameter(ParameterSetName = 'NameWeb')]
        [Nullable[bool]]$IgnoreSSL,

        [Parameter(ParameterSetName = 'IdWeb')]
        [Parameter(ParameterSetName = 'NameWeb')]
        [ValidateRange(1000, 600000)]
        [Nullable[Int]]$PageLoadAlertTimeInMS,

        [Parameter(ParameterSetName = 'IdWeb')]
        [Parameter(ParameterSetName = 'NameWeb')]
        [String]$AlertExpr,

        [Parameter(ParameterSetName = 'IdWeb')]
        [Parameter(ParameterSetName = 'NameWeb')]
        [Nullable[bool]]$TriggerSSLStatusAlert,

        [Parameter(ParameterSetName = 'IdWeb')]
        [Parameter(ParameterSetName = 'NameWeb')]
        [Nullable[bool]]$TriggerSSLExpirationAlert,

        [Parameter(ParameterSetName = 'IdWeb')]
        [Parameter(ParameterSetName = 'NameWeb')]
        [Hashtable[]]$Steps,

        [Parameter(ParameterSetName = 'IdPing')]
        [Parameter(ParameterSetName = 'NamePing')]
        [String]$Hostname,

        [Parameter(ParameterSetName = 'IdPing')]
        [Parameter(ParameterSetName = 'NamePing')]
        [ValidateSet(5, 10, 15, 20, 30, 50)]
        [Nullable[Int]]$Count,

        [Parameter(ParameterSetName = 'IdPing')]
        [Parameter(ParameterSetName = 'NamePing')]
        [ValidateSet(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)]
        [Nullable[Int]]$PercentPktsNotReceiveInTime,

        [Parameter(ParameterSetName = 'IdPing')]
        [Parameter(ParameterSetName = 'NamePing')]
        [ValidateRange(1, 60000)]
        [Nullable[Int]]$TimeoutInMSPktsNotReceive,

        [Int[]]$TestLocationCollectorIds,

        [Int[]]$TestLocationSmgIds,

        [Switch]$TestLocationAll
    )

    process {
        if (-not $Script:LMAuth.Valid) {
            Write-Error 'Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.'
            return
        }

        $parameterSet = $PSCmdlet.ParameterSetName
        $isWebParameterSet = $parameterSet -like '*Web'
        $isPingParameterSet = $parameterSet -like '*Ping'

        $resolvedName = $null
        if ($parameterSet -like 'Name*') {
            $lookupResult = (Get-LMDevice -Name $Name)
            if (Test-LookupResult -Result $lookupResult.Id -LookupString $Name) {
                return
            }

            if ($lookupResult.deviceType -notin 18, 19) {
                Write-Error "The specified device is not an Uptime device."
                return
            }

            $Id = $lookupResult.Id
            $resolvedName = $lookupResult.name
        }

        $isInternal = $null
        if ($PSBoundParameters.ContainsKey('TestLocationCollectorIds')) {
            $isInternal = $true
        }
        elseif ($PSBoundParameters.ContainsKey('TestLocationSmgIds') -or $PSBoundParameters.ContainsKey('TestLocationAll')) {
            $isInternal = $false
        }

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
        if ($explicitLocationSpecified){
            $UseDefaultLocationSetting = $false
        }

        if ($PSBoundParameters.ContainsKey('UseDefaultLocationSetting') -and -not $UseDefaultLocationSetting -and -not $explicitLocationSpecified) {
            Write-Error 'When UseDefaultLocationSetting is set to $false you must provide one of TestLocationAll, TestLocationCollectorIds, or TestLocationSmgIds.'
            return
        }

        $testLocation = $null
        if ($wasAllSpecified -or $wasCollectorSpecified -or $wasSmgSpecified -or $isInternal -ne $null) {
            try {
                $effectiveIsInternal = if ($isInternal -ne $null) { $isInternal } else { $true }
                $testLocation = Resolve-LMUptimeTestLocation -IsInternal $effectiveIsInternal -TestLocationAll $testLocationAllValue -TestLocationCollectorIds $collectorIdsValue -TestLocationSmgIds $smgIdsValue -AllowUnset:$UseDefaultLocationSetting -WasTestLocationAllSpecified:$wasAllSpecified -WasCollectorIdsSpecified:$wasCollectorSpecified -WasSmgIdsSpecified:$wasSmgSpecified
            }
            catch {
                Write-Error $_.Exception.Message
                return
            }
        }

        $customProperties = $null
        if ($PSBoundParameters.ContainsKey('Properties')) {
            $customProperties = ConvertTo-LMCustomPropertyArray -Properties $Properties
        }

        $payload = @{}

        foreach ($key in $PSBoundParameters.Keys) {
            switch ($key) {
                'Description' { $payload.description = $Description }
                'HostGroupIds' { $payload.hostGroupIds = @($HostGroupIds | ForEach-Object { [String]$_ }) }
                'PollingInterval' { $payload.pollingInterval = $PollingInterval }
                'AlertTriggerInterval' { $payload.transition = $AlertTriggerInterval }
                'GlobalSmAlertCond' {
                    try {
                        $payload.globalSmAlertCond = Resolve-LMUptimeGlobalSmAlertCond -Value $GlobalSmAlertCond
                    }
                    catch {
                        Write-Error $_.Exception.Message
                        return
                    }
                }
                'OverallAlertLevel' { $payload.overallAlertLevel = $OverallAlertLevel }
                'IndividualAlertLevel' { $payload.individualAlertLevel = $IndividualAlertLevel }
                'IndividualSmAlertEnable' { $payload.individualSmAlertEnable = [bool]$IndividualSmAlertEnable }
                'UseDefaultLocationSetting' { $payload.useDefaultLocationSetting = [bool]$UseDefaultLocationSetting }
                'UseDefaultAlertSetting' { $payload.useDefaultAlertSetting = [bool]$UseDefaultAlertSetting }
                'Template' { $payload.template = $Template }
                'Domain' { $payload.domain = $Domain }
                'Schema' { $payload.schema = $Schema }
                'IgnoreSSL' { $payload.ignoreSSL = [bool]$IgnoreSSL }
                'PageLoadAlertTimeInMS' { $payload.pageLoadAlertTimeInMS = $PageLoadAlertTimeInMS }
                'AlertExpr' { $payload.alertExpr = $AlertExpr }
                'TriggerSSLStatusAlert' { $payload.triggerSSLStatusAlert = [bool]$TriggerSSLStatusAlert }
                'TriggerSSLExpirationAlert' { $payload.triggerSSLExpirationAlert = [bool]$TriggerSSLExpirationAlert }
                'Steps' { $payload.steps = $Steps }
                'Hostname' { $payload.host = $Hostname }
                'Count' { $payload.count = $Count }
                'PercentPktsNotReceiveInTime' { $payload.percentPktsNotReceiveInTime = $PercentPktsNotReceiveInTime }
                'TimeoutInMSPktsNotReceive' { $payload.timeoutInMSPktsNotReceive = $TimeoutInMSPktsNotReceive }
            }
        }

        if ($customProperties) {
            $payload.customProperties = $customProperties
        }

        if ($testLocation) {
            $payload.testLocation = $testLocation
        }

        foreach ($key in @($payload.Keys)) {
            if ($null -eq $payload[$key]) {
                $payload.Remove($key)
            }
        }

        if ($payload.Count -eq 0) {
            Write-Verbose 'No updates were specified.'
            return
        }

        $resourcePath = "/device/devices/$Id"
        $query = "?opType=$($PropertiesMethod.ToLower())&type=$Type"

        $jsonPayload = Format-LMData -Data $payload -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys -AlwaysKeepKeys @('groupIds', 'properties', 'steps', 'testLocation') -ConditionalValueKeep @{ 'PropertiesMethod' = @(@{ Value = 'Refresh'; KeepKeys = @('properties') }) } -Context @{ PropertiesMethod = $PropertiesMethod } -JsonDepth 20

        $messageName = if ($resolvedName) { $resolvedName } elseif ($parameterSet -like 'Name*') { $Name } else { $null }
        $typeLabel = if ($isWebParameterSet) { 'webcheck' } elseif ($isPingParameterSet) { 'pingcheck' } else { 'uptime' }
        $messageCore = if ($messageName) { "Id: $Id | Name: $messageName" } else { "Id: $Id" }
        $message = "$messageCore | Type: $typeLabel"

        if ($PSCmdlet.ShouldProcess($message, 'Update Uptime Device')) {
            $headers = New-LMHeader -Auth $Script:LMAuth -Method 'PATCH' -ResourcePath $resourcePath -Data $jsonPayload -Version 3
            $uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)$resourcePath$query"

            Resolve-LMDebugInfo -Url $uri -Headers $headers[0] -Command $MyInvocation -Payload $jsonPayload

            $response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $uri -Method 'PATCH' -Headers $headers[0] -WebSession $headers[1] -Body $jsonPayload

            return (Add-ObjectTypeInfo -InputObject $response -TypeName 'LogicMonitor.LMUptimeDevice')
        }
    }
}

