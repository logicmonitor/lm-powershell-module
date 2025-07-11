<#
.SYNOPSIS
Retrieves collector groups from LogicMonitor.

.DESCRIPTION
The Get-LMCollectorGroup function retrieves collector groups from LogicMonitor based on the specified parameters. It supports retrieving collector groups by ID, name, or using a filter. The function uses the LogicMonitor REST API to make the requests.

.PARAMETER Id
Specifies the ID of the collector group to retrieve. This parameter is mutually exclusive with the Name and Filter parameters.

.PARAMETER Name
Specifies the name of the collector group to retrieve. This parameter is mutually exclusive with the Id and Filter parameters.

.PARAMETER Filter
Specifies a filter object to retrieve collector groups based on specific criteria. This parameter is mutually exclusive with the Id and Name parameters.

.PARAMETER FilterWizard
Specifies the use of the FilterWizard to assist in building a valid filter. This parameter is mutually exclusive with the Id, Name, and Filter parameters.

.PARAMETER BatchSize
Specifies the number of collector groups to retrieve per request. The default value is 1000.

.EXAMPLE
Get-LMCollectorGroup -Id 123
Retrieves the collector group with the specified ID.

.EXAMPLE
Get-LMCollectorGroup -Name "Group 1"
Retrieves the collector group with the specified name.

.EXAMPLE
Get-LMCollectorGroup -Filter @{ Property = "Value" }
Retrieves collector groups based on the specified filter criteria.

#>
function Get-LMCollectorGroup {

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
        $ResourcePath = "/setting/collector/groups"

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
                "FilterWizard" {
                    $PropList = @()
                    $Filter = Build-LMFilter -PassThru
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
                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.CollectorGroup" )
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
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.CollectorGroup" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
