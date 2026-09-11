<#
.SYNOPSIS
Retrieves LogicMonitor collector events.

.DESCRIPTION
The Get-LMCollectorEvent function retrieves events for a specified collector from LogicMonitor. The collector can be identified by either ID or name.

.PARAMETER Id
The ID of the collector to retrieve events from. Required for the Id parameter set.

.PARAMETER Name
The name of the collector to retrieve events from. Required for the Name parameter set.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve collector events by collector ID
Get-LMCollectorEvent -Id 123

.EXAMPLE
#Retrieve collector events by collector name
Get-LMCollectorEvent -Name "Collector1"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.CollectorEvent objects.
#>
function Get-LMCollectorEvent {
    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        return
    }

    if ($Name) {
        $LookupResult = (Get-LMCollector -Name $Name).Id
        if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
            return
        }
        $Id = $LookupResult
    }

    $ResourcePath = "/setting/collector/collectors/$Id/events"

    $CommandInvocation = $MyInvocation
    $CallerPSCmdlet = $PSCmdlet

    $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -InvokeRequest {
        param($Offset, $PageSize)

        $RequestResourcePath = $ResourcePath
        $QueryParams = "?size=$PageSize&offset=$Offset"

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

    return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.CollectorEvent")
}
