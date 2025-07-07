<#
.SYNOPSIS
Retrieves Netflow endpoint data for a LogicMonitor device.

.DESCRIPTION
The Get-LMDeviceNetflowEndpoints function retrieves Netflow endpoint information for a specified device. It supports time range filtering and can identify the device by either ID or name.

.PARAMETER Id
The ID of the device to retrieve Netflow endpoints from. Required for Id parameter set.

.PARAMETER Name
The name of the device to retrieve Netflow endpoints from. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving endpoints. This parameter is optional.

.PARAMETER StartDate
The start date for retrieving Netflow data. Defaults to 24 hours ago if not specified.

.PARAMETER EndDate
The end date for retrieving Netflow data. Defaults to current time if not specified.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve Netflow endpoints by device ID
Get-LMDeviceNetflowEndpoints -Id 123

.EXAMPLE
#Retrieve Netflow endpoints with date range
Get-LMDeviceNetflowEndpoints -Name "Router1" -StartDate (Get-Date).AddDays(-7)

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns Netflow endpoint objects.
#>

function Get-LMDeviceNetflowEndpoint {

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
        $ResourcePath = "/device/devices/$Id/endpoints"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests
        while (!$Done) {
            #Build query params
            $QueryParams = "?size=$BatchSize&offset=$Count&sort=-usage&start=$StartDate&end=$EndDate"

            if ($Filter) {
                #List of allowed filter props
                $PropList = @()
                $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=-usage"
            }

            try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                if (![bool]$Response.psobject.Properties["total"]) {
                    $Done = $true
                    return $Response
                }
                #Check result size and if needed loop again
                else {
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    if ($Count -ge $Total) {
                        $Done = $true
                    }
                }
            }
            catch {
                return
            }
        }
        return $Results
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
