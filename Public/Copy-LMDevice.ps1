<#
.SYNOPSIS
Creates a copy of a LogicMonitor device.

.DESCRIPTION
The Copy-LMDevice function creates a new device based on an existing device's configuration. It allows you to specify a new name, display name, and description while maintaining other settings from the source device.

.PARAMETER Name
The name for the new device. This parameter is mandatory.

.PARAMETER DisplayName
The display name for the new device. If not specified, defaults to the Name parameter value.

.PARAMETER Description
An optional description for the new device.

.PARAMETER DeviceObject
The source device object to copy settings from. This parameter is mandatory.

.EXAMPLE
#Copy a device with basic settings
Copy-LMDevice -Name "NewDevice" -DeviceObject $deviceObject

.EXAMPLE
#Copy a device with custom display name and description
Copy-LMDevice -Name "NewDevice" -DisplayName "New Display Name" -Description "New device description" -DeviceObject $deviceObject

.NOTES
Masked custom properties from the source device will need to be manually updated on the new device as they are not available via the API.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns the newly created device object.
#>
Function Copy-LMDevice {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$DisplayName = $Name,

        [String]$Description,

        [Parameter(Mandatory)]
        $DeviceObject
    )
    #Check if we are logged in and have valid api creds
    Begin {
        Write-Output "[INFO]: Any custom properties from the reference device that are masked will need to be updated on the cloned resource as those values are not available to the LM API."
    }
    Process {
        If ($Script:LMAuth.Valid) {
            #Strip out dynamic groups
            $HostGroupIds = ($DeviceObjec.hostGroupIds -Split "," | Get-LMDeviceGroup | Where-Object { $_.appliesTo -eq "" }).Id -Join ","

            $Data = @{
                name                         = $Name
                displayName                  = If ($DisplayName) { $DisplayName }Else { $DeviceObject.displayName }
                description                  = If ($Description) { $Description }Else { $DeviceObject.description }
                disableAlerting              = $DeviceObject.disableAlerting
                enableNetflow                = $DeviceObject.enableNetFlow
                customProperties             = $DeviceObject.customProperties
                deviceType                   = $DeviceObject.deviceType
                preferredCollectorId         = $DeviceObject.preferredCollectorId
                preferredCollectorGroupId    = $DeviceObject.preferredCollectorGroupId
                autoBalancedCollectorGroupId = $DeviceObject.autoBalancedCollectorGroupId
                link                         = $DeviceObject.link
                netflowCollectorGroupId      = $DeviceObject.netflowCollectorGroupId
                netflowCollectorId           = $DeviceObject.netflowCollectorId
                logCollectorGroupId          = $DeviceObject.logCollectorGroupId
                logCollectorId               = $DeviceObject.logCollectorId
                hostGroupIds                 = If ($HostGroupIds) { $HostGroupIds }Else { 1 }
            }
                    
            #Build header and uri
            $ResourcePath = "/device/devices"

            Try {
                $Data = ($Data | ConvertTo-Json)
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Device" )
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
    End {
    }
}
