<#
.SYNOPSIS
Retrieves devices discovered during a Netscan execution.

.DESCRIPTION
The Get-LMNetscanExecutionDevices function retrieves devices discovered during a specific Netscan execution in LogicMonitor. The Netscan can be identified by either ID or name.

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
Get-LMNetscanExecutionDevices -Id 456 -NspId 123

.EXAMPLE
#Retrieve devices using Netscan name
Get-LMNetscanExecutionDevices -Id 456 -NspName "Network-Discovery"

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

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests
        while (!$Done) {
            #Build query params
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
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                if ($PSCmdlet.ParameterSetName -eq "Id") {
                    $Done = $true
                    return (Add-ObjectTypeInfo -InputObject $Response.items -TypeName "LogicMonitor.NetScanExecutionDevice" )
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
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.NetScanExecutionDevice" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
