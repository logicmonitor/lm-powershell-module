<#
.SYNOPSIS
Removes cached Catchpoint account credentials.

.DESCRIPTION
Remove-CPCachedAccount removes Catchpoint cached credentials from the Logic.Monitor secret vault.

.PARAMETER CachedAccountName
The cached Catchpoint account name to remove.

.PARAMETER RemoveAllEntries
Remove all cached Catchpoint accounts from the vault.

.EXAMPLE
Remove-CPCachedAccount -CachedAccountName "CP:prod"

.EXAMPLE
Remove-CPCachedAccount -RemoveAllEntries

.NOTES
Use Connect-CPAccount with -UseCachedCredential to consume cached Catchpoint credentials.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
None.
#>
function Remove-CPCachedAccount {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Single', ValueFromPipelineByPropertyName)]
        [Alias('AccountName')]
        [String]$CachedAccountName,

        [Parameter(ParameterSetName = 'All')]
        [Switch]$RemoveAllEntries
    )

    begin {}
    process {
        $requiredKeys = @('Modified', 'Portal', 'Type')

        if ($RemoveAllEntries) {
            $cachedAccounts = @(Get-CPCachedAccount)
            if ($PSCmdlet.ShouldProcess("$($cachedAccounts.Count) cached Catchpoint account(s)", 'Remove All Cached Catchpoint Accounts')) {
                foreach ($account in $cachedAccounts) {
                    $secretInfo = Get-SecretInfo -Vault Logic.Monitor -Name $account.CachedAccountName
                    if (-not $secretInfo -or $secretInfo.Metadata['Type'] -ne 'CP') {
                        continue
                    }

                    $metadata = $secretInfo.Metadata
                    $missingKeys = $requiredKeys | Where-Object { -not $metadata.ContainsKey($_) }
                    if ($missingKeys.Count -gt 0) {
                        Write-Information "[INFO]: Skipped account $($account.CachedAccountName) - missing required metadata keys: $($missingKeys -join ', ')"
                        continue
                    }

                    try {
                        Remove-Secret -Name $account.CachedAccountName -Vault Logic.Monitor -Confirm:$false -ErrorAction Stop
                        Write-Information "[INFO]: Removed cached Catchpoint account secret for: $($account.CachedAccountName)"
                    }
                    catch {
                        Write-Error $_.Exception.Message
                    }
                }

                Write-Information '[INFO]: Processed all Catchpoint entries from credential cache'
            }

            return
        }

        if ($PSCmdlet.ShouldProcess($CachedAccountName, 'Remove Cached Catchpoint Account')) {
            $secretInfo = Get-SecretInfo -Vault Logic.Monitor -Name $CachedAccountName
            if (-not $secretInfo -or $secretInfo.Metadata['Type'] -ne 'CP') {
                Write-Error "Cached Catchpoint account '$CachedAccountName' was not found."
                return
            }

            $metadata = $secretInfo.Metadata
            $missingKeys = $requiredKeys | Where-Object { -not $metadata.ContainsKey($_) }
            if ($missingKeys.Count -gt 0) {
                Write-Information "[INFO]: Skipped account $CachedAccountName - missing required metadata keys: $($missingKeys -join ', ')"
                return
            }

            try {
                Remove-Secret -Name $CachedAccountName -Vault Logic.Monitor -Confirm:$false -ErrorAction Stop
                Write-Information "[INFO]: Removed cached Catchpoint account secret for: $CachedAccountName"
            }
            catch {
                Write-Error $_.Exception.Message
            }
        }
    }
    end {}
}
