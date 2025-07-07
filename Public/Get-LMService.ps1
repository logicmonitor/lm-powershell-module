<#
.SYNOPSIS
Retrieves service information from LogicMonitor.

.DESCRIPTION
The Get-LMService function retrieves service information from LogicMonitor based on specified parameters. It can return a single service by ID or multiple services based on name, display name, filter, or filter wizard. It also supports delta tracking for monitoring changes.

.PARAMETER Id
The ID of the service to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER DisplayName
The display name of the service to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Name
The name of the service to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving services. Part of a mutually exclusive parameter set.

.PARAMETER FilterWizard
Switch to use the filter wizard interface for building the filter. Part of a mutually exclusive parameter set.

.PARAMETER Delta
Switch to return a deltaId along with the requested data for change tracking.

.PARAMETER DeltaId
The deltaId string for retrieving changes since a previous query.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve a service by ID
Get-LMService -Id 123

.EXAMPLE
#Retrieve services with delta tracking
Get-LMService -Delta

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Service objects.
#>
function Get-LMService {

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
                "All" { $QueryParams = "?filter=deviceType:%226%22&size=$BatchSize&offset=$Count&sort=+id" }
                "Delta" { $resourcePath += "/$DeltaId" ; $QueryParams = "?size=$BatchSize&offset=$Count" }
                "Id" { $resourcePath += "/$Id" }
                "DisplayName" { $QueryParams = "?filter=deviceType:%226%22,displayName:%22$DisplayName%22&size=$BatchSize&offset=$Count&sort=+id" }
                "Name" { $QueryParams = "?filter=deviceType:%226%22,name:%22$Name%22&size=$BatchSize&offset=$Count&sort=+id" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter,deviceType:%226%22&size=$BatchSize&offset=$Count&sort=+id"
                }
                "FilterWizard" {
                    $PropList = @()
                    $Filter = Build-LMFilter -PassThru
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter,deviceType:%226%22&size=$BatchSize&offset=$Count&sort=+id"
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
                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Service" )
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
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Service" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
