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

        #Track delta id response for Delta mode.
        $DeltaIdResponse = ""
        $ParameterSetName = $PSCmdlet.ParameterSetName
        $CommandInvocation = $MyInvocation
        $SingleObjectWhenNotPaged = $ParameterSetName -eq "Id"

        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = ""

            switch ($ParameterSetName) {
                "All" { $QueryParams = "?filter=deviceType:%226%22&size=$PageSize&offset=$Offset&sort=+id" }
                "Delta" {
                    if ($DeltaId) {
                        $RequestResourcePath = "$ResourcePath/$DeltaId"
                    }
                    $QueryParams = "?size=$PageSize&offset=$Offset"
                }
                "Id" { $RequestResourcePath = "$ResourcePath/$Id" }
                "DisplayName" { $QueryParams = "?filter=deviceType:%226%22,displayName:%22$DisplayName%22&size=$PageSize&offset=$Offset&sort=+id" }
                "Name" { $QueryParams = "?filter=deviceType:%226%22,name:%22$Name%22&size=$PageSize&offset=$Offset&sort=+id" }
                "Filter" {
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                    $QueryParams = "?filter=$ValidFilter,deviceType:%226%22&size=$PageSize&offset=$Offset&sort=+id"
                }
                "FilterWizard" {
                    $Filter = Build-LMFilter -PassThru -ResourcePath $ResourcePath
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                    $QueryParams = "?filter=$ValidFilter,deviceType:%226%22&size=$PageSize&offset=$Offset&sort=+id"
                }
            }

            if ($Delta -and $DeltaIdResponse) {
                $QueryParams = $QueryParams + "&deltaId=$DeltaIdResponse"
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            if ($null -eq $Response) {
                return $null
            }

            #Store delta id if delta switch is present
            if ($Response.deltaId -and !$DeltaIdResponse) {
                $DeltaIdResponse = $Response.deltaId
                Write-Information "[INFO]: Delta switch detected, for further queries you can use deltaId: $DeltaIdResponse to perform additional delta requests. This variable can be accessed by referencing the `$LMDeltaId "
                Set-Variable -Name "LMDeltaId" -Value $DeltaIdResponse -Scope global
            }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        if ($PSCmdlet.ParameterSetName -eq "Id") {
            return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Service" )
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Service" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
