<#
.SYNOPSIS
Retrieves cached Catchpoint account credentials.

.DESCRIPTION
Get-CPCachedAccount returns metadata for Catchpoint credentials stored in the Logic.Monitor secret vault.

.PARAMETER CachedAccountName
The cached Catchpoint account name to retrieve. If omitted, all Catchpoint cached accounts are returned.

.EXAMPLE
Get-CPCachedAccount

.EXAMPLE
Get-CPCachedAccount -CachedAccountName "CP:prod"

.NOTES
This function requires access to the Logic.Monitor vault where credentials are stored.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns PSCustomObject entries with CachedAccountName, AccountName, PortalUrl, Modified, and Type.

.LINK
Get-SecretInfo
#>
function Get-CPCachedAccount {
    [CmdletBinding()]
    param(
        [String]$CachedAccountName
    )

    if ($CachedAccountName) {
        $secrets = @(Get-SecretInfo -Vault Logic.Monitor -Name $CachedAccountName)
    }
    else {
        $secrets = @(Get-SecretInfo -Vault Logic.Monitor)
    }

    $cachedAccounts = @()
    foreach ($secret in $secrets) {
        if ($secret.Metadata['Type'] -ne 'CP') {
            continue
        }

        $cachedAccounts += [PSCustomObject]@{
            CachedAccountName = $secret.Name
            AccountName       = $secret.Metadata['Portal']
            PortalUrl         = $secret.Metadata['PortalUrl']
            Modified          = $secret.Metadata['Modified']
            Type              = $secret.Metadata['Type']
        }
    }

    return $cachedAccounts
}
