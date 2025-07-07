<#
.SYNOPSIS
Creates a new device group property in LogicMonitor.

.DESCRIPTION
The New-LMDeviceGroupProperty function creates a new device group property in LogicMonitor. It allows you to specify the property name and value, and either the device group ID or device group name.

.PARAMETER Id
Specifies the ID of the device group. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the device group. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER PropertyName
Specifies the name of the property to create.

.PARAMETER PropertyValue
Specifies the value of the property to create.

.EXAMPLE
New-LMDeviceGroupProperty -Id 1234 -PropertyName "Location" -PropertyValue "New York"

Creates a new device group property with the name "Location" and value "New York" for the device group with ID 1234.

.EXAMPLE
New-LMDeviceGroupProperty -Name "Servers" -PropertyName "Environment" -PropertyValue "Production"

Creates a new device group property with the name "Environment" and value "Production" for the device group with the name "Servers".

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
You can pipe device group objects to this command.

.OUTPUTS
Returns LogicMonitor.DeviceGroupProperty object.
#>
function New-LMDeviceGroupProperty {

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
                $Id = (Get-LMDeviceGroup -Name $Name | Select-Object -First 1 ).Id
                if (!$Id) {
                    Write-Error "Unable to find device group with name: $Name, please check spelling and try again."
                    return
                }
            }

            #Build header and uri
            $ResourcePath = "/device/groups/$Id/properties"

            $Data = @{
                name  = $PropertyName
                value = $PropertyValue
            }

            $Data = ($Data | ConvertTo-Json)

            $Message = "PropertyName: $PropertyName | DeviceGroupId: $Id"

            if ($PSCmdlet.ShouldProcess($Message, "Create Device Group Property")) {
                try {

                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

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
