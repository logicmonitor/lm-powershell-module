<#
.SYNOPSIS
Adds a custom property to a LogicMonitor device datasource instance.

.DESCRIPTION
The New-LMInstanceProperty function adds a custom property to a
specific instance of a datasource on a device (e.g. one CPU core on a
CPU datasource, one disk on a Disks datasource) - not the device
itself. Instance-level properties are how Service Insight/Service
Template membership can be scoped to individual instances rather than
whole devices (see the InstanceMemberFilter parameter on
New-/Set-LMServiceInsight, and the instance-level propertySelector on
New-LMDynamicServiceInsight), so tagging instances directly is often what
membership scoping actually needs, not just device-level tags.

Resolves the device and datasource by id or name (matching
Get-LMDeviceDatasourceInstance's own parameter conventions), then finds
the instance by name, then composes Set-LMDeviceDatasourceInstance
-PropertiesMethod Add to add the property without disturbing any
existing instance properties.

.PARAMETER Id
The device id. Part of a parameter set alongside -Name.

.PARAMETER Name
The device name. Part of a parameter set alongside -Id.

.PARAMETER DatasourceId
The datasource id (e.g. from Get-LMDeviceDataSourceList). Part of a
parameter set alongside -DatasourceName.

.PARAMETER DatasourceName
The datasource name (e.g. "CPU", "Disks"). Part of a parameter set
alongside -DatasourceId.

.PARAMETER InstanceName
The exact instance name to tag (e.g. "CPU 0", the wildvalue LogicMonitor
discovered for that instance). Required.

.PARAMETER PropertyName
The property name to add.

.PARAMETER PropertyValue
The property value to set.

.EXAMPLE
#Tag a specific CPU core instance with an application property, by device/datasource name
New-LMInstanceProperty -Name "Production-Server" -DatasourceName "CPU" -InstanceName "CPU 0" -PropertyName "application" -PropertyValue "webapp"

.EXAMPLE
#Same, by device/datasource id
New-LMInstanceProperty -Id 4767 -DatasourceId 314 -InstanceName "CPU 0" -PropertyName "application" -PropertyValue "webapp"

.NOTES
You must run Connect-LMAccount before running this command.
Composes Get-LMDeviceDatasourceInstance and
Set-LMDeviceDatasourceInstance -PropertiesMethod Add rather than
calling the API directly, so device/datasource/instance name lookups
and error handling stay consistent with those cmdlets.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a LogicMonitor.DeviceDatasourceInstance object for the updated
instance.
#>
function New-LMInstanceProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id-dsName', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Alias('DeviceId')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Alias('DeviceName')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Int]$DatasourceId,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,

        [Parameter(Mandatory)]
        [String]$InstanceName,

        [Parameter(Mandatory)]
        [String]$PropertyName,

        [Parameter(Mandatory)]
        [String]$PropertyValue
    )

    begin {}
    process {
        if (-not $Script:LMAuth.Valid) {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
            return
        }

        $getParams = @{}
        if ($Id) { $getParams['Id'] = $Id } else { $getParams['Name'] = $Name }
        if ($DatasourceId) { $getParams['DatasourceId'] = $DatasourceId } else { $getParams['DatasourceName'] = $DatasourceName }

        $instances = Get-LMDeviceDatasourceInstance @getParams
        $instance = $instances | Where-Object { $_.name -eq $InstanceName -or $_.wildValue -eq $InstanceName } | Select-Object -First 1

        if (-not $instance) {
            $deviceRef = if ($Id) { "Id: $Id" } else { "Name: $Name" }
            $dsRef = if ($DatasourceId) { "DatasourceId: $DatasourceId" } else { "DatasourceName: $DatasourceName" }
            Write-Error "No instance named '$InstanceName' found ($deviceRef, $dsRef)."
            return
        }

        $Message = "InstanceId: $($instance.id) | InstanceName: $InstanceName | Property: $PropertyName = $PropertyValue"

        if ($PSCmdlet.ShouldProcess($Message, "Add Instance Property")) {
            return Set-LMDeviceDatasourceInstance `
                -InstanceId $instance.id `
                -Id $instance.deviceId `
                -DatasourceId $instance.dataSourceId `
                -Properties @{ $PropertyName = $PropertyValue } `
                -PropertiesMethod Add `
                -Confirm:$false
        }
    }
    end {}
}
