<#
.SYNOPSIS
Retrieves Netflow flow data for a LogicMonitor device.

.DESCRIPTION
The Get-LMDeviceNetflowFlow function retrieves Netflow flow information for a specified device. It supports time range filtering and can identify the device by either ID or name.

.PARAMETER Id
The ID of the device to retrieve Netflow flows from. Required for Id parameter set.

.PARAMETER Name
The name of the device to retrieve Netflow flows from. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving flows. This parameter is optional.

.PARAMETER StartDate
The start date for retrieving Netflow data. Defaults to 24 hours ago if not specified.

.PARAMETER EndDate
The end date for retrieving Netflow data. Defaults to current time if not specified.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve Netflow flows by device ID
Get-LMDeviceNetflowFlow -Id 123

.EXAMPLE
#Retrieve Netflow flows with date range
Get-LMDeviceNetflowFlow -Name "Router1" -StartDate (Get-Date).AddDays(-7)

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns Netflow flow objects.
#>

function Get-LMDeviceNetflowFlow {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Object]$Filter,

        [Datetime]$StartDate,

        [Datetime]$EndDate,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
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

        #Convert to epoch, if not set use defaults (24 hours ago)
        if (!$StartDate) {
            [int]$StartDate = ([DateTimeOffset]$(Get-Date).AddHours(-24)).ToUnixTimeSeconds()
        }
        else {
            [int]$StartDate = ([DateTimeOffset]$($StartDate)).ToUnixTimeSeconds()
        }

        if (!$EndDate) {
            [int]$EndDate = ([DateTimeOffset]$(Get-Date)).ToUnixTimeSeconds()
        }
        else {
            [int]$EndDate = ([DateTimeOffset]$($EndDate)).ToUnixTimeSeconds()
        }

        #Build header and uri
        $ResourcePath = "/device/devices/$Id/flows"

        $CommandInvocation = $MyInvocation
        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = "?size=$PageSize&offset=$Offset&sort=-usage&start=$StartDate&end=$EndDate"

            if ($Filter) {
                $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=-usage"
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) {
                return $null
            }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        return $Results
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
