<#
.SYNOPSIS
Removes cached Edwin account credentials.

.DESCRIPTION
Remove-EAICachedAccount removes Edwin cached credentials from the Logic.Monitor secret vault.

.PARAMETER CachedAccountName
The cached Edwin account name to remove.

.PARAMETER RemoveAllEntries
Remove all cached Edwin accounts from the vault.

.EXAMPLE
Remove-EAICachedAccount -CachedAccountName "EAI:myorg"

.EXAMPLE
Remove-EAICachedAccount -RemoveAllEntries

.NOTES
Use Connect-EAIAccount with -UseCachedCredential to consume cached Edwin credentials.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
None.
#>
function Remove-EAICachedAccount {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Single', ValueFromPipelineByPropertyName)]
        [Alias('EdwinOrg')]
        [String]$CachedAccountName,

        [Parameter(ParameterSetName = 'All')]
        [Switch]$RemoveAllEntries
    )

    begin {}
    process {
        $requiredKeys = @('Modified', 'Portal', 'Type', 'Id')

        if ($RemoveAllEntries) {
            $cachedAccounts = @(Get-EAICachedAccount)
            if ($PSCmdlet.ShouldProcess("$($cachedAccounts.Count) cached Edwin account(s)", 'Remove All Cached Edwin Accounts')) {
                foreach ($account in $cachedAccounts) {
                    $secretInfo = Get-SecretInfo -Vault Logic.Monitor -Name $account.CachedAccountName
                    if (-not $secretInfo -or $secretInfo.Metadata['Type'] -ne 'EAI') {
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
                        Write-Information "[INFO]: Removed cached Edwin account secret for: $($account.CachedAccountName)"
                    }
                    catch {
                        Write-Error $_.Exception.Message
                    }
                }

                Write-Information '[INFO]: Processed all Edwin entries from credential cache'
            }

            return
        }

        if ($PSCmdlet.ShouldProcess($CachedAccountName, 'Remove Cached Edwin Account')) {
            $secretInfo = Get-SecretInfo -Vault Logic.Monitor -Name $CachedAccountName
            if (-not $secretInfo -or $secretInfo.Metadata['Type'] -ne 'EAI') {
                Write-Error "Cached Edwin account '$CachedAccountName' was not found."
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
                Write-Information "[INFO]: Removed cached Edwin account secret for: $CachedAccountName"
            }
            catch {
                Write-Error $_.Exception.Message
            }
        }
    }
    end {}
}
