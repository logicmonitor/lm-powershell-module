<#
.SYNOPSIS
Disconnect from a previously connected LM portal

.DESCRIPTION
Clears stored API credentials for a previously connected LM portal. Useful for switching between LM portals or clearing credentials after a script runs

.EXAMPLE
Disconnect-LMAccount

.NOTES
Once disconnect you will need to reconnect to a portal before you will be allowed to run commands again.

.INPUTS
None. You cannot pipe objects to this command.

.LINK
Module repo: https://github.com/logicmonitor/lm-powershell-module

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor
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
