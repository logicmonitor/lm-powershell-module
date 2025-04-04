<#
.SYNOPSIS
Removes a device datasource instance from Logic Monitor.

.DESCRIPTION
The Remove-LMDeviceDatasourceInstance function removes a device datasource instance from Logic Monitor. It requires valid API credentials and the user must be logged in before running this command.

.PARAMETER DatasourceName
Specifies the name of the datasource. This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

.PARAMETER DatasourceId
Specifies the ID of the datasource. This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

.PARAMETER Id
Specifies the ID of the device. This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets.

.PARAMETER Name
Specifies the name of the device. This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets.

.PARAMETER WildValue
Specifies the wildcard value associated with the datasource instance.

.EXAMPLE
Remove-LMDeviceDatasourceInstance -Name "MyDevice" -DatasourceName "MyDatasource" -WildValue "12345"
Removes the device datasource instance with the specified device name, datasource name, and wildcard value.

.EXAMPLE
Remove-LMDeviceDatasourceInstance -Id 123 -DatasourceId 456 -WildValue "67890"
Removes the device datasource instance with the specified device ID, datasource ID, and wildcard value.

.INPUTS
None.

.OUTPUTS
Returns a PSCustomObject containing the instance ID and a message confirming the successful removal of the datasource instance.
#>
Function Remove-LMDeviceDatasourceInstance {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Int]$DatasourceId,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Int]$DeviceId,
    
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [String]$DeviceName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [String]$WildValue,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [Int]$InstanceId

    )

    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Device Id
            If ($DeviceName) {
                $LookupResult = (Get-LMDevice -Name $DeviceName).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $DeviceName) {
                    return
                }
                $DeviceId = $LookupResult
            }

            #Lookup DatasourceId
            If ($DatasourceName -or $DatasourceId) {
                $LookupResult = (Get-LMDeviceDataSourceList -Id $DeviceId | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId } ).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                    return
                }
                $HdsId = $LookupResult
            }

            #Lookup Wildcard Id
            If(!$InstanceId -and $WildValue) {
                $InstanceId = (Get-LMDeviceDataSourceInstance -Id $DeviceId -DatasourceId $DatasourceId | Where-Object { $_.wildValue -eq $WildValue }).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $InstanceId) {
                    return
                }
            }
            Else{
                Write-Error "Please provide a valid instance ID or wildvalue to remove a device datasource instance."
            }
            
            #Build header and uri
            $ResourcePath = "/device/devices/$DeviceId/devicedatasources/$HdsId/instances/$InstanceId"

            If ($PSItem) {
                $Message = "DeviceDisplayName: $($PSItem.deviceDisplayName) | DatasourceName: $($PSItem.name) | WildValue: $($PSItem.wildValue)"
            }
            Elseif ($DatasourceName -and $DeviceName) {
                $Message = "Name: $DeviceName | DatasourceName: $DatasourceName | WildValue: $WildValue"
            }
            Else {
                $Message = "Id: $DeviceId | DatasourceId: $DatasourceId | WildValue: $WildValue"
            }

            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove Device Datasource Instance")) {                    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
    
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
    End {}
}
