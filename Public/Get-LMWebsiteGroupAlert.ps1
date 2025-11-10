<#
.SYNOPSIS
Retrieves alerts for a website group from LogicMonitor.

.DESCRIPTION
The Get-LMWebsiteGroupAlert function retrieves alert information for a specified website group in LogicMonitor. The group can be identified by either ID or name.

.PARAMETER Id
The ID of the website group to retrieve alerts from. Required for Id parameter set.

.PARAMETER Name
The name of the website group to retrieve alerts from. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving alerts.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve alerts by group ID
Get-LMWebsiteGroupAlert -Id 123

.EXAMPLE
#Retrieve alerts for a specific group
Get-LMWebsiteGroupAlert -Name "Production-Websites"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns website group alert objects.
#>

function Get-LMWebsiteGroupAlert {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        if ($Name) {
            $LookupResult = (Get-LMWebsiteGroup -Name $Name).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/website/groups/$Id/alerts"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests
        while (!$Done) {
            #Build query params
            $QueryParams = "?size=$BatchSize&offset=$Count&sort=-endDateTime"

            if ($Filter) {
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=-endDateTime"
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
