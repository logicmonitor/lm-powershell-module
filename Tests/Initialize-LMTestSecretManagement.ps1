function Initialize-LMTestSecretManagement {
    <#
    .SYNOPSIS
        Creates a passwordless Logic.Monitor secret vault for cached-account integration tests.
    #>
    [CmdletBinding(SupportsShouldProcess = $false)]
    param()

    if ($script:LMTestSecretManagementInitialized) {
        return
    }

    if (-not (Get-Module -ListAvailable -Name Microsoft.PowerShell.SecretManagement)) {
        return
    }

    Import-Module Microsoft.PowerShell.SecretManagement -ErrorAction Stop
    Import-Module Microsoft.PowerShell.SecretStore -ErrorAction Stop

    $previousConfirmPreference = $ConfirmPreference
    $ConfirmPreference = 'None'

    try {
        $vaultExists = $false
        try {
            Get-SecretVault -Name Logic.Monitor -ErrorAction Stop | Out-Null
            $vaultExists = $true
        }
        catch {
            if ($_.Exception.Message -notlike '*Vault Logic.Monitor does not exist in registry*') {
                throw
            }
        }

        if (-not $vaultExists) {
            $testVaultPath = Join-Path ([System.IO.Path]::GetTempPath()) 'Logic.Monitor.TestSecretStore'
            if (-not (Test-Path -LiteralPath $testVaultPath)) {
                $null = New-Item -ItemType Directory -Path $testVaultPath -Force
            }

            Register-SecretVault -Name Logic.Monitor -ModuleName Microsoft.PowerShell.SecretStore -VaultParameters @{
                Path = $testVaultPath
            } -ErrorAction Stop
        }

        $storeConfig = Get-SecretStoreConfiguration -ErrorAction SilentlyContinue
        if ($null -eq $storeConfig -or [string]$storeConfig.Authentication -ne 'None') {
            $storeConfigParams = @{
                Authentication = 'None'
                Scope          = 'CurrentUser'
                Confirm        = $false
            }
            if ((Get-Command Set-SecretStoreConfiguration).Parameters.ContainsKey('Interaction')) {
                $storeConfigParams.Interaction = 'None'
            }

            try {
                Set-SecretStoreConfiguration @storeConfigParams -ErrorAction Stop
            }
            catch {
                Write-Warning "Unable to configure passwordless SecretStore for tests: $($_.Exception.Message)"
            }
        }
    }
    finally {
        $ConfirmPreference = $previousConfirmPreference
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
