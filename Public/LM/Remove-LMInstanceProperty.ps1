<#
.SYNOPSIS
Removes a custom property from a LogicMonitor device datasource instance.

.DESCRIPTION
The Remove-LMInstanceProperty function removes a single custom property
from a specific instance of a datasource on a device (e.g. one CPU core
on a CPU datasource, one disk on a Disks datasource) - not the device
itself. Complements New-LMInstanceProperty.

There is no per-key delete endpoint for instance properties - the
underlying API only supports replacing the whole customProperties set
(PropertiesMethod "Refresh"). This function reads the instance's current
properties, drops the one matching -PropertyName, and sends the
remaining set back via Set-LMDeviceDatasourceInstance -PropertiesMethod
Refresh, so every other existing instance property is preserved
untouched.

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
The exact instance name to untag (e.g. "CPU 0", the wildvalue LogicMonitor
discovered for that instance). Required.

.PARAMETER PropertyName
The property name to remove.

.EXAMPLE
#Remove an application property from a specific CPU core instance, by device/datasource name
Remove-LMInstanceProperty -Name "Production-Server" -DatasourceName "CPU" -InstanceName "CPU 0" -PropertyName "application"

.EXAMPLE
#Same, by device/datasource id
Remove-LMInstanceProperty -Id 4767 -DatasourceId 314 -InstanceName "CPU 0" -PropertyName "application"

.NOTES
You must run Connect-LMAccount before running this command.
Composes Get-LMDeviceDatasourceInstance and
Set-LMDeviceDatasourceInstance -PropertiesMethod Refresh rather than
calling the API directly, so device/datasource/instance name lookups
and error handling stay consistent with those cmdlets. Because the API
has no partial-delete for instance properties, this is a read-then-
refresh-the-rest operation, not a true single-field delete - a race
against a concurrent property write to the same instance is possible in
principle, same limitation Set-LMDeviceDatasourceInstance itself has.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a LogicMonitor.DeviceDatasourceInstance object for the updated
instance.
#>
function Remove-LMInstanceProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id-dsName', SupportsShouldProcess, ConfirmImpact = 'Medium')]
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
        [String]$PropertyName
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

        if (-not ($instance.customProperties | Where-Object { $_.name -eq $PropertyName })) {
            Write-Error "Property '$PropertyName' does not exist on instance '$InstanceName' (InstanceId: $($instance.id))."
            return
        }

        $remainingProperties = @{}
        foreach ($prop in $instance.customProperties) {
            if ($prop.name -ne $PropertyName) {
                $remainingProperties[$prop.name] = $prop.value
            }
        }

        $Message = "InstanceId: $($instance.id) | InstanceName: $InstanceName | Remove Property: $PropertyName"

        if ($PSCmdlet.ShouldProcess($Message, "Remove Instance Property")) {
            return Set-LMDeviceDatasourceInstance `
                -InstanceId $instance.id `
                -Id $instance.deviceId `
                -DatasourceId $instance.dataSourceId `
                -Properties $remainingProperties `
                -PropertiesMethod Refresh `
                -Confirm:$false
        }
    }
    end {}
}
