<#
.SYNOPSIS
Removes a property from a LogicMonitor device.

.DESCRIPTION
The Remove-LMDeviceProperty function removes a specified property from a LogicMonitor device. It can remove the property either by providing the device ID or the device name.

.PARAMETER Id
The ID of the device from which the property should be removed. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The name of the device from which the property should be removed. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER PropertyName
The name of the property to be removed. This parameter is mandatory.

.EXAMPLE
Remove-LMDeviceProperty -Id 1234 -PropertyName "Property1"
Removes the property named "Property1" from the device with ID 1234.

.EXAMPLE
Remove-LMDeviceProperty -Name "Device1" -PropertyName "Property2"
Removes the property named "Property2" from the device with the name "Device1".

.INPUTS
None.

.OUTPUTS
Returns a PSCustomObject containing the ID of the device and a message confirming the successful removal of the property.

.NOTES
This function requires a valid LogicMonitor API authentication. Make sure you are logged in before running any commands.
#>
function Remove-LMDeviceProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$PropertyName

    )
    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            if ($Name) {
                $LookupResult = (Get-LMDevice -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/device/devices/$Id/properties/$PropertyName"

            if ($Name) {
                $Message = "Id: $Id | Name: $Name | Property: $PropertyName"
            }
            else {
                $Message = "Id: $Id | Property: $PropertyName"
            }

            try {
                if ($PSCmdlet.ShouldProcess($Message, "Remove Device Property")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

                    $Result = [PSCustomObject]@{
                        Id      = $Id
                        Message = "Successfully removed ($Message)"
                    }

                    return $Result
                }
            }
            catch {
                return
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
