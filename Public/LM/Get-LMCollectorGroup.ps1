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

        $ResourcePath = "/setting/collector/groups"
        $ParameterSetName = $PSCmdlet.ParameterSetName
        $CommandInvocation = $MyInvocation
        $SingleObjectWhenNotPaged = $ParameterSetName -eq "Id"

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

            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return $null }
            return $Response
        }

        if ($null -eq $Results) { return }
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.CollectorGroup" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
