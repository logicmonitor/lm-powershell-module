<#
.SYNOPSIS
Retrieves device information from LogicMonitor.

.DESCRIPTION
The Get-LMDevice function retrieves device information from LogicMonitor based on specified parameters. It can return a single device by ID or multiple devices based on name, display name, filter, or filter wizard. It also supports delta tracking for monitoring changes.

.PARAMETER Id
The ID of the device to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER DisplayName
The display name of the device to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Name
The name of the device to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving devices. Part of a mutually exclusive parameter set.

.PARAMETER FilterWizard
Switch to use the filter wizard interface for building the filter. Part of a mutually exclusive parameter set.

.PARAMETER Delta
Switch to return a deltaId along with the requested data for change tracking.

.PARAMETER DeltaId
The deltaId string for retrieving changes since a previous query.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve a device by ID
Get-LMDevice -Id 123

.EXAMPLE
#Retrieve devices with delta tracking
Get-LMDevice -Delta

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Device objects.
#>
function Get-LMDevice {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the FilterWizard to work')]

    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'DisplayName')]
        [String]$DisplayName,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [Parameter(ParameterSetName = 'FilterWizard')]
        [Switch]$FilterWizard,

        [Parameter(ParameterSetName = 'Filter')]
        [Parameter(ParameterSetName = 'FilterWizard')]
        [Parameter(ParameterSetName = 'Name')]
        [Parameter(ParameterSetName = 'DisplayName')]
        [Parameter(ParameterSetName = 'All')]
        [Switch]$Delta,

        [Parameter(ParameterSetName = 'Delta')]
        [String]$DeltaId,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        if ($Delta -or $DeltaId) {
            $ResourcePath = "/device/devices/delta"
        }
        else {
            $ResourcePath = "/device/devices"
        }

        #Initalize vars
        $QueryParams = ""
        $DeltaIdResponse = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests
        while (!$Done) {
            #Build query params
            switch ($PSCmdlet.ParameterSetName) {
                "All" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id" }
                "Delta" { $resourcePath += "/$DeltaId" ; $QueryParams = "?size=$BatchSize&offset=$Count" }
                "Id" { $resourcePath += "/$Id" }
                "DisplayName" { $QueryParams = "?filter=displayName:`"$DisplayName`"&size=$BatchSize&offset=$Count&sort=+id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+id" }
                "Filter" {
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                }
                "FilterWizard" {
                    $Filter = Build-LMFilter -PassThru -ResourcePath $ResourcePath
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                }
            }
            if ($Delta -and $DeltaIdResponse) {
                $QueryParams = $QueryParams + "&deltaId=$DeltaIdResponse"
            }
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            #Store delta id if delta switch is present
            if ($Response.deltaId -and !$DeltaIdResponse) {
                $DeltaIdResponse = $Response.deltaId
                Write-Information "[INFO]: Delta switch detected, for further queries you can use deltaId: $DeltaIdResponse to perform additional delta requests. This variable can be accessed by referencing the `$LMDeltaId "
                Set-Variable -Name "LMDeltaId" -Value $DeltaIdResponse -Scope global
            }

            #Stop looping if single device, no need to continue
            if ($PSCmdlet.ParameterSetName -eq "Id") {
                $Done = $true

                #Filter out uptime devices
                #$Response = $Response | Where-Object { $_.deviceType -ne '18' -and $_.deviceType -ne '19' }

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Device" )
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
        #Filter out uptime devices
        #$Results = $Results | Where-Object { $_.deviceType -ne '18' -and $_.deviceType -ne '19' }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Device" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
