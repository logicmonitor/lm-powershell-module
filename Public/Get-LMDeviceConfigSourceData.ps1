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

Function Get-LMDeviceConfigSourceData {

    [CmdletBinding(DefaultParameterSetName = 'ListDiffs')]
    Param (
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
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$HdsInsId/config"

        #Initalize vars
        $QueryParams = ""
        $SortParam = ""
        $Count = 0
        $Done = $false
        $Results = @()

        Switch ($ConfigType) {
            "Delta" { $ConfigField = "!config" }
            "Full" { $ConfigField = "!deltaConfig" }
        }

        If ($LatestConfigOnly) {
            $BatchSize = 1
            $SortParam = "&sort=-pollTimestamp"
        }

        #Loop through requests 
        While (!$Done) {
            #Build query params
            If ($ConfigId) {
                $ResourcePath = $ResourcePath + "/$ConfigId"
                $QueryParams = "?deviceId=$Id&deviceDataSourceId=$HdsId&instanceId=$HdsInsId&fields=$ConfigField"
            }
            Else {
                $QueryParams = "?size=$BatchSize&offset=$Count&fields=$ConfigField$SortParam"
            }

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
                                
                
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                If (![bool]$Response.psobject.Properties["total"]) {
                    $Done = $true
                    Return $Response
                }
                Elseif ($LatestConfigOnly) {
                    Return $Response.Items
                }
                #Check result size and if needed loop again
                Else {
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If ($Count -ge $Total) {
                        $Done = $true
                    }
                }
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Return $Results
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
