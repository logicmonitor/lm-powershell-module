<#
.SYNOPSIS
Retrieves monitoring data for a specific website from LogicMonitor.

.DESCRIPTION
The Get-LMWebsiteData function retrieves monitoring data for a specified website and checkpoint in LogicMonitor. The website can be identified by either ID or name.

.PARAMETER Id
The ID of the website to retrieve data from. Required for Id parameter set.

.PARAMETER Name
The name of the website to retrieve data from. Required for Name parameter set.

.PARAMETER StartDate
The start date for retrieving website data. Defaults to 60 minutes ago if not specified.

.PARAMETER EndDate
The end date for retrieving website data. Defaults to current time if not specified.

.PARAMETER CheckpointId
The ID of the specific checkpoint to retrieve data from. Defaults to 0.

.EXAMPLE
#Retrieve website data by ID
Get-LMWebsiteData -Id 123

.EXAMPLE
#Retrieve website data with custom date range
Get-LMWebsiteData -Name "www.example.com" -StartDate (Get-Date).AddDays(-1)

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns website monitoring data objects.
#>

Function Get-LMWebsiteData {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Datetime]$StartDate,

        [Datetime]$EndDate,

        [String]$CheckpointId = 0
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        #If using id we still need to grab a checkpoint is not specified
        If ($Id) {
            $Website = Get-LMWebsite -Id $Id
            $CheckpointId = $Website.Checkpoints[0].id
        }

        #Lookup Id and checkpoint if supplying username
        If ($Name) {
            $LookupResult = Get-LMWebsite -Name $Name
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult.Id
            $Id = $LookupResult.Checkpoints[0].id
        }
        
        #Build header and uri
        $ResourcePath = "/website/websites/$Id/checkpoints/$CheckpointId/data"

        #Convert to epoch, if not set use defaults
        If (!$StartDate) {
            [int]$StartDate = ([DateTimeOffset]$(Get-Date).AddMinutes(-60)).ToUnixTimeSeconds()
        }
        Else {
            [int]$StartDate = ([DateTimeOffset]$($StartDate)).ToUnixTimeSeconds()
        }

        If (!$EndDate) {
            [int]$EndDate = ([DateTimeOffset]$(Get-Date)).ToUnixTimeSeconds()
        }
        Else {
            [int]$EndDate = ([DateTimeOffset]$($EndDate)).ToUnixTimeSeconds()
        }

        #Build query params
        $QueryParams = "?size=$BatchSize&start=$StartDate&end=$EndDate"

        Try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams
                
            
                
            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            Return $Response
        
        }
        Catch [Exception] {
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
