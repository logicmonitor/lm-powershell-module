<#
.SYNOPSIS
Removes a LogicMonitor Uptime device using the v3 device endpoint.

.DESCRIPTION
The Remove-LMUptimeDevice cmdlet deletes an Uptime monitor (web or ping) from LogicMonitor via
the v3 device endpoint. It accepts either the numerical identifier or resolves the identifier
from a device name, and submits a DELETE request with the required X-Version header.

.PARAMETER Id
Specifies the device identifier to remove. Accepts pipeline input by property name.

.PARAMETER Name
Specifies the device name to remove. The cmdlet resolves the device and then removes it.

.PARAMETER HardDelete
Indicates whether to permanently delete the device. When $false (default), the device is moved
to the recycle bin.

.EXAMPLE
Remove-LMUptimeDevice -Id 42

Removes the Uptime device with ID 42.

.EXAMPLE
Remove-LMUptimeDevice -Name "web-int-01"

Resolves the device ID by name and removes the corresponding Uptime device.

.NOTES
You must run Connect-LMAccount before invoking this cmdlet. Requests target
/device/devices/{id}?deleteHard={bool} with X-Version 3.

.OUTPUTS
System.Management.Automation.PSCustomObject
#>
function Remove-LMUptimeDevice {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Bool]$HardDelete = $false
    )

    process {
        if (-not $Script:LMAuth.Valid) {
            Write-Error 'Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.'
            return
        }

        $resolvedName = $null
        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            $lookupResult = (Get-LMDevice -Name $Name)
            if (Test-LookupResult -Result $lookupResult.Id -LookupString $Name) {
                return
            }

            if ($lookupResult.deviceType -notin 18, 19) {
                Write-Error "The specified device is not an Uptime device."
                return
            }

            $Id = $lookupResult.Id
            $resolvedName = $lookupResult.name
        }

        $resourcePath = "/device/devices/$Id"
        $query = "?deleteHard=$([bool]$HardDelete)"

        $headers = New-LMHeader -Auth $Script:LMAuth -Method 'DELETE' -ResourcePath $resourcePath -Version 3
        $uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)$resourcePath$query"

        $messageName = if ($resolvedName) { $resolvedName } elseif ($PSBoundParameters.ContainsKey('Name')) { $Name } else { $null }
        $message = if ($messageName) { "Id: $Id | Name: $messageName" } else { "Id: $Id" }

        if ($PSCmdlet.ShouldProcess($message, 'Remove Uptime Device')) {
            Resolve-LMDebugInfo -Url $uri -Headers $headers[0] -Command $MyInvocation

            Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $uri -Method 'DELETE' -Headers $headers[0] -WebSession $headers[1] | Out-Null

            $result = [PSCustomObject]@{
                Id      = $Id
                Message = "Successfully removed ($message)"
            }

            return $result
        }
    }
}

