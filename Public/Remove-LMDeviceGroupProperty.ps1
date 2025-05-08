<#
.SYNOPSIS
Removes a property from a LogicMonitor device group.

.DESCRIPTION
The Remove-LMDeviceGroupProperty function removes a specified property from a LogicMonitor device group. It can remove the property either by providing the device group ID or the device group name.

.PARAMETER Id
The ID of the device group from which the property should be removed. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The name of the device group from which the property should be removed. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER PropertyName
The name of the property to be removed. This parameter is mandatory.

.EXAMPLE
Remove-LMDeviceGroupProperty -Id 1234 -PropertyName "Property1"
Removes the property named "Property1" from the device with ID 1234.

.EXAMPLE
Remove-LMDeviceGroupProperty -Name "Device1" -PropertyName "Property2"
Removes the property named "Property2" from the device with the name "Device1".

.INPUTS
None.

.OUTPUTS
Returns a PSCustomObject containing the ID of the device group and a message confirming the successful removal of the property.

.NOTES
This function requires a valid LogicMonitor API authentication. Make sure you are logged in before running any commands.
#>
Function Remove-LMDeviceGroupProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$PropertyName

    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            If ($Name) {
                $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
            
            #Build header and uri
            $ResourcePath = "/device/groups/$Id/properties/$PropertyName"

            If ($Name) {
                $Message = "Id: $Id | Name: $Name | Property: $PropertyName"
            }
            Else {
                $Message = "Id: $Id | Property: $PropertyName"
            }

            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove Device Group Property")) {                    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath
    
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1]
                    
                    $Result = [PSCustomObject]@{
                        Id      = $Id
                        Message = "Successfully removed ($Message)"
                    }
                    
                    Return $Result
                }
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
