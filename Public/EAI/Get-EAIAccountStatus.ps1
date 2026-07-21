<#
.SYNOPSIS
Retrieves the current Edwin account connection status.

.DESCRIPTION
Get-EAIAccountStatus returns connection details for the active Edwin session established by Connect-EAIAccount.

.EXAMPLE
Get-EAIAccountStatus

.NOTES
Use Connect-EAIAccount to establish an Edwin session before running event ingestion commands.
Requires sdt_read scope for SDT cmdlets.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a PSCustomObject with EdwinOrg, PortalUrl, Valid, Type, ClientId, TokenExpiresAt, and Logging; otherwise a string when not connected.
#>
function Get-EAIAccountStatus {
    if ($Script:EAIAuth) {
        return [PSCustomObject]@{
            EdwinOrg       = $Script:EAIAuth.EdwinOrg
            PortalUrl      = $Script:EAIAuth.PortalUrl
            Valid          = $Script:EAIAuth.Valid
            Type           = $Script:EAIAuth.Type
            ClientId       = $Script:EAIAuth.ClientId
            TokenExpiresAt = $Script:EAIAuth.TokenExpiresAt
            Logging        = $Script:EAIAuth.Logging
        }
    }

    return 'Not currently connected to any Edwin portals.'
}
