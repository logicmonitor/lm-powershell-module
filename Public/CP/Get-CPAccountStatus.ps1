<#
.SYNOPSIS
Retrieves the current Catchpoint account connection status.

.DESCRIPTION
Get-CPAccountStatus returns connection details for the active Catchpoint session established by Connect-CPAccount.

.EXAMPLE
Get-CPAccountStatus

.NOTES
Use Connect-CPAccount to establish a Catchpoint session before running Catchpoint commands.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a PSCustomObject with AccountName, PortalUrl, Valid, Type, and Logging; otherwise a string when not connected.
#>
function Get-CPAccountStatus {
    if ($Script:CPAuth) {
        return [PSCustomObject]@{
            AccountName = $Script:CPAuth.AccountName
            PortalUrl   = $Script:CPAuth.PortalUrl
            Valid       = $Script:CPAuth.Valid
            Type        = $Script:CPAuth.Type
            Logging     = $Script:CPAuth.Logging
        }
    }

    return 'Not currently connected to any Catchpoint account.'
}
