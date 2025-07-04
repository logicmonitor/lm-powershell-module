<#
.SYNOPSIS
Retrieves information about cached LogicMonitor account credentials.

.DESCRIPTION
The Get-LMCachedAccount function retrieves information about cached LogicMonitor account credentials stored in the Logic.Monitor vault. It can return information for a specific cached account or all cached accounts.

.PARAMETER CachedAccountName
The name of the specific cached account to retrieve information for. If not specified, returns information for all cached accounts.

.EXAMPLE
#Retrieve all cached accounts
Get-LMCachedAccount

.EXAMPLE
#Retrieve a specific cached account
Get-LMCachedAccount -CachedAccountName "MyAccount"

.NOTES
This function requires access to the Logic.Monitor vault where credentials are stored.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns an array of custom objects containing cached account information including CachedAccountName, Portal, Id, Modified date, and Type.

.LINK
Get-SecretInfo

#>

function Get-LMCachedAccount {
    [CmdletBinding()]
    param (
        [String]$CachedAccountName
    )
    if ($CachedAccountName) {
        $CachedAccountSecrets = Get-SecretInfo -Vault Logic.Monitor -Name $CachedAccountName
    }
    else {
        $CachedAccountSecrets = Get-SecretInfo -Vault Logic.Monitor
    }
    $CachedAccounts = @()
    foreach ($Secret in $CachedAccountSecrets) {
        $CachedAccounts += [PSCustomObject]@{
            CachedAccountName = $Secret.Name
            Portal            = $Secret.Metadata["Portal"]
            Id                = if (!$Secret.Metadata["Id"]) { "N/A" }else { $Secret.Metadata["Id"] }
            Modified          = $Secret.Metadata["Modified"]
            Type              = if (!$Secret.Metadata["Type"]) { "LMv1" }else { $Secret.Metadata["Type"] }
        }
    }
    return $CachedAccounts

}