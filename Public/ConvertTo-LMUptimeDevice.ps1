<#
.SYNOPSIS
Migrates LogicMonitor website checks to LM Uptime devices.

.DESCRIPTION
ConvertTo-LMUptimeDevice consumes objects returned by Get-LMWebsite, translates their
configuration into the v3 Uptime payload shape, and provisions new Uptime devices by invoking
New-LMUptimeDevice. The cmdlet preserves alerting behaviour, polling thresholds, locations,
and scripted web steps whenever possible.

.PARAMETER Website
Website object returned by Get-LMWebsite. Accepts pipeline input.

.PARAMETER NamePrefix
Optional string prefixed to the generated Uptime device name.

.PARAMETER NameSuffix
Optional string appended to the generated Uptime device name.

.PARAMETER TargetHostGroupIds
Explicit host group identifiers for the new device.

.PARAMETER DisableSourceAlerting
When specified, disables alerting on the source website after the Uptime device is created successfully.

.EXAMPLE
Get-LMWebsite -Name "logicmonitor.com" | ConvertTo-LMUptimeDevice -NameSuffix "-uptime"

Migrates the logicmonitor.com website check to an Uptime device with a "-uptime" suffix.

.NOTES
You must run Connect-LMAccount prior to execution. The cmdlet honours -WhatIf/-Confirm
through ShouldProcess.

.INPUTS
PSObject. Website objects returned by Get-LMWebsite can be piped to this cmdlet.

.OUTPUTS
LogicMonitor.LMUptimeDevice

.LINK
Get-LMWebsite

.LINK
New-LMUptimeDevice

.LINK
Get-LMUptimeDevice
#>
function ConvertTo-LMUptimeDevice {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSObject]$Website,

        [String]$NamePrefix = '',

        [String]$NameSuffix = '',

        [Parameter(Mandatory)]
        [String[]]$TargetHostGroupIds,

        [Switch]$DisableSourceAlerting
    )

    begin {
        function Convert-LMWebsiteProperties {
            param ([Object]$Properties)

            $converted = @{}

            foreach ($entry in @($Properties)) {
                if (-not $entry) { continue }
                $name = $null
                $value = $null

                if ($entry -is [PSCustomObject]) {
                    $name = $entry.name
                    $value = $entry.value
                }
                elseif ($entry -is [Hashtable]) {
                    $name = $entry['name']
                    $value = $entry['value']
                }

                if ([string]::IsNullOrWhiteSpace($name)) { continue }
                $converted[[string]$name] = $value
            }

            return $converted
        }

        function Convert-PSObjectToHashtable {
            param ([Object]$InputObject)

            if ($null -eq $InputObject) { return $null }

            if ($InputObject -is [Hashtable]) {
                $result = @{}
                foreach ($key in $InputObject.Keys) {
                    $result[$key] = Convert-PSObjectToHashtable $InputObject[$key]
                }
                return $result
            }

            if ($InputObject -is [PSCustomObject]) {
                $hash = @{}
                foreach ($property in $InputObject.PSObject.Properties) {
                    $hash[$property.Name] = Convert-PSObjectToHashtable $property.Value
                }
                return $hash
            }

            if ($InputObject -is [System.Collections.IEnumerable] -and -not ($InputObject -is [String])) {
                $list = @()
                foreach ($item in $InputObject) {
                    $list += Convert-PSObjectToHashtable $item
                }
                return $list
            }

            return $InputObject
        }

        function Get-GlobalSmAlertCondString {
            param ($Value)

            switch ($Value) {
                0 { return 'all' }
                1 { return 'half' }
                2 { return 'moreThanOne' }
                3 { return 'any' }
                'all' { return 'all' }
                'half' { return 'half' }
                'morethanone' { return 'moreThanOne' }
                'any' { return 'any' }
                default { return 'all' }
            }
        }
    }

    process {
        if (-not $Script:LMAuth.Valid) {
            Write-Error 'Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.'
            return
        }
        
        if (-not $Website) { return }

        $type = if ($null -ne $Website.type) { $Website.type } else { '' }
        if ($type -notin @('webcheck', 'pingcheck')) {
            Write-Warning "Skipping resource '$($Website.name)' because type '$type' is not supported."
            return
        }

        $isInternal = [bool]$Website.isInternal
        $targetName = "${NamePrefix}$($Website.name)${NameSuffix}"

        $parameters = @{
            Name         = $targetName
            HostGroupIds = $TargetHostGroupIds
            Description  = $Website.description
        }

        if ($Website.pollingInterval) { 
            $pollingValue = [int]$Website.pollingInterval
            if ($pollingValue -gt 10) {
                Write-Warning "Website '$($Website.name)' has PollingInterval of $pollingValue minutes. Uptime devices only support 1-10 minutes. Setting to 10 minutes."
                $pollingValue = 10
            }
            $parameters.PollingInterval = $pollingValue
        }
        if ($Website.transition) { $parameters.AlertTriggerInterval = [int]$Website.transition }

        $parameters.GlobalSmAlertCond = Get-GlobalSmAlertCondString -Value $Website.globalSmAlertCond

        if ($Website.overallAlertLevel) { $parameters.OverallAlertLevel = $Website.overallAlertLevel }
        if ($Website.individualAlertLevel) { $parameters.IndividualAlertLevel = $Website.individualAlertLevel }
        if ($Website.PSObject.Properties.Match('individualSmAlertEnable')) { $parameters.IndividualSmAlertEnable = [bool]$Website.individualSmAlertEnable }
        $useDefaultLocation = $false
        if ($Website.PSObject.Properties.Match('useDefaultLocationSetting')) {
            $useDefaultLocation = [bool]$Website.useDefaultLocationSetting
            $parameters.UseDefaultLocationSetting = $useDefaultLocation
        }

        $useDefaultAlerting = $false
        if ($Website.PSObject.Properties.Match('useDefaultAlertSetting')) {
            $useDefaultAlerting = [bool]$Website.useDefaultAlertSetting
            $parameters.UseDefaultAlertSetting = $useDefaultAlerting
        }

        $propertyTable = Convert-LMWebsiteProperties -Properties $Website.properties
        if ($propertyTable.Count -gt 0) {
            # Pass the hashtable directly - New-LMUptimeDevice handles conversion
            $parameters.Properties = $propertyTable
        }

        if ($Website.template) { $parameters.Template = $Website.template }

        $testLocation = $Website.testLocation
        $collectorIds = @($testLocation.collectorIds | Where-Object { $_ })
        $smgIds = @($testLocation.smgIds | Where-Object { $_ })
        $allFlag = [bool]$testLocation.all

        # If marked as internal but no collectors specified, treat as external
        if ($isInternal -and ($collectorIds.Count -eq 0)) {
            $isInternal = $false
        }

        if ($isInternal) {
            # Internal checks require collector IDs
            if ($collectorIds.Count -gt 0) {
                $parameters.TestLocationCollectorIds = $collectorIds
            }
        }
        else {
            # External checks - need to specify location and preserve the 'all' flag
            if ($smgIds.Count -gt 0) {
                $parameters.TestLocationSmgIds = $smgIds
                # Pass the all flag to preserve the source configuration
                # If all:false, the API will use only the specified SMG IDs
                # If all:true, the API will use all locations
                if (-not $allFlag) {
                    $parameters.TestLocationAll = $false
                }
            }
            elseif ($allFlag) {
                # Use default SMG IDs (all public locations) when 'all' flag is set
                # These are the standard LogicMonitor public checkpoint locations
                $parameters.TestLocationSmgIds = @(2, 3, 4, 5, 6)
            }
            else {
                # Fallback to all locations if no specific config
                $parameters.TestLocationSmgIds = @(2, 3, 4, 5, 6)
            }
        }

        if ($type -eq 'webcheck') {
            if ([string]::IsNullOrWhiteSpace($Website.domain)) {
                Write-Warning "Website '$($Website.name)' does not contain a domain. Skipping conversion."
                return
            }

            $parameters.Domain = $Website.domain
            if ($Website.schema) { $parameters.Schema = $Website.schema }
            if ($Website.PSObject.Properties.Match('ignoreSSL')) { $parameters.IgnoreSSL = [bool]$Website.ignoreSSL }
            if ($Website.pageLoadAlertTimeInMS) { $parameters.PageLoadAlertTimeInMS = [int]$Website.pageLoadAlertTimeInMS }
            if ($Website.alertExpr) { $parameters.AlertExpr = $Website.alertExpr }
            if ($Website.PSObject.Properties.Match('triggerSSLStatusAlert')) { $parameters.TriggerSSLStatusAlert = [bool]$Website.triggerSSLStatusAlert }
            if ($Website.PSObject.Properties.Match('triggerSSLExpirationAlert')) { $parameters.TriggerSSLExpirationAlert = [bool]$Website.triggerSSLExpirationAlert }

            $stepObjects = @()
            $authWarningShown = $false
            foreach ($step in @($Website.steps)) {
                $convertedStep = Convert-PSObjectToHashtable $step
                if ($convertedStep) { 
                    $stepObjects += $convertedStep
                    # Check if this step has authentication configured
                    if (-not $authWarningShown -and $convertedStep.requireAuth -eq $true) {
                        Write-Warning "Website '$($Website.name)' has authentication configured in step '$($step.name)'. The password cannot be retrieved via API and must be manually updated after migration."
                        $authWarningShown = $true
                    }
                }
            }
            if ($stepObjects.Count -gt 0) { $parameters.Steps = $stepObjects }

        }
        else {
            $hostname = $Website.host
            if ([string]::IsNullOrWhiteSpace($hostname)) {
                Write-Warning "Website '$($Website.name)' does not contain a host value. Skipping conversion."
                return
            }

            $parameters.Hostname = $hostname
            if ($Website.count) { $parameters.Count = [int]$Website.count }
            if ($Website.percentPktsNotReceiveInTime) { $parameters.PercentPktsNotReceiveInTime = [int]$Website.percentPktsNotReceiveInTime }
            if ($Website.timeoutInMSPktsNotReceive) { $parameters.TimeoutInMSPktsNotReceive = [int]$Website.timeoutInMSPktsNotReceive }

        }

        if ($PSCmdlet.ShouldProcess($targetName, 'Create LM Uptime Device')) {
            $commonParams = @{}
            foreach ($commonParam in 'Debug', 'Verbose', 'WhatIf', 'Confirm') {
                if ($PSBoundParameters.ContainsKey($commonParam)) {
                    $commonParams[$commonParam] = $PSBoundParameters[$commonParam]
                }
            }

            try {
                Write-Verbose "Creating Uptime device '$targetName' with parameters: $($parameters | ConvertTo-Json -Compress -Depth 10)"
                $result = New-LMUptimeDevice @parameters @commonParams
                if ($result -and $DisableSourceAlerting.IsPresent) {
                    try {
                        $setWebsiteParams = @{ Id = $Website.id; DisableAlerting = $true }
                        Set-LMWebsite @setWebsiteParams @commonParams | Out-Null
                    }
                    catch {
                        Write-Warning "Uptime device created but failed to disable alerting on website '$($Website.name)': $_"
                    }
                }
                if ($result) { Write-Output $result }
            }
            catch {
                Write-Error "Failed to create Uptime device for website '$($Website.name)': $_"
            }
        }
    }
}

