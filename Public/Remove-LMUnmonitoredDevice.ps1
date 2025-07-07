<#
.SYNOPSIS
Removes unmonitored devices from LogicMonitor.

.DESCRIPTION
The Remove-LMUnmonitoredDevice function removes one or more unmonitored devices from LogicMonitor using their IDs.

.PARAMETER Ids
Specifies an array of IDs for the unmonitored devices to remove.

.EXAMPLE
Remove-LMUnmonitoredDevice -Ids "123","456"
Removes the unmonitored devices with IDs "123" and "456".

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.UnmonitoredDevice object containing information about the removed devices.
#>

function Remove-LMUnmonitoredDevice {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [String[]]$Ids

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/device/unmonitoreddevices/batchdelete"

            $Message = "Id(s): $Ids"

            try {
                if ($PSCmdlet.ShouldProcess($Message, "Remove Unmonitored Devices")) {
                    [String[]]$Data = $Ids
                    $Data = ($Data | ConvertTo-Json -AsArray)

                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.UnmonitoredDevice" )
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