<#
.SYNOPSIS
    Gets the LogicMonitor portal URI based on whether the account is using GovCloud or standard portal.

.DESCRIPTION
    The Get-LMPortalURI function determines the appropriate LogicMonitor portal URI based on the account configuration.
    It checks if the account is using GovCloud and returns the appropriate domain suffix.

.PARAMETER None
    This function does not accept any parameters.

.EXAMPLE
    $portalUri = Get-LMPortalURI
    Returns "lmgov.us" for GovCloud accounts or "logicmonitor.com" for standard accounts.

.OUTPUTS
    Returns a string containing the appropriate portal URI suffix.
#>

Function Get-LMPortalURI {
    #Check LMAuth for GovCloud
    If ($Script:LMAuth.GovCloud) {
        Return "lmgov.us/santaba/rest"
    }
    Else {
        Return "logicmonitor.com/santaba/rest"
    }
}