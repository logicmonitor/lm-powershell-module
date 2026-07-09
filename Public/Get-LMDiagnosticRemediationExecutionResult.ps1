<#
.SYNOPSIS
Retrieves diagnostic and remediation execution results from LogicMonitor.

.DESCRIPTION
The Get-LMDiagnosticRemediationExecutionResult function retrieves execution history for
diagnostic and remediation modules. All matching results are returned automatically.

.PARAMETER AlertId
The alert ID to filter execution results.

.PARAMETER HostId
The host (device) ID to filter execution results.

.PARAMETER ModuleType
Filter by module type.

.PARAMETER DiagnosticSourceId
The diagnostic source ID to filter results.

.PARAMETER DiagnosticSourceName
The diagnostic source name to filter results. Resolved to an ID via Get-LMDiagnosticSource.

.PARAMETER RemediationSourceId
The remediation source ID to filter results.

.PARAMETER RemediationSourceName
The remediation source name to filter results. Resolved to an ID via Get-LMRemediationSource.

.PARAMETER StartTime
Start of the time range to query.

.PARAMETER EndTime
End of the time range to query.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
Get-LMDiagnosticRemediationExecutionResult -HostId 123 -DiagnosticSourceName "Disk Check"

.EXAMPLE
Get-LMDiagnosticRemediationExecutionResult -AlertId "DS12345"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DiagnosticRemediationExecutionResult objects.
#>
function Get-LMDiagnosticRemediationExecutionResult {
    [CmdletBinding(DefaultParameterSetName = 'Host')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Alert')]
        [String]$AlertId,

        [Parameter(Mandatory, ParameterSetName = 'Host')]
        [Int]$HostId,

        [String]$ModuleType,

        [Int]$DiagnosticSourceId,

        [String]$DiagnosticSourceName,

        [Int]$RemediationSourceId,

        [String]$RemediationSourceName,

        [DateTime]$StartTime,

        [DateTime]$EndTime,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        return
    }

    if ($DiagnosticSourceName) {
        $LookupResult = (Get-LMDiagnosticSource -Name $DiagnosticSourceName).Id
        if (Test-LookupResult -Result $LookupResult -LookupString $DiagnosticSourceName) { return }
        $DiagnosticSourceId = $LookupResult
    }

    if ($RemediationSourceName) {
        $LookupResult = (Get-LMRemediationSource -Name $RemediationSourceName).Id
        if (Test-LookupResult -Result $LookupResult -LookupString $RemediationSourceName) { return }
        $RemediationSourceId = $LookupResult
    }

    $ResourcePath = "/setting/diagnosticRemediation/executionResults"
    $CommandInvocation = $MyInvocation
    $CallerPSCmdlet = $PSCmdlet

    $QueryParams = @("perPageCount=$BatchSize")

    if ($AlertId) { $QueryParams += "alertId=$AlertId" }
    if ($PSBoundParameters.ContainsKey('HostId')) { $QueryParams += "hostId=$HostId" }
    if ($ModuleType) { $QueryParams += "moduleType=$ModuleType" }
    if ($PSBoundParameters.ContainsKey('DiagnosticSourceId')) { $QueryParams += "diagnosticSourceId=$DiagnosticSourceId" }
    if ($DiagnosticSourceName) { $QueryParams += "diagnosticSourceName=$DiagnosticSourceName" }
    if ($PSBoundParameters.ContainsKey('RemediationSourceId')) { $QueryParams += "remediationSourceId=$RemediationSourceId" }
    if ($RemediationSourceName) { $QueryParams += "remediationSourceName=$RemediationSourceName" }
    if ($StartTime) { $QueryParams += "startTimeMs=$(( [DateTimeOffset]$StartTime.ToUniversalTime() ).ToUnixTimeMilliseconds())" }
    if ($EndTime) { $QueryParams += "endTimeMs=$(( [DateTimeOffset]$EndTime.ToUniversalTime() ).ToUnixTimeMilliseconds())" }

    $AllResults = [System.Collections.Generic.List[object]]::new()
    $NextCursor = $null
    $NextRemediationCursor = $null
    $HasMore = $true

    while ($HasMore) {
        $PageQueryParams = @($QueryParams)
        if ($NextCursor) { $PageQueryParams += "cursor=$NextCursor" }
        if ($NextRemediationCursor) { $PageQueryParams += "remediationCursor=$NextRemediationCursor" }

        $QueryString = '?' + ($PageQueryParams -join '&')
        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryString

        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

        $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
        if ($null -eq $Response) { break }

        if ($Response.items) {
            foreach ($item in @($Response.items)) {
                $AllResults.Add($item)
            }
        }

        $NextCursor = $Response.cursor
        $NextRemediationCursor = $Response.remediationCursor

        $HasMore = (-not [string]::IsNullOrWhiteSpace([string]$NextCursor)) -or
            (-not [string]::IsNullOrWhiteSpace([string]$NextRemediationCursor))

        if (-not $Response.items -or @($Response.items).Count -eq 0) {
            if ([string]::IsNullOrWhiteSpace([string]$NextCursor) -and [string]::IsNullOrWhiteSpace([string]$NextRemediationCursor)) {
                break
            }
        }
    }

    if ($AllResults.Count -eq 0) { return }
    return (Add-ObjectTypeInfo -InputObject $AllResults -TypeName "LogicMonitor.DiagnosticRemediationExecutionResult")
}
