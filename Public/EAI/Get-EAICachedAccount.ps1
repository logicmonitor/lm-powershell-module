<#
.SYNOPSIS
Retrieves cached Edwin account credentials.

.DESCRIPTION
Get-EAICachedAccount returns metadata for Edwin credentials stored in the Logic.Monitor secret vault.

.PARAMETER CachedAccountName
The cached Edwin account name to retrieve. If omitted, all Edwin cached accounts are returned.

.EXAMPLE
Get-EAICachedAccount

.EXAMPLE
Get-EAICachedAccount -CachedAccountName "EAI:myorg"

.NOTES
This function requires access to the Logic.Monitor vault where credentials are stored.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns PSCustomObject entries with CachedAccountName, EdwinOrg, ClientId, Modified, and Type.

.LINK
Get-SecretInfo
#>
function Get-EAICachedAccount {
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
        if ($secret.Metadata['Type'] -ne 'EAI') {
            continue
        }

        $cachedAccounts += [PSCustomObject]@{
            CachedAccountName = $secret.Name
            EdwinOrg          = $secret.Metadata['Portal']
            ClientId          = if ($secret.Metadata['Id']) { $secret.Metadata['Id'] } else { 'N/A' }
            Modified          = $secret.Metadata['Modified']
            Type              = $secret.Metadata['Type']
        }
    }

    return $cachedAccounts
}
