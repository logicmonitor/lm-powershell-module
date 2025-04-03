<#
.SYNOPSIS
Updates alert settings for a LogicMonitor device group datasource.

.DESCRIPTION
The Set-LMDeviceGroupDatasourceAlertSetting function modifies alert settings for a specific device group datasource in LogicMonitor.

.PARAMETER DatasourceName
Specifies the name of the datasource. Required when using the 'Id-dsName' or 'Name-dsName' parameter sets.

.PARAMETER DatasourceId
Specifies the ID of the datasource. Required when using the 'Id-dsId' or 'Name-dsId' parameter sets.

.PARAMETER Id
Specifies the ID of the device group.

.PARAMETER Name
Specifies the name of the device group.

.PARAMETER DatapointName
Specifies the name of the datapoint for which to configure alerts.

.PARAMETER DisableAlerting
Specifies whether to disable alerting for this datasource.

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
Set-LMDeviceGroupDatasourceAlertSetting -Id 123 -DatasourceName "CPU" -DatapointName "Usage" -AlertExpression "> 90"
Updates the alert settings for the CPU Usage datapoint on the specified device group.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.DeviceGroupDatasourceAlertSetting object containing the updated alert settings.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

Function Set-LMDeviceGroupDatasourceAlertSetting {

    [CmdletBinding()]
    Param (
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

        [Parameter(Mandatory)]
        [String]$DatapointName,

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

    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup DeviceGroupId
            If ($Name) {
                $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
    
            #Lookup DatasourceId
            If ($DatasourceName) {
                $LookupResult = (Get-LMDatasource -Name $DatasourceName).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                    return
                }
                $DatasourceId = $LookupResult
            }

            #Lookup DatapointId
            If ($DatapointName) {
                $LookupResult = (Get-LMDeviceGroupDatasourceAlertSetting -Id $Id -DatasourceId $DatasourceId | Where-Object { $_.dataPointName -eq $DatapointName }).dataPointId
                If (Test-LookupResult -Result $LookupResult -LookupString $DatapointName) {
                    return
                }
                $DatapointId = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/device/groups/$Id/datasources/$DatasourceId/alertsettings"

            Try {
                $dpConfig = @{
                    disableAlerting              = $DisableAlerting
                    dataPointId                  = $DatapointId
                    dataPointName                = $DatapointName
                    alertExprNote                = $AlertExpressionNote
                    alertExpr                    = $AlertExpression
                    alertClearTransitionInterval = $AlertClearTransitionInterval
                    alertTransitionInterval      = $AlertTransitionInterval
                    alertForNoData               = $AlertForNoData

                }

                #Remove empty keys so we dont overwrite them
                @($dpConfig.keys) | ForEach-Object { If ([string]::IsNullOrEmpty($dpConfig[$_]) -and $_ -ne "alertExpr" -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $dpConfig.Remove($_) } }

                $Data = @{
                    dpConfig = @($dpConfig)
                }

                $Data = ($Data | ConvertTo-Json)
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = (Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data).dpConfig

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroupDatasourceAlertSetting" )
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
