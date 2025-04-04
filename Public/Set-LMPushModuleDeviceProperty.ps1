<#
.SYNOPSIS
Updates a device property using the LogicMonitor Push Module.

.DESCRIPTION
The Set-LMPushModuleDeviceProperty function modifies a property value for a device using the LogicMonitor Push Module API.

.PARAMETER Id
Specifies the ID of the device.

.PARAMETER Name
Specifies the name of the device.

.PARAMETER PropertyName
Specifies the name of the property to update.

.PARAMETER PropertyValue
Specifies the new value for the property.

.EXAMPLE
Set-LMPushModuleDeviceProperty -Id 123 -PropertyName "location" -PropertyValue "New York"
Updates the location property for device ID 123.

.INPUTS
None.

.OUTPUTS
Returns the response from the API indicating the success of the property update.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

Function Set-LMPushModuleDeviceProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$PropertyName,

        [Parameter(Mandatory)]
        [String]$PropertyValue
    )

    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            If ($Name) {
                $LookupResult = (Get-LMDevice -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
            
            #Build header and uri
            $ResourcePath = "/resource_property/ingest"

            Try {
                $Data = @{
                    resourceIds        = @{"system.deviceid" = $Id }
                    resourceProperties = @{$PropertyName = $PropertyValue }
                }

                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return $Response
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
