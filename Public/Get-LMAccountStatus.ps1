<#
.SYNOPSIS
Retrieves the current LogicMonitor account connection status.

.DESCRIPTION
The Get-LMAccountStatus function retrieves the current connection status of the LogicMonitor account, including portal information, authentication validity, logging status, and authentication type.

.EXAMPLE
#Get the current account status
Get-LMAccountStatus

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a PSCustomObject with the following properties: Portal, Valid, Logging, and Type
#>

function Get-LMAccountStatus {
    #Clear credential object from environment
    if ($Script:LMAuth) {
        $Result = [PSCustomObject]@{
            Portal   = $Script:LMAuth.Portal
            Valid    = $Script:LMAuth.Valid
            Logging  = $Script:LMAuth.Logging
            Type     = $Script:LMAuth.Type
            GovCloud = $Script:LMAuth.GovCloud
        }
        return $Result
    }
    else {
        return "Not currently logged into any LogicMonitor portals."
    }
}
