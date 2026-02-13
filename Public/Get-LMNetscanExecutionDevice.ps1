<#
.SYNOPSIS
Retrieves devices discovered during a Netscan execution.

.DESCRIPTION
The Get-LMNetscanExecutionDevice function retrieves devices discovered during a specific Netscan execution in LogicMonitor. The Netscan can be identified by either ID or name.

.PARAMETER Id
The ID of the execution to retrieve devices from. Required for Id parameter set.

.PARAMETER NspId
The ID of the Netscan. Required when using Id parameter set.

.PARAMETER NspName
The name of the Netscan. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving devices.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve devices from a specific execution
Get-LMNetscanExecutionDevice -Id 456 -NspId 123

.EXAMPLE
#Retrieve devices using Netscan name
Get-LMNetscanExecutionDevice -Id 456 -NspName "Network-Discovery"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.NetScanExecutionDevice objects.
#>

function Get-LMNetscanExecutionDevice {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [String]$NspId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$NspName,

        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        if ($NspName) {
            $LookupResult = (Get-LMNetscan -Name $NspName).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $NspName) {
                return
            }
            $NspId = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/setting/netscans/$NspId/executions/$Id/devices"

        $SingleObjectWhenNotPaged = $false

        $ExtractResponse = {
            param($r)
            if ($null -eq $r) { return $null }
            if (-not (Test-LMResponseHasPagination -Response $r) -and $r.items) { return $r.items }
            return $r
        }

        $CommandInvocation = $MyInvocation
        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id"

            if ($Filter) {
                $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return }

            return $Response
        } -ExtractResponse $ExtractResponse

        if ($null -eq $Results) {
            return
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.NetScanExecutionDevice" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
