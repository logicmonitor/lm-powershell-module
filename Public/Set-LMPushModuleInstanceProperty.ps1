<#
.SYNOPSIS
Updates an instance property using the LogicMonitor Push Module.

.DESCRIPTION
The Set-LMPushModuleInstanceProperty function modifies a property value for a datasource instance using the LogicMonitor Push Module API.

.PARAMETER DeviceId
Specifies the ID of the device.

.PARAMETER DeviceName
Specifies the name of the device.

.PARAMETER DataSourceName
Specifies the name of the datasource.

.PARAMETER InstanceName
Specifies the name of the instance.

.PARAMETER PropertyName
Specifies the name of the property to update.

.PARAMETER PropertyValue
Specifies the new value for the property.

.EXAMPLE
Set-LMPushModuleInstanceProperty -DeviceId 123 -DataSourceName "CPU" -InstanceName "Total" -PropertyName "threshold" -PropertyValue "90"
Updates the threshold property for the CPU Total instance on device ID 123.

.INPUTS
None.

.OUTPUTS
Returns the response from the API indicating the success of the property update.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMPushModuleInstanceProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$DeviceId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$DeviceName,

        [Parameter(Mandatory)]
        [String]$DataSourceName,

        [Parameter(Mandatory)]
        [String]$InstanceName,

        [Parameter(Mandatory)]
        [String]$PropertyName,

        [Parameter(Mandatory)]
        [String]$PropertyValue
    )

    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            if ($DeviceName) {
                $LookupResult = (Get-LMDevice -Name $DeviceName).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DeviceName) {
                    return
                }
                $DeviceId = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/instance_property/ingest"

            if ($DeviceName) {
                $Message = "DeviceId: $DeviceId | DeviceName: $DeviceName | DataSource: $DataSourceName | Instance: $InstanceName | Property: $PropertyName = $PropertyValue"
            }
            else {
                $Message = "DeviceId: $DeviceId | DataSource: $DataSourceName | Instance: $InstanceName | Property: $PropertyName = $PropertyValue"
            }

            
            $Data = @{
                resourceIds        = @{"system.deviceid" = $DeviceId }
                instanceName       = $InstanceName
                dataSource         = $DataSourceName
                instanceProperties = @{$PropertyName = $PropertyValue }
            }

            $Data = ($Data | ConvertTo-Json)

            if ($PSCmdlet.ShouldProcess($Message, "Set Push Module Instance Property")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return $Response
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
