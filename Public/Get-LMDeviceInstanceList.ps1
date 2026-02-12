<#
.SYNOPSIS
Retrieves a list of instances for a LogicMonitor device.

.DESCRIPTION
The Get-LMDeviceInstanceList function retrieves all instances associated with a specific device in LogicMonitor. The device can be identified by either ID or name, and the results can be filtered.

.PARAMETER Id
The ID of the device to retrieve instances from. Required for Id parameter set.

.PARAMETER Name
The name of the device to retrieve instances from. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving instances. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.PARAMETER CountOnly
When set to true, returns only the total count of instances instead of the instance details.

.EXAMPLE
#Retrieve instances by device ID
Get-LMDeviceInstanceList -Id 123

.EXAMPLE
#Get instance count for a device
Get-LMDeviceInstanceList -Name "Production-Server" -CountOnly $true

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns device instance objects or a count if CountOnly is specified.
#>

function Get-LMDeviceInstanceList {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000,

        [Boolean]$CountOnly
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        if ($Name) {
            $LookupResult = (Get-LMDevice -Name $Name).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        $ResourcePath = "/device/devices/$Id/instances"
        $CommandInvocation = $MyInvocation

        if ($CountOnly) {
            $QueryParams = "?size=1&offset=0&sort=-endDateTime"
            if ($Filter) {
                $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                $QueryParams = "?filter=$ValidFilter&size=1&offset=0&sort=-endDateTime"
            }
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams
            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return }
            return $Response.Total
        }

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = "?size=$PageSize&offset=$Offset&sort=-endDateTime"
            if ($Filter) {
                $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=-endDateTime"
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return $null }
            return $Response
        }

        if ($null -eq $Results) { return }
        return $Results
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
