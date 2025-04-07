<#
.SYNOPSIS
Retrieves alert recipients for a specific data point in a LogicMonitor device datasource instance.

.DESCRIPTION
The Get-LMDeviceDatasourceInstanceAlertRecipients function retrieves the alert recipients configured for a specific data point within a device's datasource instance. It supports identifying the device and datasource by either ID or name.

.PARAMETER DatasourceName
The name of the datasource. Required for Id-dsName and Name-dsName parameter sets.

.PARAMETER DatasourceId
The ID of the datasource. Required for Id-dsId and Name-dsId parameter sets.

.PARAMETER Id
The ID of the device. Can be specified using the DeviceId alias. Required for Id-dsId and Id-dsName parameter sets.

.PARAMETER Name
The name of the device. Can be specified using the DeviceName alias. Required for Name-dsName and Name-dsId parameter sets.

.PARAMETER InstanceName
The name of the datasource instance. This parameter is mandatory.

.PARAMETER DataPointName
The name of the data point to retrieve alert recipients for. This parameter is mandatory.

.EXAMPLE
#Retrieve alert recipients using names
Get-LMDeviceDatasourceInstanceAlertRecipients -DatasourceName "Ping" -Name "Server01" -InstanceName "Instance01" -DataPointName "PingLossPercent"

.EXAMPLE
#Retrieve alert recipients using IDs
Get-LMDeviceDatasourceInstanceAlertRecipients -DatasourceId 123 -Id 456 -InstanceName "Instance01" -DataPointName "PingLossPercent"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns alert recipient configuration objects.
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

        #Replace brakets in instance name
        $InstanceName = $InstanceName -replace "[\[\]]", "?"
        
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
