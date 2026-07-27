<#
.SYNOPSIS
Retrieves assigned diagnostic and remediation modules from LogicMonitor.

.DESCRIPTION
The Get-LMDiagnosticRemediationModule function lists diagnostic and remediation exchange
modules assigned to a resource or alert.

.PARAMETER ResourceId
The resource (device) ID to list assigned modules for.

.PARAMETER AlertId
The alert ID to list assigned modules for.

.PARAMETER ModuleType
Filter by module type. Valid values: diagnostic, remediation.

.EXAMPLE
Get-LMDiagnosticRemediationModule -AlertId "DS12345"

.EXAMPLE
Get-LMDiagnosticRemediationModule -ResourceId 123 -ModuleType remediation

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DiagnosticRemediationModule objects.
#>
function Get-LMDiagnosticRemediationModule {
    [CmdletBinding()]
    param (
        [Int]$ResourceId,

        [String]$AlertId,

        [ValidateSet('diagnostic', 'remediation')]
        [String]$ModuleType
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        return
    }

    $ResourcePath = "/setting/diagnosticRemediation/list"
    $QueryParams = @()

    if ($PSBoundParameters.ContainsKey('ResourceId')) {
        $QueryParams += "resourceId=$ResourceId"
    }
    if ($AlertId) {
        $QueryParams += "alertId=$AlertId"
    }
    if ($ModuleType) {
        $QueryParams += "moduleType=$ModuleType"
    }

    $QueryString = if ($QueryParams.Count -gt 0) { '?' + ($QueryParams -join '&') } else { '' }

    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryString

    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
    if ($null -eq $Response) { return }

    if ($Response.PSObject.Properties.Name -contains 'items') {
        $Results = $Response.items
    }
    elseif ($Response -is [System.Array]) {
        $Results = $Response
    }
    else {
        $Results = $Response
    }

    return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DiagnosticRemediationModule")
}
