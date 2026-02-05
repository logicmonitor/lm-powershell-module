<#
.SYNOPSIS
Retrieves external API statistics from LogicMonitor.

.DESCRIPTION
The Get-LMExternalAPIStats function retrieves external API usage statistics from LogicMonitor.
This provides information about API call volumes and usage patterns for external API access.

.EXAMPLE
Get-LMExternalAPIStats

Retrieves all external API statistics for the account.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.ExternalAPIStats object.
#>
function Get-LMExternalAPIStats {
    [CmdletBinding()]
    param ()

    if ($Script:LMAuth.Valid) {
        $ResourcePath = "/apiStats/externalApis"

        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

        $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

        return (Add-ObjectTypeInfo -InputObject $Response.items -TypeName "LogicMonitor.ExternalAPIStats")
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
