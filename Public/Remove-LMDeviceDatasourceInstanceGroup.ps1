<#
.SYNOPSIS
Removes a LogicMonitor device datasource instance group.

.DESCRIPTION
The Remove-LMDeviceDatasourceInstanceGroup function removes a LogicMonitor device datasource instance group based on the provided parameters. It requires valid API credentials and a logged-in session.

.PARAMETER DatasourceName
Specifies the name of the datasource associated with the instance group. This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

.PARAMETER DatasourceId
Specifies the ID of the datasource associated with the instance group. This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

.PARAMETER Id
Specifies the ID of the device associated with the instance group. This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets. This parameter can also be specified using the 'DeviceId' alias.

.PARAMETER Name
Specifies the name of the device associated with the instance group. This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets. This parameter can also be specified using the 'DeviceName' alias.

.PARAMETER InstanceGroupName
Specifies the name of the instance group to be removed. This parameter is mandatory.

.EXAMPLE
Remove-LMDeviceDatasourceInstanceGroup -DatasourceName "CPU" -Name "Server01" -InstanceGroupName "Group1"
Removes the instance group named "Group1" associated with the "CPU" datasource on the device named "Server01".

.EXAMPLE
Remove-LMDeviceDatasourceInstanceGroup -DatasourceId 123 -Id 456 -InstanceGroupName "Group2"
Removes the instance group named "Group2" associated with the datasource ID 123 on the device ID 456.

.INPUTS
None.

.OUTPUTS
Returns a PSCustomObject containing the instance ID and a message confirming the successful removal of the instance group.
#>

Function Remove-LMDeviceDatasourceInstanceGroup {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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
        [String]$InstanceGroupName
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

        #Lookup DatasourceId
        If ($DatasourceName -or $DatasourceId) {
            $LookupResult = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId }).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                return
            }
            $HdsId = $LookupResult
        }

        #Lookup InstanceGroupId
        $LookupResult = (Get-LMDeviceDatasourceInstanceGroup -Id $Id -HdsId $HdsId -Filter "name -eq '$InstanceGroupName'").Id
        If (Test-LookupResult -Result $LookupResult -LookupString $InstanceGroupName) {
            return
        }
        $InstanceGroupId = $LookupResult
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/groups/$InstanceGroupId"

        If ($PSItem) {
            $Message = "DeviceDisplayName: $($PSItem.deviceDisplayName) | DatasourceName: $($PSItem.name) | InstanceGroupName: $($PSItem.InstanceGroupName)"
        }
        Elseif ($DatasourceName -and $DeviceName) {
            $Message = "DeviceName: $DeviceName | DatasourceName: $DatasourceName | InstanceGroupName: $InstanceGroupName"
        }
        Else {
            $Message = "DeviceId: $DeviceId | DatasourceId: $DatasourceId | InstanceGroupName: $InstanceGroupName"
        }

        Try {
            If ($PSCmdlet.ShouldProcess($Message, "Remove Device Datasource Instance Group")) {                    
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1]
                
                $Result = [PSCustomObject]@{
                    InstanceId = $InstanceId
                    Message    = "Successfully removed ($Message)"
                }
                
                Return $Result
            }
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
