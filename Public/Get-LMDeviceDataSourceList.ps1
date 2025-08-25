<#
.SYNOPSIS
Retrieves a list of device data sources from LogicMonitor.

.DESCRIPTION
The Get-LMDeviceDatasourceList function retrieves all data sources associated with a specific device. The device can be identified by either ID or name, and the results can be filtered.

.PARAMETER Id
The ID of the device. Can be specified using the DeviceId alias. Required for Id parameter set.

.PARAMETER Name
The name of the device. Can be specified using the DeviceName alias. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving data sources. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve data sources by device ID
Get-LMDeviceDatasourceList -Id 1234

.EXAMPLE
#Retrieve data sources by device name with filter
Get-LMDeviceDatasourceList -Name "MyDevice" -Filter $filterObject

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DeviceDatasourceList objects.
#>
function Get-LMDeviceDataSourceList {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Alias('DeviceId')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [Alias('DeviceName')]
        [String]$Name,

        [Object]$Filter,

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

        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests
        while (!$Done) {
            #Build query params
            $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id"

            if ($Filter) {
                #List of allowed filter props
                $PropList = @()
                $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
            }

            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            #Stop looping if single device, no need to continue
            if (![bool]$Response.psobject.Properties["total"]) {
                $Done = $true
                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceDatasourceList" )
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
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DeviceDatasourceList" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
