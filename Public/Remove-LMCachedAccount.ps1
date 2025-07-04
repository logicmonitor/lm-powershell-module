<#
.SYNOPSIS
Removes cached account information from the Logic.Monitor vault.

.DESCRIPTION
The Remove-LMCachedAccount function is used to remove cached account information from the Logic.Monitor vault. It provides two parameter sets: 'Single' and 'All'. When using the 'Single' parameter set, you can specify a single cached account to remove. When using the 'All' parameter set, all cached accounts will be removed.

.PARAMETER CachedAccountName
Specifies the name of the cached account to remove. This parameter is used with the 'Single' parameter set.

.PARAMETER RemoveAllEntries
Indicates that all cached accounts should be removed. This parameter is used with the 'All' parameter set.

.EXAMPLE
Remove-LMCachedAccount -CachedAccountName "JohnDoe"
Removes the cached account with the name "JohnDoe" from the Logic.Monitor vault.

.EXAMPLE
Remove-LMCachedAccount -RemoveAllEntries
Removes all cached accounts from the Logic.Monitor vault.

.NOTES
This function operates on the local credential vault and does not require API authentication.

.INPUTS
You can pipe objects to this function.

.OUTPUTS
This function does not generate any output.
#>

function Remove-LMCachedAccount {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single', ValueFromPipelineByPropertyName)]
        [Alias("Portal")]
        [String]$CachedAccountName,

        [Parameter(ParameterSetName = 'All')]
        [Switch]$RemoveAllEntries
    )
    begin {}
    process {
        $RequiredKeys = @('Modified', 'Portal', 'Type', 'Id')
        if ($RemoveAllEntries) {
            $CachedAccounts = Get-SecretInfo -Vault Logic.Monitor
            if ($PSCmdlet.ShouldProcess("$((($CachedAccounts | Measure-Object).Count)) cached account(s)", "Remove All Cached Accounts")) {
                foreach ($Account in $CachedAccounts.Name) {
                    $SecretInfo = Get-SecretInfo -Vault Logic.Monitor -Name $Account
                    $Metadata = $SecretInfo.Metadata
                    $MissingKeys = $RequiredKeys | Where-Object { -not $Metadata.ContainsKey($_) }
                    if ($MissingKeys.Count -eq 0) {
                        try {
                            Remove-Secret -Name $Account -Vault Logic.Monitor -Confirm:$false -ErrorAction Stop
                            Write-Information "[INFO]: Removed cached account secret for: $Account"
                        }
                        catch {
                            Write-Error $_.Exception.Message
                        }
                    }
                    else {
                        Write-Information "[INFO]: Skipped account $Account - missing required metadata keys: $($MissingKeys -join ', ')"
                    }
                }
                Write-Information "[INFO]: Processed all entries from credential cache"
            }
        }
        else {
            if ($PSCmdlet.ShouldProcess($CachedAccountName, "Remove Cached Account")) {
                $SecretInfo = Get-SecretInfo -Vault Logic.Monitor -Name $CachedAccountName
                $Metadata = $SecretInfo.Metadata
                $MissingKeys = $RequiredKeys | Where-Object { -not $Metadata.ContainsKey($_) }
                if ($MissingKeys.Count -eq 0) {
                    try {
                        Remove-Secret -Name $CachedAccountName -Vault Logic.Monitor -Confirm:$false -ErrorAction Stop
                        Write-Information "[INFO]: Removed cached account secret for: $CachedAccountName"
                    }
                    catch {
                        Write-Error $_.Exception.Message
                    }
                }
                else {
                    Write-Information "[INFO]: Skipped account $CachedAccountName - missing required metadata keys: $($MissingKeys -join ', ')"
                }
            }
        }
    }
    end {}
}