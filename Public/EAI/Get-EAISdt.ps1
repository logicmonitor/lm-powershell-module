<#
.SYNOPSIS
Retrieves scheduled downtime entries from Edwin.

.DESCRIPTION
Get-EAISdt lists all scheduled downtime (SDT) entries for the connected Edwin organisation,
or retrieves a single schedule when -Id is specified.

.PARAMETER Id
Schedule ID (UUID). When specified, retrieves a single schedule via GET /action/sdt/{id}.

.EXAMPLE
Get-EAISdt

.EXAMPLE
Get-EAISdt -Id '6d18821f-8f3c-48ca-8331-3e4c8d77cac3'

.NOTES
Use Connect-EAIAccount to establish an Edwin session before running this command.
Requires ADMIN role or sdt_read API scope on the Edwin credentials.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns Edwin.SDT objects.
#>
function Get-EAISdt {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ById')]
        [String]$Id
    )

    if (-not (Test-EAIAuth -CallerPSCmdlet $PSCmdlet)) {
        return
    }

    $headers = New-EAIHeader -Auth $Script:EAIAuth -Method 'GET'
    $resourcePath = if ($PSCmdlet.ParameterSetName -eq 'ById') {
        "/action/sdt/$Id"
    }
    else {
        '/action/sdt'
    }
    $uri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath $resourcePath
    $enableDebugLogging = $DebugPreference -ne 'SilentlyContinue'

    Resolve-EAIDebugInfo -Url $uri -Headers $headers -Command $MyInvocation

    $response = Invoke-EAIRestMethod -Uri $uri -Method GET -Headers $headers -Auth $Script:EAIAuth `
        -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging

    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        if ($null -eq $response) {
            return
        }

        return Add-ObjectTypeInfo -InputObject $response -TypeName 'Edwin.SDT'
    }

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
