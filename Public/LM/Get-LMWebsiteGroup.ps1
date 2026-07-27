<#
.SYNOPSIS
Retrieves website group information from LogicMonitor.

.DESCRIPTION
The Get-LMWebsiteGroup function retrieves website group information from LogicMonitor based on specified parameters. It can return a single website group by ID or multiple groups based on name, filter, or filter wizard.

.PARAMETER Id
The ID of the website group to retrieve. This parameter is mandatory when using the Id parameter set.

.PARAMETER Name
The name of the website group to retrieve. This parameter is mandatory when using the Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving website groups. This parameter is mandatory when using the Filter parameter set.

.PARAMETER FilterWizard
A switch parameter to enable the filter wizard interface. This parameter is mandatory when using the FilterWizard parameter set.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Default is 1000.

.EXAMPLE
#Retrieve a website group by ID
Get-LMWebsiteGroup -Id 1234

.EXAMPLE
#Retrieve a website group by name
Get-LMWebsiteGroup -Name "Production"

.EXAMPLE
#Retrieve website groups using a filter
Get-LMWebsiteGroup -Filter $filterObject

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.WebsiteGroup objects.
#>

function Get-LMWebsiteGroup {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the FilterWizard to work')]

    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [Parameter(ParameterSetName = 'FilterWizard')]
        [Switch]$FilterWizard,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/website/groups"

        $ParameterSetName = $PSCmdlet.ParameterSetName
        $SingleObjectWhenNotPaged = $ParameterSetName -eq "Id"
        $CommandInvocation = $MyInvocation
        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = ""

            switch ($ParameterSetName) {
                "All" { $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id" }
                "Id" { $RequestResourcePath = "$ResourcePath/$Id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$PageSize&offset=$Offset&sort=+id" }
                "Filter" {
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                    $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
                }
                "FilterWizard" {
                    $Filter = Build-LMFilter -PassThru -ResourcePath $ResourcePath
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                    $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
                }
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.WebsiteGroup" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
