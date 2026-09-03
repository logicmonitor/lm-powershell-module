<#
.SYNOPSIS
Disconnect from a previously connected Catchpoint account.

.DESCRIPTION
Disconnect-CPAccount clears stored Catchpoint API credentials from the current PowerShell session.

.EXAMPLE
Disconnect-CPAccount

.NOTES
Once disconnected you will need to reconnect to Catchpoint before running Catchpoint commands again.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
None.
#>
function Disconnect-CPAccount {
    if ($Script:CPAuth) {
        Write-Information '[INFO]: Successfully cleared login credentials for Catchpoint account.'
        Remove-Variable -Name CPAuth -Scope Script -ErrorAction SilentlyContinue
    }
    else {
        Write-Information '[INFO]: Not currently connected to any Catchpoint account.'
    }

    $InformationPreference = 'SilentlyContinue'
}
