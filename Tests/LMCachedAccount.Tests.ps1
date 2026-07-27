Describe 'Connect-LMAccount cached GovCloud metadata' {
    BeforeAll {
        function Update-LogicMonitorModule { }
        function Get-LMPortalVersion { return $null }
        function New-MockCachedSecretInfo {
            param (
                [String]$Name,
                [String]$Portal,
                [String]$Id = 'test-access-id',
                [String]$Type = 'LMv1',
                [String]$GovCloud
            )

            $metadata = [ordered]@{
                Portal   = $Portal
                Id       = $Id
                Modified = Get-Date
                Type     = $Type
            }
            if ($PSBoundParameters.ContainsKey('GovCloud')) {
                $metadata['GovCloud'] = $GovCloud
            }

            [PSCustomObject]@{
                Name     = $Name
                Metadata = $metadata
            }
        }

        . "$PSScriptRoot/../Public/LM/Connect-LMAccount.ps1"
    }

    BeforeEach {
        Remove-Variable LMAuth -Scope Script -ErrorAction SilentlyContinue
        Mock Get-SecretVault { }
        Mock Update-LogicMonitorModule { }
        Mock Get-Secret { 'cached-access-key' | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString }
    }

    It 'Sets GovCloud from cached metadata when GovCloud is True' {
        $mockSecret = New-MockCachedSecretInfo -Name 'fedramp-account' -Portal 'agency' -GovCloud 'True'
        Mock Get-SecretInfo { @($mockSecret) }

        Connect-LMAccount -CachedAccountName 'fedramp-account' -SkipCredValidation -SkipVersionCheck -DisableConsoleLogging

        $Script:LMAuth.GovCloud | Should -Be $true
        $Script:LMAuth.Portal | Should -Be 'agency'
    }

    It 'Defaults GovCloud to false when cached metadata has no GovCloud key' {
        $mockSecret = New-MockCachedSecretInfo -Name 'commercial-account' -Portal 'company'
        Mock Get-SecretInfo { @($mockSecret) }

        Connect-LMAccount -CachedAccountName 'commercial-account' -SkipCredValidation -SkipVersionCheck -DisableConsoleLogging

        $Script:LMAuth.GovCloud | Should -Be $false
    }

    It 'Uses explicit -GovCloud switch when cached metadata has no GovCloud key' {
        $mockSecret = New-MockCachedSecretInfo -Name 'commercial-account' -Portal 'company'
        Mock Get-SecretInfo { @($mockSecret) }

        Connect-LMAccount -CachedAccountName 'commercial-account' -GovCloud -SkipCredValidation -SkipVersionCheck -DisableConsoleLogging

        $Script:LMAuth.GovCloud | Should -Be $true
    }

    It 'Uses explicit -GovCloud switch when cached metadata has GovCloud False' {
        $mockSecret = New-MockCachedSecretInfo -Name 'commercial-account' -Portal 'company' -GovCloud 'False'
        Mock Get-SecretInfo { @($mockSecret) }

        Connect-LMAccount -CachedAccountName 'commercial-account' -GovCloud -SkipCredValidation -SkipVersionCheck -DisableConsoleLogging

        $Script:LMAuth.GovCloud | Should -Be $true
    }

    It 'Excludes Edwin cached credentials from -CachedAccountName lookup' {
        Mock Get-SecretInfo {
            @(
                New-MockCachedSecretInfo -Name 'commercial-account' -Portal 'company'
                New-MockCachedSecretInfo -Name 'EAI:myorg' -Portal 'myorg' -Id 'client-id' -Type 'EAI'
            )
        }

        { Connect-LMAccount -CachedAccountName 'EAI:myorg' -SkipCredValidation -SkipVersionCheck -DisableConsoleLogging -ErrorAction Stop } |
            Should -Throw '*does not match one of the stored credentials*'
    }

    It 'Excludes Edwin cached credentials from -UseCachedCredential selection list' {
        Mock Get-SecretInfo {
            @(
                New-MockCachedSecretInfo -Name 'commercial-account' -Portal 'company'
                New-MockCachedSecretInfo -Name 'EAI:myorg' -Portal 'myorg' -Id 'client-id' -Type 'EAI'
            )
        }
        Mock Read-Host { '0' }

        Connect-LMAccount -UseCachedCredential -SkipCredValidation -SkipVersionCheck -DisableConsoleLogging

        $Script:LMAuth.Portal | Should -Be 'company'
        Should -Invoke Read-Host -Times 1 -Exactly
    }

    It 'Uses normalized selection numbers when session sync credentials are present' {
        Mock Get-SecretInfo {
            @(
                New-MockCachedSecretInfo -Name 'first-account' -Portal 'first'
                New-MockCachedSecretInfo -Name 'LMSessionSync-hidden' -Portal 'hidden'
                New-MockCachedSecretInfo -Name 'second-account' -Portal 'second'
            )
        }
        Mock Read-Host { '1' }

        Connect-LMAccount -UseCachedCredential -SkipCredValidation -SkipVersionCheck -DisableConsoleLogging

        $Script:LMAuth.Portal | Should -Be 'second'
    }
}

Describe 'Get-LMCachedAccount GovCloud metadata' {
    BeforeAll {
        . "$PSScriptRoot/../Public/LM/Get-LMCachedAccount.ps1"
    }

    It 'Returns GovCloud true when metadata GovCloud is True' {
        Mock Get-SecretInfo {
            [PSCustomObject]@{
                Name     = 'fedramp-account'
                Metadata = @{
                    Portal   = 'agency'
                    Id       = 'test-id'
                    Modified = Get-Date
                    Type     = 'LMv1'
                    GovCloud = 'True'
                }
            }
        }

        $result = Get-LMCachedAccount -CachedAccountName 'fedramp-account'

        $result.GovCloud | Should -Be $true
    }

    It 'Returns GovCloud false when metadata has no GovCloud key' {
        Mock Get-SecretInfo {
            [PSCustomObject]@{
                Name     = 'commercial-account'
                Metadata = @{
                    Portal   = 'company'
                    Id       = 'test-id'
                    Modified = Get-Date
                    Type     = 'LMv1'
                }
            }
        }

        $result = Get-LMCachedAccount -CachedAccountName 'commercial-account'

        $result.GovCloud | Should -Be $false
    }
}
