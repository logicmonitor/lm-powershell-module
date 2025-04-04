<#
.SYNOPSIS
Disconnects from a previously connected LM portal.

.DESCRIPTION
The Disconnect-LMAccount function clears stored API credentials for a previously connected LM portal. It's useful for switching between LM portals or clearing credentials after a script runs.

.EXAMPLE
#Disconnect from the current LM portal
Disconnect-LMAccount

.NOTES
Once disconnected you will need to reconnect to a portal before you will be allowed to run commands again.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
None. This command does not generate any output.


#>
Function Disconnect-LMAccount {
    #Clear credential object from environment
    If ($Script:LMAuth) {
        Write-Information "[INFO]: Successfully cleared login credentials for LM account." 
        Remove-Variable -Name LMAuth -Scope Script -ErrorAction SilentlyContinue
        Remove-Variable -Name LMUserData -Scope Global -ErrorAction SilentlyContinue
        Remove-Variable -Name LMDeltaId -Scope Global -ErrorAction SilentlyContinue
    }
    Else {
        Write-Information "[INFO]: Not currently connected to any LM account." 
    }

    #Reset information preference
    $InformationPreference = 'SilentlyContinue'
}
