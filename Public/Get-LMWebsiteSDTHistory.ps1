<#
.SYNOPSIS
Retrieves historical Scheduled Down Time (SDT) entries for a website from LogicMonitor.

.DESCRIPTION
The Get-LMWebsiteSDTHistory function retrieves historical SDT entries for a specified website in LogicMonitor. The website can be identified by either ID or name.

.PARAMETER Id
The ID of the website to retrieve SDT history from. Required for Id parameter set.

.PARAMETER Name
The name of the website to retrieve SDT history from. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving SDT history.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve SDT history by website ID
Get-LMWebsiteSDTHistory -Id 123

.EXAMPLE
#Retrieve SDT history for a specific website
Get-LMWebsiteSDTHistory -Name "www.example.com"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns historical website SDT objects.
#>

function Get-LMWebsiteSDTHistory {

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
            $LookupResult = (Get-LMWebsite -Name $Name).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/website/websites/$Id/historysdts"

        $SingleObjectWhenNotPaged = $false

        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = "?size=$PageSize&offset=$Offset&sort=-endDateTime"

            if ($Filter) {
                $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=-endDateTime"
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            #If the API call failed (for example, resource not found), stop processing.
            if ($null -eq $Response) {
                return
            }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        return $Results
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
