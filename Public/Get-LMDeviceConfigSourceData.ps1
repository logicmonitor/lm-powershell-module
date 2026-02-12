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

        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$HdsInsId/config"
        $CommandInvocation = $MyInvocation

        switch ($ConfigType) {
            "Delta" { $ConfigField = "!config" }
            "Full" { $ConfigField = "!deltaConfig" }
        }

        if ($ConfigId) {
            $RequestResourcePath = "$ResourcePath/$ConfigId"
            $QueryParams = "?deviceId=$Id&deviceDataSourceId=$HdsId&instanceId=$HdsInsId&fields=$ConfigField"
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams
            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return }
            return $Response
        }

        $BatchSize = if ($LatestConfigOnly) { 1 } else { 1000 }
        $SortParam = if ($LatestConfigOnly) { "&sort=-pollTimestamp" } else { "" }

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = "?size=$PageSize&offset=$Offset&fields=$ConfigField$SortParam"

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return $null }
            return $Response
        }

        if ($null -eq $Results) { return }
        if ($LatestConfigOnly -and $Results -is [array] -and $Results.Count -gt 0) {
            return $Results[0]
        }
        return $Results
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
