<#
.SYNOPSIS
Updates unmonitored devices in LogicMonitor.

.DESCRIPTION
The Set-LMUnmonitoredDevice function modifies unmonitored devices in LogicMonitor by assigning them to a device group.

.PARAMETER Ids
Specifies an array of unmonitored device IDs to update.

.PARAMETER DeviceGroupId
Specifies the ID of the device group to assign the devices to.

.PARAMETER Description
Specifies a description for the devices.

.PARAMETER CollectorId
Specifies the ID of the collector to assign to the devices. Default is 0.

.EXAMPLE
#Assigns the specified unmonitored devices to the device group and sets their description.
Set-LMUnmonitoredDevice -Ids @("123", "456") -DeviceGroupId 789 -Description "New devices"


.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.Device object containing the updated device information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

Function Set-LMUnmonitoredDevice {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
        [Parameter(Mandatory)]
        [String[]]$Ids,

        [Parameter(Mandatory)]
        [Int]$DeviceGroupId,

        [String]$Description = "",

        [Int]$CollectorId = 0

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/device/unmonitoreddevices/services/assign"

            $IdsCount = ($Ids | Measure-Object).Count
            $Message = "Device Count: $IdsCount | DeviceGroupId: $DeviceGroupId"

            $Data = @{
                    collectorId      = $CollectorId
                    description      = $Description
                    deviceGroupId    = $DeviceGroupId
                    missingDeviceIds = $Ids
                }

                $Data = ($Data | ConvertTo-Json)

                If ($PSCmdlet.ShouldProcess($Message, "Set Unmonitored Device")) {
                    Try {
                        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                        #Issue request using new centralized method with retry logic
                        $Response = Invoke-LMRestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                        Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Device" )
                    }
                    Catch {
                        # Error is already displayed by Resolve-LMException, just return cleanly
                        return
                    }
                }
            }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
