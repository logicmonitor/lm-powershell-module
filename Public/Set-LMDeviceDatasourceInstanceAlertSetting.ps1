<#
.SYNOPSIS
Updates alert settings for a LogicMonitor device datasource instance.

.DESCRIPTION
The Set-LMDeviceDatasourceInstanceAlertSetting function modifies alert settings for a specific device datasource instance in LogicMonitor.

.PARAMETER DatasourceName
Specifies the name of the datasource. Required when using the 'Id-dsName' or 'Name-dsName' parameter sets.

.PARAMETER DatasourceId
Specifies the ID of the datasource. Required when using the 'Id-dsId' or 'Name-dsId' parameter sets.

.PARAMETER Id
Specifies the ID of the device. Can be specified using the 'DeviceId' alias.

.PARAMETER Name
Specifies the name of the device. Can be specified using the 'DeviceName' alias.

.PARAMETER DatapointName
Specifies the name of the datapoint for which to configure alerts.

.PARAMETER InstanceName
Specifies the name of the instance for which to configure alerts.

.PARAMETER DisableAlerting
Specifies whether to disable alerting for this instance.

.PARAMETER AlertExpressionNote
Specifies a note for the alert expression.

.PARAMETER AlertExpression
Specifies the alert expression in the format "(01:00 02:00) > -100 timezone=America/New_York".

.PARAMETER AlertClearTransitionInterval
Specifies the interval for alert clear transitions. Must be between 0 and 60.

.PARAMETER AlertTransitionInterval
Specifies the interval for alert transitions. Must be between 0 and 60.

.PARAMETER AlertForNoData
Specifies the alert level for no data conditions. Must be between 1 and 4.

.EXAMPLE
Set-LMDeviceDatasourceInstanceAlertSetting -Id 123 -DatasourceName "CPU" -DatapointName "Usage" -InstanceName "Total" -AlertExpression "> 90"
Updates the alert settings for the CPU Usage datapoint on the specified device.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.AlertSetting object containing the updated alert settings.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMDeviceDatasourceInstanceAlertSetting {

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
        [Alias("DeviceId")]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Alias("DeviceName")]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$DatapointName,

        [Parameter(Mandatory)]
        [String]$InstanceName,

        [Nullable[bool]]$DisableAlerting,

        [String]$AlertExpressionNote,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [String]$AlertExpression, #format for alert expression (01:00 02:00) > -100 timezone=America/New_York

        [Parameter(Mandatory)]
        [ValidateRange(0, 60)]
        [Int]$AlertClearTransitionInterval,

        [Parameter(Mandatory)]
        [ValidateRange(0, 60)]
        [Int]$AlertTransitionInterval,

        [Parameter(Mandatory)]
        [ValidateRange(1, 4)]
        [Int]$AlertForNoData
    )

    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup Device Id
            if ($Name) {
                $LookupResult = (Get-LMDevice -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Lookup DatasourceId
            if ($DatasourceName -or $DatasourceId) {
                $LookupResult = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId }).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                    return
                }
                $HdsId = $LookupResult
            }

            #Replace brakets in instance name
            $InstanceName = $InstanceName -replace "[\[\]]", "?"
            #Lookup HdsiId
            if ($DatasourceName) {
                $LookupResult = (Get-LMDeviceDatasourceInstance -DatasourceName $DatasourceName -DeviceId $Id | Where-Object { $_.name -like "*$InstanceName" }).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                    return
                }
                $HdsiId = $LookupResult
            }
            else {
                $LookupResult = (Get-LMDeviceDatasourceInstance -DatasourceId $DatasourceId -DeviceId $Id | Where-Object { $_.name -like "*$InstanceName" }).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DatasourceId) {
                    return
                }
                $HdsiId = $LookupResult
            }
            #Lookup DatapointId
            if ($DatasourceName) {
                $LookupResult = (Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceName $DatasourceName -Id $Id -InstanceName $InstanceName | Where-Object { $_.dataPointName -eq $DatapointName }).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DatapointName) {
                    return
                }
                $DatapointId = $LookupResult
            }
            else {
                $LookupResult = (Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceId $DatasourceId -Id $Id -InstanceName $InstanceName | Where-Object { $_.dataPointName -eq $DatapointName }).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DatasourceId) {
                    return
                }
                $DatapointId = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$HdsiId/alertsettings/$DatapointId"

            $Message = "Id: $Id | hostDatasourceId: $HdsId | instanceId: $HdsiId | datapointId: $DatapointId"

            try {
                $Data = @{
                    disableAlerting              = $DisableAlerting
                    alertExprNote                = $AlertExpressionNote
                    alertExpr                    = $AlertExpression
                    alertClearTransitionInterval = $AlertClearTransitionInterval
                    alertClearInterval           = $AlertClearTransitionInterval
                    alertTransitionInterval      = $AlertTransitionInterval
                    alertForNoData               = $AlertForNoData
                }

                #Remove empty keys so we dont overwrite them
                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                    -AlwaysKeepKeys @('alertExpr')

                if ($PSCmdlet.ShouldProcess($Message, "Set Device Datasource Instance Alert Setting")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-LMRestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.AlertSetting" )
                }
            }
            catch {
                return
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
