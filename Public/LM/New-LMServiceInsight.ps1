<#
.SYNOPSIS
Creates a new LogicMonitor Service Insight and its companion aggregate
"Health" DataSource.

.DESCRIPTION
A Service Insight is a LogicMonitor device with DeviceType 6, whose
membership (which devices/instances feed it) is defined by a
"predef.bizservice.members" custom property containing a JSON filter
object, plus a "predef.bizservice.evalMembersInterval" property
controlling how often membership is re-evaluated.

New-LMServiceInsight creates that device (via New-LMDevice), then
creates a companion "<DisplayName> Health" DataSource (via
New-LMDatasource) scoped to it (appliesTo: system.deviceId == "<id>"),
with aggregate datapoints rolling up data from the member devices'
datapoints — the same two-step pattern used by LogicMonitor's own
Service Insight UI (confirmed via a captured HAR of the UI's requests).

.PARAMETER Name
Internal name of the Service Insight device. Required.

.PARAMETER DisplayName
Display name of the Service Insight device. Required.

.PARAMETER Description
Description for the Service Insight device.

.PARAMETER PreferredCollectorId
Collector to assign the Service Insight device to. Defaults to -4 (the
portal's auto-balanced/default collector group sentinel used by the LM UI
itself for Service Insights).

.PARAMETER HostGroupIds
Device group IDs to place the Service Insight device in.

.PARAMETER EvalMembersInterval
Minutes between membership re-evaluation. LM's UI offers 5, 30, or 1440.
Defaults to 30.

.PARAMETER DeviceMemberFilter
Zero or more hashtables describing device-level membership filter
criteria. Each should look like:
    @{
        deviceGroupFullPath = "*"
        deviceDisplayName   = "*"
        deviceProperties    = @(@{ name = "customer"; value = "HomeDevices" })
    }
Matches devices directly (independent of any specific datasource
instance). Use -InstanceMemberFilter instead/as well to match by
datasource instance.

.PARAMETER InstanceMemberFilter
Zero or more hashtables describing instance-level membership filter
criteria. Each should look like:
    @{
        deviceGroupFullPath = "*"
        deviceDisplayName   = "*"
        deviceProperties    = @(@{ name = "customer"; value = "HomeDevices" })
        dataSourceFullName  = "Host Status (HostStatus)"
        dataSourceId        = 463
        instanceName        = "*"
    }
Matches datasource instances across devices meeting the given criteria.
At least one of -DeviceMemberFilter or -InstanceMemberFilter must be
given, or the Service Insight will have no members.

.PARAMETER Properties
Additional custom properties to set on the Service Insight device
(besides the predef.bizservice.* ones this cmdlet manages).

.PARAMETER DataSourceDisplayName
Display name for the companion aggregate DataSource. Defaults to
"<DisplayName> Health".

.PARAMETER DataSourceDescription
Description for the companion aggregate DataSource.

.PARAMETER DataSourceCollectInterval
Collect interval (seconds) for the aggregate DataSource. Defaults to 300.

.PARAMETER DataPoints
One or more hashtables defining the aggregate DataSource's datapoints.
Each should follow the LM datapoint schema with an aggregation
postProcessor, e.g.:
    @{
        name                = "CoreBusyPercent_maximum"
        type                = 2
        dataType            = 7
        postProcessorMethod = "aggregation"
        postProcessorParam  = (@{
            version    = "1.0"
            expression = @{
                funcName       = "maximum"
                dataSourceName = "WinCPUCore-"
                dataPointName  = "CoreBusyPercent"
            }
            dataLack = "ignore"
        } | ConvertTo-Json -Compress)
    }
Required — a Service Insight's Health datasource with no datapoints has
nothing to show.

.EXAMPLE
$deviceFilter = @{
    deviceGroupFullPath = "*"
    deviceDisplayName   = "*"
    deviceProperties    = @(@{ name = "customer"; value = "HomeDevices" })
}
$dataPoints = @(
    @{
        name                = "CoreBusyPercent_maximum"
        type                = 2
        dataType            = 7
        postProcessorMethod = "aggregation"
        postProcessorParam  = (@{
            version    = "1.0"
            expression = @{ funcName = "maximum"; dataSourceName = "WinCPUCore-"; dataPointName = "CoreBusyPercent" }
            dataLack   = "ignore"
        } | ConvertTo-Json -Compress)
    }
)
New-LMServiceInsight -Name "webapp_prod" -DisplayName "WebApp Prod" -DeviceMemberFilter $deviceFilter -DataPoints $dataPoints

.NOTES
You must run Connect-LMAccount before running this command.
Request shape confirmed via a HAR capture of LogicMonitor's own Service
Insight creation UI against /device/devices and /setting/datasources.

.OUTPUTS
Returns a PSCustomObject with .Device (LogicMonitor.Device) and
.Datasource (LogicMonitor.Datasource) properties.
#>
function New-LMServiceInsight {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory)]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$DisplayName,

        [String]$Description = '',

        [Int]$PreferredCollectorId = -4,

        [String[]]$HostGroupIds,

        [ValidateSet(5, 30, 1440)]
        [Int]$EvalMembersInterval = 30,

        [Hashtable[]]$DeviceMemberFilter = @(),

        [Hashtable[]]$InstanceMemberFilter = @(),

        [Hashtable]$Properties = @{},

        [String]$DataSourceDisplayName,

        [String]$DataSourceDescription = '',

        [Int]$DataSourceCollectInterval = 300,

        [Parameter(Mandatory)]
        [Hashtable[]]$DataPoints
    )

    begin {}
    process {
        if (-not $Script:LMAuth.Valid) {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
            return
        }

        if ($DeviceMemberFilter.Count -eq 0 -and $InstanceMemberFilter.Count -eq 0) {
            Write-Error "At least one of -DeviceMemberFilter or -InstanceMemberFilter must be provided, or the Service Insight will have no members."
            return
        }

        Write-Information "[INFO]: Creating Service Insight '$Name' (DisplayName: '$DisplayName') with $($DeviceMemberFilter.Count) device filter(s), $($InstanceMemberFilter.Count) instance filter(s), $($DataPoints.Count) datapoint(s), EvalMembersInterval=$EvalMembersInterval."

        # Normalize member filter hashtables into the shape LM expects
        # (deviceProperties as an array of {name, value} objects).
        $normalizeFilter = {
            param($Filter)
            $normalized = [ordered]@{
                deviceGroupFullPath = $Filter.deviceGroupFullPath
                deviceDisplayName   = $Filter.deviceDisplayName
                deviceProperties    = @($Filter.deviceProperties | ForEach-Object {
                        [ordered]@{ name = $_.name; value = $_.value }
                    })
            }
            if ($Filter.ContainsKey('dataSourceFullName')) {
                $normalized['dataSourceFullName'] = $Filter.dataSourceFullName
                $normalized['dataSourceId'] = $Filter.dataSourceId
                $normalized['instanceName'] = $Filter.instanceName
                $normalized['instanceProperties'] = @($Filter.instanceProperties)
            }
            return $normalized
        }

        $membersPayload = @{
            device   = @($DeviceMemberFilter | ForEach-Object { & $normalizeFilter $_ })
            instance = @($InstanceMemberFilter | ForEach-Object { & $normalizeFilter $_ })
        }
        $membersJson = $membersPayload | ConvertTo-Json -Depth 10 -Compress

        $siProperties = @{}
        foreach ($key in $Properties.Keys) { $siProperties[$key] = $Properties[$key] }
        $siProperties['predef.bizservice.evalMembersInterval'] = $EvalMembersInterval
        $siProperties['predef.bizservice.members'] = $membersJson

        $Message = "Name: $Name | DisplayName: $DisplayName"

        if (-not $PSCmdlet.ShouldProcess($Message, "Create Service Insight")) {
            return
        }

        $device = New-LMDevice `
            -Name $Name `
            -DisplayName $DisplayName `
            -Description $Description `
            -PreferredCollectorId $PreferredCollectorId `
            -DeviceType 6 `
            -Properties $siProperties `
            -HostGroupIds $HostGroupIds

        if (-not $device -or -not $device.id) {
            Write-Error "Failed to create Service Insight device; aborting before creating the companion DataSource."
            return
        }

        Write-Information "[INFO]: Service Insight device created: id=$($device.id), name='$Name', preferredCollectorId=$($device.preferredCollectorId)."

        if (-not $DataSourceDisplayName) {
            $DataSourceDisplayName = "$DisplayName Health"
        }
        # LM's API rejects a DataSource name/displayName containing a
        # hyphen anywhere but the last character - strip any that came
        # from the Service Insight's own name/display name. Confirmed via
        # a real CI failure: a test using a hyphenated -Name (e.g.
        # "si-build-test-<suffix>") passed that hyphen straight into the
        # DataSource's "name" field (unlike displayName, which was
        # already being stripped), and the API rejected it with
        # 'name "-" is only supported for DataSource name when it is the
        # last char'.
        $DataSourceName = ($Name -replace '-', '') + '_health'
        $DataSourceDisplayName = $DataSourceDisplayName -replace '-', ''

        $dataSourceConfig = [PSCustomObject]@{
            name              = $DataSourceName
            displayName       = $DataSourceDisplayName
            description       = $DataSourceDescription
            group             = ''
            appliesTo         = "system.deviceId == `"$($device.id)`""
            technology        = ''
            collectInterval   = $DataSourceCollectInterval
            collectMethod     = 'aggregate'
            collectorAttribute = [PSCustomObject]@{ name = 'aggregate' }
            enableAutoDiscovery = $false
            hasMultiInstances = $false
            dataPoints        = @($DataPoints | ForEach-Object { [PSCustomObject]$_ })
        }

        $datasource = New-LMDatasource -Datasource $dataSourceConfig

        if (-not $datasource -or -not $datasource.id) {
            Write-Warning "Service Insight device '$Name' (id=$($device.id)) was created, but the companion DataSource '$($dataSourceConfig.name)' failed to create - the Service Insight will have no Health metrics until this is retried."
        }
        else {
            Write-Information "[INFO]: Companion DataSource created: id=$($datasource.id), name='$($dataSourceConfig.name)', dataPoints=$($dataSourceConfig.dataPoints.Count)."
        }

        return [PSCustomObject]@{
            Device     = $device
            Datasource = $datasource
        }
    }
    end {}
}
