<#
.SYNOPSIS
Updates a property value for a LogicMonitor device.

.DESCRIPTION
The Set-LMDeviceProperty function modifies the value of a specific property for a device in LogicMonitor.

.PARAMETER Id
Specifies the ID of the device. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the device. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER PropertyName
Specifies the name of the property to update.

.PARAMETER PropertyValue
Specifies the new value for the property.

.EXAMPLE
Set-LMDeviceProperty -Id 123 -PropertyName "Location" -PropertyValue "New York"
Updates the "Location" property to "New York" for the device with ID 123.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns the response from the API indicating the success of the property update.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

Function Set-LMDeviceProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
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
            $ResourcePath = "/device/devices/$Id/properties/$PropertyName"

            Try {
                $Data = @{
                    value = $PropertyValue
                }

                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

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
