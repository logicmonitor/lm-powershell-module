Describe 'Log Partition Cmdlet Tests' {
    BeforeAll {
        . "$PSScriptRoot/../Private/Test-LMResponseHasPagination.ps1"
        . "$PSScriptRoot/../Private/Add-ObjectTypeInfo.ps1"
        . "$PSScriptRoot/../Private/Build-LMLogPartitionActiveContract.ps1"
        . "$PSScriptRoot/../Private/Format-LMData.ps1"
        . "$PSScriptRoot/../Private/Format-LMFilter.ps1"
        . "$PSScriptRoot/../Private/Get-LMPortalURI.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMPaginatedGet.ps1"
        . "$PSScriptRoot/../Private/New-LMHeader.ps1"
        . "$PSScriptRoot/../Private/Resolve-LMDebugInfo.ps1"
        . "$PSScriptRoot/../Private/Test-LookupResult.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMRestMethod.ps1"
        . "$PSScriptRoot/../Public/Get-LMLogPartition.ps1"
        . "$PSScriptRoot/../Public/New-LMLogPartition.ps1"
        . "$PSScriptRoot/../Public/Set-LMLogPartition.ps1"
    }

    BeforeEach {
        $Script:LMAuth = @{
            Valid  = $true
            Type   = 'SessionSync'
            Portal = 'unit-test'
        }

        Mock Get-LMPortalURI { 'logicmonitor.com/santaba/rest' }
        Mock New-LMHeader { @(@{}, $null) }
        Mock Resolve-LMDebugInfo { }
        Mock Test-LookupResult { $false }
    }

    Context 'Build-LMLogPartitionActiveContract' {
        It 'Includes only bound contract fields plus always-include values' {
            $contract = Build-LMLogPartitionActiveContract `
                -BoundParameters @{ Retention = $true; AutoRestartOnRenewal = $true } `
                -Values @{
                    Retention            = 30
                    Sku                  = 'LGE'
                    AutoRestartOnRenewal = $true
                } `
                -AlwaysInclude @('Retention', 'Sku')

            $contract.retention | Should -Be 30
            $contract.sku | Should -Be 'LGE'
            $contract.autoRestartOnRenewal | Should -BeTrue
            $contract.PSObject.Properties.Name | Should -Not -Contain 'usageLimit'
        }

        It 'Merges patch values with the existing activeContract' {
            $existing = [PSCustomObject]@{
                id                    = 7
                fromEpoch             = 1782864000
                toEpoch               = 1785542400
                retention             = 398
                sku                   = 'LGE'
                usageLimit            = '0B'
                stopIngestionOnLimit  = $false
                contractIntervalHours = 0
                autoRestartOnRenewal  = $false
            }

            $merged = Merge-LMLogPartitionActiveContract `
                -ExistingContract $existing `
                -Patch @{ sku = 'LG3' }

            $merged.fromEpoch | Should -Be 1782864000
            $merged.toEpoch | Should -Be 1785542400
            $merged.id | Should -Be 7
            $merged.retention | Should -Be 398
            $merged.sku | Should -Be 'LG3'
            $merged.usageLimit | Should -Be '0B'
            $merged.stopIngestionOnLimit | Should -BeFalse
            $merged.contractIntervalHours | Should -Be 0
            $merged.autoRestartOnRenewal | Should -BeFalse
        }

        It 'Omits null and empty values from the merged contract' {
            $existing = [PSCustomObject]@{
                fromEpoch             = 1782864000
                toEpoch               = 1785542400
                retention             = 30
                sku                   = 'LGE'
                usageLimit            = ''
                contractIntervalHours = $null
                stopIngestionOnLimit  = $false
                autoRestartOnRenewal  = $false
            }

            $merged = Merge-LMLogPartitionActiveContract `
                -ExistingContract $existing `
                -Patch @{ sku = 'LG3' }

            $merged.PSObject.Properties.Name | Should -Not -Contain 'contractIntervalHours'
            $merged.PSObject.Properties.Name | Should -Not -Contain 'usageLimit'
            $merged.sku | Should -Be 'LG3'
            $merged.fromEpoch | Should -Be 1782864000
            $merged.toEpoch | Should -Be 1785542400
        }
    }

    Context 'Get-LMLogPartition' {
        It 'Adds backward-compatible contract note properties from activeContract' {
            Mock Invoke-LMRestMethod {
                return [PSCustomObject]@{
                    total = 1
                    items = @(
                        [PSCustomObject]@{
                            id             = 1
                            name           = 'default'
                            activeContract = [PSCustomObject]@{
                                retention            = 398
                                sku                  = 'LGE'
                                state                = 'active'
                                usageLimit           = '0B'
                                stopIngestionOnLimit = $false
                                contractIntervalHours = 0
                                autoRestartOnRenewal   = $false
                            }
                        }
                    )
                }
            }

            $result = Get-LMLogPartition
            $result.retention | Should -Be 398
            $result.sku | Should -Be 'LGE'
            $result.usageLimit | Should -Be '0B'
            $result.stopIngestionOnLimit | Should -BeFalse
            $result.contractIntervalHours | Should -Be 0
            $result.autoRestartOnRenewal | Should -BeFalse
            $result.activeContract.state | Should -Be 'active'
            $result.PSTypeNames[0] | Should -Be 'LogicMonitor.LogPartition'
        }
    }

    Context 'New-LMLogPartition' {
        It 'Posts retention and sku under activeContract' {
            Mock Get-LMLogPartition {
                return [PSCustomObject]@{
                    id             = 1
                    name           = 'default'
                    activeContract = [PSCustomObject]@{
                        sku = 'LGE'
                    }
                }
            }
            Mock Invoke-LMRestMethod {
                param($Body)
                $payload = $Body | ConvertFrom-Json
                $payload.name | Should -Be 'customerA'
                $payload.activeContract.retention | Should -Be 30
                $payload.activeContract.sku | Should -Be 'LGE'
                $payload.PSObject.Properties.Name | Should -Not -Contain 'retention'
                $payload.PSObject.Properties.Name | Should -Not -Contain 'sku'
                return [PSCustomObject]@{
                    id             = 2
                    name           = 'customerA'
                    activeContract = $payload.activeContract
                }
            }

            $result = New-LMLogPartition `
                -Name 'customerA' `
                -Description 'Customer A Log Partition' `
                -Retention 30 `
                -Status 'active' `
                -Tenant 'customerA' `
                -Confirm:$false

            $result.name | Should -Be 'customerA'
        }

        It 'Uses the supplied sku when provided' {
            Mock Get-LMLogPartition { throw 'Get-LMLogPartition should not be called when Sku is supplied' }
            Mock Invoke-LMRestMethod {
                param($Body)
                $payload = $Body | ConvertFrom-Json
                $payload.activeContract.sku | Should -Be 'LG7'
                return [PSCustomObject]@{ id = 3; name = 'customerB' }
            }

            $null = New-LMLogPartition `
                -Name 'customerB' `
                -Description 'Customer B Log Partition' `
                -Retention 7 `
                -Status 'active' `
                -Tenant 'customerB' `
                -Sku 'LG7' `
                -Confirm:$false
        }

        It 'Posts usage limit contract options in the UsageLimit parameter set' {
            Mock Get-LMLogPartition {
                return [PSCustomObject]@{
                    id             = 1
                    name           = 'default'
                    activeContract = [PSCustomObject]@{ sku = 'LGE' }
                }
            }
            Mock Invoke-LMRestMethod {
                param($Body)
                $payload = $Body | ConvertFrom-Json
                $payload.activeContract.usageLimit | Should -Be '100GB'
                $payload.activeContract.stopIngestionOnLimit | Should -BeTrue
                $payload.activeContract.autoRestartOnRenewal | Should -BeTrue
                $payload.activeContract.contractIntervalHours | Should -Be 0
                return [PSCustomObject]@{ id = 4; name = 'customerC' }
            }

            $null = New-LMLogPartition `
                -Name 'customerC' `
                -Description 'Customer C Log Partition' `
                -Retention 30 `
                -Status 'active' `
                -Tenant 'customerC' `
                -UsageLimit '100GB' `
                -StopIngestionOnLimit $true `
                -AutoRestartOnRenewal $true `
                -ContractIntervalHours 0 `
                -Confirm:$false
        }
    }

    Context 'Set-LMLogPartition' {
        It 'Nests retention and sku under activeContract when supplied' {
            Mock Get-LMLogPartition {
                return [PSCustomObject]@{
                    id             = 123
                    activeContract = [PSCustomObject]@{
                        retention            = 30
                        sku                  = 'LG7'
                        usageLimit           = '0B'
                        stopIngestionOnLimit = $false
                        contractIntervalHours = 0
                        autoRestartOnRenewal   = $false
                    }
                }
            }
            Mock Invoke-LMRestMethod {
                param($Uri, $Body)
                $Uri | Should -Match '/log/partitions/123$'
                $payload = $Body | ConvertFrom-Json
                $payload.description | Should -Be 'Updated'
                $payload.activeContract.retention | Should -Be 60
                $payload.activeContract.sku | Should -Be 'LGE'
                $payload.activeContract.usageLimit | Should -Be '0B'
                $payload.PSObject.Properties.Name | Should -Not -Contain 'retention'
                $payload.PSObject.Properties.Name | Should -Not -Contain 'sku'
                return [PSCustomObject]@{
                    id             = 123
                    description    = 'Updated'
                    activeContract = $payload.activeContract
                }
            }

            $result = Set-LMLogPartition -Id 123 -Description 'Updated' -Retention 60 -Sku 'LGE' -Confirm:$false
            $result.id | Should -Be 123
        }

        It 'Merges sku changes with the existing activeContract' {
            Mock Get-LMLogPartition {
                return [PSCustomObject]@{
                    id             = 5
                    activeContract = [PSCustomObject]@{
                        id                    = 7
                        fromEpoch             = 1782864000
                        toEpoch               = 1785542400
                        retention             = 398
                        sku                   = 'LGE'
                        usageLimit            = '0B'
                        stopIngestionOnLimit  = $false
                        contractIntervalHours = 0
                        autoRestartOnRenewal  = $false
                    }
                }
            }
            Mock Invoke-LMRestMethod {
                param($Body)
                $payload = $Body | ConvertFrom-Json
                $payload.activeContract.sku | Should -Be 'LG3'
                $payload.activeContract.retention | Should -Be 398
                $payload.activeContract.fromEpoch | Should -Be 1782864000
                $payload.activeContract.toEpoch | Should -Be 1785542400
                $payload.activeContract.usageLimit | Should -Be '0B'
                $payload.activeContract.contractIntervalHours | Should -Be 0
                $payload.PSObject.Properties.Name | Should -Not -Contain 'futureContract'
                return [PSCustomObject]@{ id = 5 }
            }

            $null = Set-LMLogPartition -Id 5 -Sku 'LG3' -Confirm:$false
        }

        It 'Omits activeContract when retention and sku are not supplied' {
            Mock Invoke-LMRestMethod {
                param($Body)
                $payload = $Body | ConvertFrom-Json
                $payload.description | Should -Be 'Only description'
                $payload.PSObject.Properties.Name | Should -Not -Contain 'activeContract'
                return [PSCustomObject]@{ id = 123; description = 'Only description' }
            }

            $result = Set-LMLogPartition -Id 123 -Description 'Only description' -Confirm:$false
            $result.description | Should -Be 'Only description'
        }

        It 'Resolves name to id before patching' {
            Mock Get-LMLogPartition {
                return [PSCustomObject]@{
                    id             = 55
                    name           = 'customerA'
                    activeContract = [PSCustomObject]@{
                        retention            = 30
                        sku                  = 'LGE'
                        usageLimit           = '0B'
                        stopIngestionOnLimit = $false
                        contractIntervalHours = 0
                        autoRestartOnRenewal   = $false
                    }
                }
            }
            Mock Invoke-LMRestMethod {
                param($Uri, $Body)
                $Uri | Should -Match '/log/partitions/55$'
                $payload = $Body | ConvertFrom-Json
                $payload.activeContract.retention | Should -Be 90
                $payload.activeContract.sku | Should -Be 'LGE'
                return [PSCustomObject]@{ id = 55; name = 'customerA' }
            }

            $result = Set-LMLogPartition -Name 'customerA' -Retention 90 -Confirm:$false
            $result.id | Should -Be 55
        }

        It 'Posts usage limit contract options in the UsageLimit parameter set' {
            Mock Get-LMLogPartition {
                return [PSCustomObject]@{
                    id             = 123
                    activeContract = [PSCustomObject]@{
                        retention            = 30
                        sku                  = 'LGE'
                        usageLimit           = '0B'
                        stopIngestionOnLimit = $false
                        contractIntervalHours = 0
                        autoRestartOnRenewal   = $false
                    }
                }
            }
            Mock Invoke-LMRestMethod {
                param($Body)
                $payload = $Body | ConvertFrom-Json
                $payload.activeContract.usageLimit | Should -Be '250GB'
                $payload.activeContract.stopIngestionOnLimit | Should -BeFalse
                $payload.activeContract.autoRestartOnRenewal | Should -BeTrue
                $payload.activeContract.retention | Should -Be 30
                $payload.activeContract.sku | Should -Be 'LGE'
                return [PSCustomObject]@{ id = 123 }
            }

            $null = Set-LMLogPartition `
                -Id 123 `
                -UsageLimit '250GB' `
                -StopIngestionOnLimit $false `
                -AutoRestartOnRenewal $true `
                -Confirm:$false
        }
    }
}
