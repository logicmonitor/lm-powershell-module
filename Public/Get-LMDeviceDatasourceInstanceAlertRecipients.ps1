<#
.SYNOPSIS
Retrieves the alert recipients for a specific data point in a LogicMonitor device datasource instance.

.DESCRIPTION
The Get-LMDeviceDatasourceInstanceAlertRecipients function retrieves the alert recipients for a specific data point in a LogicMonitor device datasource instance. It requires valid API credentials and a logged-in session.

.PARAMETER DatasourceName
Specifies the name of the datasource. This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

.PARAMETER DatasourceId
Specifies the ID of the datasource. This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

.PARAMETER Id
Specifies the ID of the device. This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets. It can also be specified using the 'DeviceId' alias.

.PARAMETER Name
Specifies the name of the device. This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets. It can also be specified using the 'DeviceName' alias.

.PARAMETER InstanceName
Specifies the name of the datasource instance. This parameter is mandatory.

.PARAMETER DataPointName
Specifies the name of the data point. This parameter is mandatory.

.EXAMPLE
Get-LMDeviceDatasourceInstanceAlertRecipients -DatasourceName "Ping-" -Name "Server01" -InstanceName "Instance01" -DataPointName "PingLossPercent"

Retrieves the alert recipients for the "PingLossPercent" data point in the "CPU" datasource instance of the "Server01" device.

.EXAMPLE
Get-LMDeviceDatasourceInstanceAlertRecipients -DatasourceId 123 -Id 456 -InstanceName "Instance01" -DataPointName "PingLossPercent"

Retrieves the alert recipients for the "PingLossPercent" data point in the datasource instance with ID 123 of the device with ID 456.

#>
Function Get-LMDeviceDatasourceInstanceAlertRecipients {
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
        [Alias('DeviceId')]
        [Int]$Id,
    
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Alias('DeviceName')]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$InstanceName,

        [Parameter(Mandatory)]
        [String]$DataPointName
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Lookup Device Id
        If ($Name) {
            $LookupResult = (Get-LMDevice -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        #Lookup Hdsid
        If ($DatasourceName -or $DatasourceId) {
            $LookupResult = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId }).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                return
            }
            $HdsId = $LookupResult
        }
        #Lookup HdsiId
        If ($DatasourceName) {
            $LookupResult = (Get-LMDeviceDatasourceInstance -DatasourceName $DatasourceName -DeviceId $Id | Where-Object { $_.name -like "*$InstanceName"}).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $InstanceName) {
                return
            }
            $HdsiId = $LookupResult
        }
        Else{
            $LookupResult = (Get-LMDeviceDatasourceInstance -DatasourceId $DatasourceId -DeviceId $Id | Where-Object { $_.name -like "*$InstanceName"}).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $InstanceName) {
                return
            }
            $HdsiId = $LookupResult
        }

        #Get datapoint id
        $LookupResult = (Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceId $DatasourceId -Id $Id -InstanceName $InstanceName | Where-Object { $_.dataPointName -like "*$DataPointName"}).Id
        If (Test-LookupResult -Result $LookupResult -LookupString $DataPointName) {
            return
        }
        $DsidpId = $LookupResult
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$HdsiId/alertsettings/$DsidpId/recipients"

        #Initalize vars
        $Results = @()

        Try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
            
            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

        }
        Catch [Exception] {
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
        Return $Response
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
