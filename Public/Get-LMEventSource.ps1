<#
.SYNOPSIS
Retrieves event sources from LogicMonitor.

.DESCRIPTION
The Get-LMEventSource function retrieves event source configurations from LogicMonitor. It can retrieve all event sources, a specific source by ID or name, or filter the results.

.PARAMETER Id
The ID of the specific event source to retrieve.

.PARAMETER Name
The name of the specific event source to retrieve.

.PARAMETER Filter
A filter object to apply when retrieving event sources.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve all event sources
Get-LMEventSource

.EXAMPLE
#Retrieve a specific event source by name
Get-LMEventSource -Name "Windows-Events"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.EventSource objects.
#>

function Get-LMEventSource {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/setting/eventsources"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests
        while (!$Done) {
            #Build query params
            switch ($PSCmdlet.ParameterSetName) {
                "All" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id" }
                "Id" { $resourcePath += "/$Id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+id" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                }
            }
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            #Stop looping if single device, no need to continue
            if ($PSCmdlet.ParameterSetName -eq "Id") {
                $Done = $true
                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.EventSource")
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
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.EventSource")
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
