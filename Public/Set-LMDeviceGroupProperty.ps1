<#
.SYNOPSIS
Updates a property value for a LogicMonitor device group.

.DESCRIPTION
The Set-LMDeviceGroupProperty function modifies the value of a specific property for a device group in LogicMonitor.

.PARAMETER Id
Specifies the ID of the device group. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the device group. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER PropertyName
Specifies the name of the property to update.

.PARAMETER PropertyValue
Specifies the new value for the property.

.EXAMPLE
Set-LMDeviceGroupProperty -Id 123 -PropertyName "Location" -PropertyValue "New York"
Updates the "Location" property to "New York" for the device group with ID 123.

.INPUTS
You can pipe device group objects containing Id properties to this function.

.OUTPUTS
Returns the response from the API indicating the success of the property update.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMDeviceGroupProperty {

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
                $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/device/groups/$Id/properties/$PropertyName"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name) | Property: $PropertyName = $PropertyValue"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name | Property: $PropertyName = $PropertyValue"
            }
            else {
                $Message = "Id: $Id | Property: $PropertyName = $PropertyValue"
            }

            
            $Data = @{
                value = $PropertyValue
            }

            $Data = ($Data | ConvertTo-Json)

            if ($PSCmdlet.ShouldProcess($Message, "Set Device Group Property")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

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
