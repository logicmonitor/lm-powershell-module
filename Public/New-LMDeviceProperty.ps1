<#
.SYNOPSIS
Creates a new device property in LogicMonitor.

.DESCRIPTION
The New-LMDeviceProperty function creates a new device property in LogicMonitor. It allows you to specify the property name and value, and either the device ID or device name.

.PARAMETER Id
Specifies the ID of the device. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the device. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER PropertyName
Specifies the name of the property to create.

.PARAMETER PropertyValue
Specifies the value of the property to create.

.EXAMPLE
New-LMDeviceProperty -Id 1234 -PropertyName "Location" -PropertyValue "New York"

Creates a new device property with the name "Location" and value "New York" for the device with ID 1234.

.EXAMPLE
New-LMDeviceProperty -Name "Server01" -PropertyName "Environment" -PropertyValue "Production"

Creates a new device property with the name "Environment" and value "Production" for the device with the name "Server01".

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DeviceProperty object.
#>
function New-LMDeviceProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$PropertyName,

        [Parameter(Mandatory)]
        [String]$PropertyValue
    )

    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            if ($Name) {
                if ($Name -match "\*") {
                    Write-Error "Wildcard values not supported for device name."
                    return
                }
                $Id = (Get-LMDevice -Name $Name | Select-Object -First 1 ).Id
                if (!$Id) {
                    Write-Error "Unable to find device with name: $Name, please check spelling and try again."
                    return
                }
            }

            #Build header and uri
            $ResourcePath = "/device/devices/$Id/properties"

            $Data = @{
                name  = $PropertyName
                value = $PropertyValue
            }

            $Data = ($Data | ConvertTo-Json)

            $Message = "PropertyName: $PropertyName | DeviceId: $Id"

            if ($PSCmdlet.ShouldProcess($Message, "Create Device Property")) {
                try {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-LMRestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    return $Response
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
}
