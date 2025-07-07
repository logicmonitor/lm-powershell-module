<#
.SYNOPSIS
Retrieves configuration source data for a LogicMonitor device.

.DESCRIPTION
The Get-LMDeviceConfigSourceData function retrieves configuration data from a specific device's configuration source in LogicMonitor. It supports retrieving full configurations or delta changes, and can return either all configs or just the latest one.

.PARAMETER Id
The ID of the device to retrieve configuration data for. This parameter is mandatory.

.PARAMETER HdsId
The ID of the host datasource. This parameter is mandatory.

.PARAMETER HdsInsId
The ID of the host datasource instance. This parameter is mandatory.

.PARAMETER ConfigId
The specific configuration ID to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER LatestConfigOnly
Switch to retrieve only the most recent configuration. Part of the ListConfigs parameter set.

.PARAMETER ConfigType
The type of configuration to retrieve. Valid values are "Delta" or "Full". Defaults to "Delta".

.EXAMPLE
#Retrieve latest configuration for a device
Get-LMDeviceConfigSourceData -Id 123 -HdsId 456 -HdsInsId 789 -LatestConfigOnly

.EXAMPLE
#Retrieve full configuration history
Get-LMDeviceConfigSourceData -Id 123 -HdsId 456 -HdsInsId 789 -ConfigType Full

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns configuration data objects.
#>

function Get-LMDeviceConfigSourceData {

    [CmdletBinding(DefaultParameterSetName = 'ListDiffs')]
    param (
        [Parameter(Mandatory)]
        [Int]$Id,

        [Parameter(Mandatory)]
        [String]$HdsId,

        [Parameter(Mandatory)]
        [String]$HdsInsId,

        [Parameter(ParameterSetName = 'ConfigId')]
        [String]$ConfigId,

        [Parameter(ParameterSetName = 'ListConfigs')]
        [switch]$LatestConfigOnly,

        [Parameter(ParameterSetName = 'ListConfigs')]
        [ValidateSet("Delta", "Full")]
        [String]$ConfigType = "Delta"

    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$HdsInsId/config"

        #Initalize vars
        $QueryParams = ""
        $SortParam = ""
        $Count = 0
        $Done = $false
        $Results = @()

        switch ($ConfigType) {
            "Delta" { $ConfigField = "!config" }
            "Full" { $ConfigField = "!deltaConfig" }
        }

        if ($LatestConfigOnly) {
            $BatchSize = 1
            $SortParam = "&sort=-pollTimestamp"
        }

        #Loop through requests
        while (!$Done) {
            #Build query params
            if ($ConfigId) {
                $ResourcePath = $ResourcePath + "/$ConfigId"
                $QueryParams = "?deviceId=$Id&deviceDataSourceId=$HdsId&instanceId=$HdsInsId&fields=$ConfigField"
            }
            else {
                $QueryParams = "?size=$BatchSize&offset=$Count&fields=$ConfigField$SortParam"
            }

            
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
            elseif ($LatestConfigOnly) {
                return $Response.Items
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
        return $Results
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
