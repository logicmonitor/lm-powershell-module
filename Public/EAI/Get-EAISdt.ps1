<#
.SYNOPSIS
Retrieves scheduled downtime entries from Edwin.

.DESCRIPTION
Get-EAISdt lists all scheduled downtime (SDT) entries for the connected Edwin organisation.
This endpoint does not support pagination or batching.

.EXAMPLE
Get-EAISdt

.NOTES
Use Connect-EAIAccount to establish an Edwin session before running this command.
Requires ADMIN role or sdt_read API scope on the Edwin credentials.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns Edwin.SDT objects.
#>
function Get-EAISdt {
    [CmdletBinding()]
    param ()

    if (-not (Test-EAIAuth -CallerPSCmdlet $PSCmdlet)) {
        return
    }

    $headers = New-EAIHeader -Auth $Script:EAIAuth -Method 'GET'
    $uri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath '/action/sdt'
    $enableDebugLogging = $DebugPreference -ne 'SilentlyContinue'

    Resolve-EAIDebugInfo -Url $uri -Headers $headers -Command $MyInvocation

    $response = Invoke-EAIRestMethod -Uri $uri -Method GET -Headers $headers -Auth $Script:EAIAuth `
        -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging

    $schedules = if ($null -eq $response) {
        @()
    }
    else {
        @($response)
    }

    if ($schedules.Count -eq 0) {
        Write-Output @() -NoEnumerate
        return
    }

    return Add-ObjectTypeInfo -InputObject $schedules -TypeName 'Edwin.SDT'
}
