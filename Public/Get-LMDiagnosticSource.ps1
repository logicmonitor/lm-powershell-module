<#
.SYNOPSIS
Retrieves diagnostic sources from LogicMonitor.

.DESCRIPTION
The Get-LMDiagnosticSource function retrieves diagnostic source information from LogicMonitor. It can return diagnostic sources by ID, name, or using filters.

.PARAMETER Id
The ID of the diagnostic source to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Name
The name of the diagnostic source to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER DisplayName
The display name of the diagnostic source to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving diagnostic sources. Part of a mutually exclusive parameter set.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
# Retrieve a diagnostic source by ID
Get-LMDiagnosticSource -Id 123

.EXAMPLE
# Retrieve a diagnostic source by name
Get-LMDiagnosticSource -Name "Test_DiagnosticSource"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DiagnosticSource objects.
#>
function Get-LMDiagnosticSource {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'DisplayName')]
        [String]$DisplayName,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        $ResourcePath = "/setting/diagnosticsources"

        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        while (!$Done) {
            switch ($PSCmdlet.ParameterSetName) {
                "All" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id" }
                "Id" { $resourcePath += "/$Id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+id" }
                "DisplayName" { $QueryParams = "?filter=displayName:`"$DisplayName`"&size=$BatchSize&offset=$Count&sort=+id" }
                "Filter" {
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                }
            }
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath

            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            if ($PSCmdlet.ParameterSetName -eq "Id") {
                $Done = $true
                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DiagnosticSource")
            }
            else {
                [Int]$Total = $Response.Total
                [Int]$Count += ($Response.Items | Measure-Object).Count
                $Results += $Response.Items
                if ($Count -ge $Total) { $Done = $true }
            }

        }
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DiagnosticSource")
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}