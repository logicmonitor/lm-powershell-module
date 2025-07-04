<#
.SYNOPSIS
Retrieves properties for a LogicMonitor device.

.DESCRIPTION
The Get-LMDeviceProperty function retrieves properties for a specified device in LogicMonitor. The device can be identified by ID, name, or display name, and you can retrieve either all properties or a specific property.

.PARAMETER Id
The ID of the device to retrieve properties from. Required for Id parameter set.

.PARAMETER Name
The name of the device to retrieve properties from. Required for Name parameter set.

.PARAMETER DisplayName
The display name of the device to retrieve properties from. Required for DisplayName parameter set.

.PARAMETER PropertyName
The name of a specific property to retrieve. If not specified, retrieves all properties.

.PARAMETER Filter
A filter object to apply when retrieving properties. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve all properties for a device
Get-LMDeviceProperty -Id 123

.EXAMPLE
#Retrieve a specific property by name
Get-LMDeviceProperty -Name "Production-Server" -PropertyName "location"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns device property objects.
#>

function Get-LMDeviceProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'DisplayName')]
        [String]$DisplayName,

        [String]$PropertyName,

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

        if ($DisplayName) {
            if ($DisplayName -match "\*") {
                Write-Error "Wildcard values not supported for device name."
                return
            }
            $Id = (Get-LMDevice -DisplayName $DisplayName | Select-Object -First 1 ).Id
            if (!$Id) {
                Write-Error "Unable to find device with name: $DisplayName, please check spelling and try again."
                return
            }
        }

        #Build header and uri
        if ($PropertyName) {
            $ResourcePath = "/device/devices/$Id/properties/$PropertyName"
        }
        else {
            $ResourcePath = "/device/devices/$Id/properties"
        }

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

            try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-LMRestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

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
