function Initialize-LMTestSecretManagement {
    <#
    .SYNOPSIS
        Creates a passwordless Logic.Monitor secret vault for integration tests.
    #>
    [CmdletBinding()]
    param()

    if ($script:LMTestSecretManagementInitialized) {
        return
    }

    if (-not (Get-Module -ListAvailable -Name Microsoft.PowerShell.SecretManagement)) {
        return
    }

    Import-Module Microsoft.PowerShell.SecretManagement -ErrorAction Stop
    Import-Module Microsoft.PowerShell.SecretStore -ErrorAction Stop

    try {
        Get-SecretVault -Name Logic.Monitor -ErrorAction Stop | Out-Null
    }
    catch {
        if ($_.Exception.Message -notlike '*Vault Logic.Monitor does not exist in registry*') {
            throw
        }

        $testVaultPath = Join-Path ([System.IO.Path]::GetTempPath()) 'Logic.Monitor.TestSecretStore'

        Register-SecretVault -Name Logic.Monitor -ModuleName Microsoft.PowerShell.SecretStore -VaultParameters @{
            Path = $testVaultPath
        }

        $storeConfigParams = @{
            Authentication = 'None'
            Scope          = 'CurrentUser'
        }
        if ((Get-Command Set-SecretStoreConfiguration).Parameters.ContainsKey('Interaction')) {
            $storeConfigParams.Interaction = 'None'
        }

        Set-SecretStoreConfiguration @storeConfigParams
    }

    $script:LMTestSecretManagementInitialized = $true
}

function Initialize-LMTestSecretManagementMocks {
    <#
    .SYNOPSIS
        Mocks secret vault registration so cached-account unit tests stay non-interactive.
    #>
    [CmdletBinding()]
    param()

    Mock Get-SecretVault { }
    Mock Register-SecretVault { }
    Mock Get-SecretStoreConfiguration {
        [PSCustomObject]@{
            Authentication = 'None'
            Interaction    = 'None'
        }
    }
    Mock Set-SecretStoreConfiguration { }
}
