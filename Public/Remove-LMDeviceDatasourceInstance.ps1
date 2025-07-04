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
function Remove-LMDeviceDatasourceInstance {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
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

    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup Device Id
            if ($DeviceName) {
                $LookupResult = (Get-LMDevice -Name $DeviceName).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DeviceName) {
                    return
                }
                $DeviceId = $LookupResult
            }

            #Lookup DatasourceId
            if ($DatasourceName -or $DatasourceId) {
                $LookupResult = (Get-LMDeviceDataSourceList -Id $DeviceId | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId } ).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                    return
                }
                $HdsId = $LookupResult
            }

            #Lookup Wildcard Id
            if (!$InstanceId -and $WildValue) {
                $LookupResult = (Get-LMDeviceDataSourceInstance -Id $DeviceId -DatasourceId $DatasourceId | Where-Object { $_.wildValue -eq $WildValue }).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $WildValue) {
                    return
                }
                $InstanceId = $LookupResult
            }
            elseif (!$InstanceId -and !$WildValue) {
                Write-Error "Please provide a valid instance ID or wildvalue to remove a device datasource instance."
                return
            }

            #Build header and uri
            $ResourcePath = "/device/devices/$DeviceId/devicedatasources/$HdsId/instances/$InstanceId"

            if ($PSItem) {
                $Message = "DeviceDisplayName: $($PSItem.deviceDisplayName) | DatasourceName: $($PSItem.name) | WildValue: $($PSItem.wildValue)"
            }
            elseif ($DatasourceName -and $DeviceName) {
                $Message = "Name: $DeviceName | DatasourceName: $DatasourceName | WildValue: $WildValue"
            }
            else {
                $Message = "Id: $DeviceId | DatasourceId: $DatasourceId | WildValue: $WildValue"
            }

            if ($PSCmdlet.ShouldProcess($Message, "Remove Device Datasource Instance")) {
                try {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    Invoke-LMRestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

                    $Result = [PSCustomObject]@{
                        InstanceId = $InstanceId
                        Message    = "Successfully removed ($Message)"
                    }

                    return $Result
                }
                catch {
                    return
                }
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
