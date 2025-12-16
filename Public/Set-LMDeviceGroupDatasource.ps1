<#
.SYNOPSIS
Updates a LogicMonitor device group datasource configuration.

.DESCRIPTION
The Set-LMDeviceGroupDatasource cmdlet modifies an existing device group datasource in LogicMonitor, allowing updates to monitoring state. This cmdlet provides control over the "Enable" checkbox (stopMonitoring) for a datasource applied to a device group. For alert settings use Set-LMDeviceGroupDatasourceAlertSetting.

.PARAMETER DatasourceName
Specifies the name of the datasource. Required when using the 'Id-dsName' or 'Name-dsName' parameter sets.

.PARAMETER DatasourceId
Specifies the ID of the datasource. Required when using the 'Id-dsId' or 'Name-dsId' parameter sets.

.PARAMETER Id
Specifies the ID of the device group. Required when using the 'Id-dsId' or 'Id-dsName' parameter sets.

.PARAMETER Name
Specifies the name of the device group. Required when using the 'Name-dsId' or 'Name-dsName' parameter sets.

.PARAMETER StopMonitoring
Specifies whether to stop monitoring the datasource. When set to $true, monitoring is disabled (unchecks the "Enable" checkbox). When set to $false, monitoring is enabled (checks the "Enable" checkbox).

.EXAMPLE
#Disable monitoring for a datasource on a device group
Set-LMDeviceGroupDatasource -Id 15 -DatasourceId 790 -StopMonitoring $true

.EXAMPLE
#Enable monitoring using names
Set-LMDeviceGroupDatasource -Name "Production Servers" -DatasourceName "CPU" -StopMonitoring $false 

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a LogicMonitor.DeviceGroupDatasource object containing the updated datasource configuration.

.NOTES
You must run Connect-LMAccount before running this command.
#>

function Set-LMDeviceGroupDatasource {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Int]$DatasourceId,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [String]$Name,

        [Nullable[boolean]]$StopMonitoring

    )

    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup DeviceGroupId
            if ($Name) {
                $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Lookup DatasourceId
            if ($DatasourceName) {
                $LookupResult = (Get-LMDatasource -Name $DatasourceName).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                    return
                }
                $DatasourceId = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/device/groups/$Id/datasources/$DatasourceId"

            if ($Name) {
                $Message = "Id: $Id | Name: $Name | DatasourceId: $DatasourceId"
            }
            else {
                $Message = "Id: $Id | DatasourceId: $DatasourceId"
            }

            
            $Data = @{
                stopMonitoring  = $StopMonitoring
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys

            if ($PSCmdlet.ShouldProcess($Message, "Set Device Group Datasource")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroupDatasource" )
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}

