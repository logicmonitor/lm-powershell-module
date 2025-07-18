<#
.SYNOPSIS
Creates a new instance group for a LogicMonitor device datasource.

.DESCRIPTION
The New-LMDeviceDatasourceInstanceGroup function creates a new instance group for a LogicMonitor device datasource. It requires the user to be logged in and have valid API credentials.

.PARAMETER InstanceGroupName
The name of the instance group to create. This parameter is mandatory.

.PARAMETER Description
The description of the instance group.

.PARAMETER DatasourceName
The name of the datasource associated with the instance group. This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

.PARAMETER DatasourceId
The ID of the datasource associated with the instance group. This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

.PARAMETER Id
The ID of the device associated with the instance group. This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets.

.PARAMETER Name
The name of the device associated with the instance group. This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets.

.EXAMPLE
New-LMDeviceDatasourceInstanceGroup -InstanceGroupName "Group1" -Description "Instance group for Device1" -DatasourceName "DataSource1" -Name "Device1"
Creates a new instance group named "Group1" with the description "Instance group for Device1" for the device named "Device1" and the datasource named "DataSource1".

.EXAMPLE
New-LMDeviceDatasourceInstanceGroup -InstanceGroupName "Group2" -Description "Instance group for Device2" -DatasourceId 123 -Id 456
Creates a new instance group named "Group2" with the description "Instance group for Device2" for the device with ID 456 and the datasource with ID 123.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DeviceDatasourceInstanceGroup object.
#>
function New-LMDeviceDatasourceInstanceGroup {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [String]$InstanceGroupName,

        [String]$Description,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Int]$DatasourceId,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Alias('DeviceId')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Alias('DeviceName')]
        [String]$Name

    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Lookup Device Id
        if ($Name) {
            if ($Name -match "\*") {
                Write-Error "Wildcard values not supported for device names."
                return
            }
            $Id = (Get-LMDeviceDataSourceList -Name $Name | Select-Object -First 1 ).Id
            if (!$Id) {
                Write-Error "Unable to find assocaited host device: $Name, please check spelling and try again."
                return
            }
        }

        #Lookup DatasourceId
        if ($DatasourceName -or $DatasourceId) {
            if ($DatasourceName -match "\*") {
                Write-Error "Wildcard values not supported for datasource names."
                return
            }
            $HdsId = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId } | Select-Object -First 1).Id
            if (!$HdsId) {
                Write-Error "Unable to find assocaited host datasource: $DatasourceId$DatasourceName, please check spelling and try again. Datasource must have an applicable appliesTo associating the datasource to the device"
                return
            }
        }

        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/groups"

        $Data = @{
            name        = $InstanceGroupName
            description = $Description
        }

        #Remove empty keys so we dont overwrite them
        $Data = Format-LMData `
            -Data $Data `
            -UserSpecifiedKeys @()

        $Message = "InstanceGroupName: $InstanceGroupName | DeviceId: $Id"

        if ($PSCmdlet.ShouldProcess($Message, "Create Device Datasource Instance Group")) {
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            return $Response

        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
