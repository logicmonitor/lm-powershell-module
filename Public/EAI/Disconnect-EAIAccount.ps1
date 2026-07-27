<#
.SYNOPSIS
Disconnect from a previously connected Edwin account.

.DESCRIPTION
Disconnect-EAIAccount clears stored Edwin API credentials from the current PowerShell session.

.EXAMPLE
Disconnect-EAIAccount

.NOTES
Once disconnected you will need to reconnect to Edwin before running event ingestion commands again.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
None.
#>
function Disconnect-EAIAccount {
    if ($Script:EAIAuth) {
        Write-Information '[INFO]: Successfully cleared login credentials for Edwin account.'
        Remove-Variable -Name EAIAuth -Scope Script -ErrorAction SilentlyContinue
    }
    else {
        Write-Information '[INFO]: Not currently connected to any Edwin account.'
    }

    $InformationPreference = 'SilentlyContinue'
}
