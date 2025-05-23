<#
.SYNOPSIS
Removes a LogicMonitor device.

.DESCRIPTION
The Remove-LMDevice function removes a LogicMonitor device based on either its ID or name. It supports both hard delete and soft delete options.

.PARAMETER Id
Specifies the ID of the device to be removed. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the device to be removed. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER HardDelete
Indicates whether the device should be hard deleted. If set to $true, the device will be permanently deleted. If set to $false (default), the device will be moved to the Recycle Bin.

.EXAMPLE
Remove-LMDevice -Id 12345
Removes the LogicMonitor device with ID 12345.

.EXAMPLE
Remove-LMDevice -Name "MyDevice"
Removes the LogicMonitor device with the name "MyDevice".

.EXAMPLE
Remove-LMDevice -Name "MyDevice" -HardDelete $true
Permanently deletes the LogicMonitor device with the name "MyDevice".

.INPUTS
You can pipe input to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed device and a message indicating the success of the removal operation.
#>
Function Remove-LMDevice {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [boolean]$HardDelete = $false

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            If ($Name) {
                $LookupResult = (Get-LMDevice -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            If ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            Elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            Else {
                $Message = "Id: $Id"
            }
            
            #Build header and uri
            $ResourcePath = "/device/devices/$Id"
    
            $QueryParams = "?deleteHard=$HardDelete"
    
            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove Device")) {                    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams
    
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
