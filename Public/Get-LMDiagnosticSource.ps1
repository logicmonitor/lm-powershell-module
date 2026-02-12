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
                "DisplayName" { $QueryParams = "?filter=displayName:`"$DisplayName`"&size=$PageSize&offset=$Offset&sort=+id" }
                "Filter" {
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
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DiagnosticSource")
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}