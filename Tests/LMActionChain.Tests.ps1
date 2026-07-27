Describe 'Action Chain Cmdlet Tests' {
    BeforeAll {
        . "$PSScriptRoot/../Private/LM/Test-LMResponseHasPagination.ps1"
        . "$PSScriptRoot/../Private/Shared/Add-ObjectTypeInfo.ps1"
        . "$PSScriptRoot/../Private/LM/Format-LMData.ps1"
        . "$PSScriptRoot/../Private/LM/Format-LMFilter.ps1"
        . "$PSScriptRoot/../Private/LM/Get-LMPortalURI.ps1"
        . "$PSScriptRoot/../Private/LM/Invoke-LMPaginatedGet.ps1"
        . "$PSScriptRoot/../Private/LM/New-LMHeader.ps1"
        . "$PSScriptRoot/../Private/LM/Resolve-LMDebugInfo.ps1"
        . "$PSScriptRoot/../Private/Shared/Test-LookupResult.ps1"
        . "$PSScriptRoot/../Private/LM/Invoke-LMRestMethod.ps1"
        . "$PSScriptRoot/../Public/LM/Get-LMActionChain.ps1"
        . "$PSScriptRoot/../Public/LM/New-LMActionChain.ps1"
        . "$PSScriptRoot/../Public/LM/Set-LMActionChain.ps1"
        . "$PSScriptRoot/../Public/LM/Remove-LMActionChain.ps1"
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

    Context 'Get-LMActionChain' {
        It 'Returns a single action chain by Id' {
            Mock Invoke-LMRestMethod {
                return [PSCustomObject]@{
                    id      = 10
                    name    = 'Test Chain'
                    stages  = @()
                    PSTypeName = 'LogicMonitor.ActionChain'
                }
            }

            $result = Get-LMActionChain -Id 10
            $result.id | Should -Be 10
            $result.name | Should -Be 'Test Chain'
        }

        It 'Builds name filter query for list lookup' {
            Mock Invoke-LMRestMethod {
                param($Uri)
                $Uri | Should -Match 'filter=name:"Test Chain"'
                return [PSCustomObject]@{
                    total = 1
                    items = @(
                        [PSCustomObject]@{ id = 10; name = 'Test Chain' }
                    )
                }
            }

            $result = Get-LMActionChain -Name 'Test Chain'
            $result.id | Should -Be 10
        }
    }

    Context 'New-LMActionChain' {
        It 'Posts stages in the request body' {
            Mock Invoke-LMRestMethod {
                param($Body)
                $payload = $Body | ConvertFrom-Json
                $payload.name | Should -Be 'Disk Chain'
                $payload.stages.Count | Should -Be 2
                $payload.stages[0].type | Should -Be 'diagnosticSource'
                return [PSCustomObject]@{ id = 99; name = 'Disk Chain'; stages = $payload.stages }
            }

            $result = New-LMActionChain -Name 'Disk Chain' -Stages @(
                [PSCustomObject]@{ id = 1; type = 'diagnosticSource' },
                [PSCustomObject]@{ id = 2; type = 'remediationSource' }
            ) -Confirm:$false

            $result.id | Should -Be 99
        }
    }

    Context 'Set-LMActionChain' {
        It 'Resolves name to id before patching' {
            Mock Get-LMActionChain {
                return [PSCustomObject]@{ id = 55; name = 'Lookup Chain' }
            }
            Mock Invoke-LMRestMethod {
                param($Uri, $Body)
                $Uri | Should -Match '/setting/action/chains/55$'
                $payload = $Body | ConvertFrom-Json
                $payload.description | Should -Be 'Updated'
                return [PSCustomObject]@{ id = 55; description = 'Updated' }
            }

            $result = Set-LMActionChain -Name 'Lookup Chain' -Description 'Updated' -Confirm:$false
            $result.id | Should -Be 55
        }
    }

    Context 'Remove-LMActionChain' {
        It 'Deletes by Id' {
            Mock Invoke-LMRestMethod { return $null }

            $result = Remove-LMActionChain -Id 77 -Confirm:$false
            $result.Id | Should -Be 77
            $result.Message | Should -Match 'Successfully removed'
        }
    }
}

Describe 'Action Rule Cmdlet Tests' {
    BeforeAll {
        . "$PSScriptRoot/../Private/LM/Test-LMResponseHasPagination.ps1"
        . "$PSScriptRoot/../Private/Shared/Add-ObjectTypeInfo.ps1"
        . "$PSScriptRoot/../Private/LM/Format-LMFilter.ps1"
        . "$PSScriptRoot/../Private/LM/Get-LMPortalURI.ps1"
        . "$PSScriptRoot/../Private/LM/Invoke-LMPaginatedGet.ps1"
        . "$PSScriptRoot/../Private/LM/New-LMHeader.ps1"
        . "$PSScriptRoot/../Private/LM/Resolve-LMDebugInfo.ps1"
        . "$PSScriptRoot/../Private/Shared/Test-LookupResult.ps1"
        . "$PSScriptRoot/../Private/LM/Invoke-LMRestMethod.ps1"
        . "$PSScriptRoot/../Public/LM/Get-LMActionRule.ps1"
        . "$PSScriptRoot/../Public/LM/New-LMActionRule.ps1"
        . "$PSScriptRoot/../Public/LM/Set-LMActionRule.ps1"
        . "$PSScriptRoot/../Public/LM/Remove-LMActionRule.ps1"
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

    Context 'New-LMActionRule' {
        It 'Creates an action rule with required fields' {
            Mock Invoke-LMRestMethod {
                param($Uri, $Body)
                $payload = $Body | ConvertFrom-Json
                $payload.actionChainId | Should -Be 456
                $payload.deviceGroups[0] | Should -Be '/Servers'
                return [PSCustomObject]@{ id = 1; name = 'Disk Rule'; actionChainId = 456 }
            }

            $result = New-LMActionRule -Name 'Disk Rule' -ActionChainId 456 -DeviceGroups @('/Servers') -LevelStr Critical -Confirm:$false
            $result.id | Should -Be 1
        }

        It 'Calls status endpoint when Enabled is specified' {
            Mock Invoke-LMRestMethod {
                param($Uri, $Body)
                if ($Uri -like '*/status') {
                    $script:StatusCalled = $true
                    $payload = $Body | ConvertFrom-Json
                    $payload.enabled | Should -Be $false
                    return [PSCustomObject]@{ id = 1; enabled = $false }
                }
                return [PSCustomObject]@{ id = 1; name = 'Disk Rule' }
            }

            $script:StatusCalled = $false
            $null = New-LMActionRule -Name 'Disk Rule' -ActionChainId 456 -DeviceGroups @('/Servers') -LevelStr Critical -Enabled:$false -Confirm:$false
            $script:StatusCalled | Should -Be $true
        }
    }

    Context 'Set-LMActionRule' {
        It 'Patches status endpoint when Enabled is specified' {
            Mock Invoke-LMRestMethod {
                param($Uri, $Body)
                $Uri | Should -Match '/status$'
                $payload = $Body | ConvertFrom-Json
                $payload.enabled | Should -Be $true
                return [PSCustomObject]@{ id = 5; enabled = $true }
            }

            $result = Set-LMActionRule -Id 5 -Enabled $true -Confirm:$false
            $result.enabled | Should -Be $true
        }
    }

    Context 'Get-LMActionRule' {
        It 'Returns typed action rules from list response' {
            Mock Invoke-LMRestMethod {
                return [PSCustomObject]@{
                    total = 1
                    items = @(
                        [PSCustomObject]@{ id = 3; name = 'Rule A'; enabled = $true }
                    )
                }
            }

            $result = Get-LMActionRule
            $result[0].PSTypeNames[0] | Should -Be 'LogicMonitor.ActionRule'
        }
    }
}

Describe 'ADR Cmdlet Tests' {
    BeforeAll {
        . "$PSScriptRoot/../Private/LM/Test-LMResponseHasPagination.ps1"
        . "$PSScriptRoot/../Private/Shared/Add-ObjectTypeInfo.ps1"
        . "$PSScriptRoot/../Private/LM/Get-LMPortalURI.ps1"
        . "$PSScriptRoot/../Private/LM/New-LMHeader.ps1"
        . "$PSScriptRoot/../Private/LM/Resolve-LMDebugInfo.ps1"
        . "$PSScriptRoot/../Private/Shared/Test-LookupResult.ps1"
        . "$PSScriptRoot/../Private/LM/Invoke-LMRestMethod.ps1"
        . "$PSScriptRoot/../Public/LM/Get-LMDiagnosticRemediationModule.ps1"
        . "$PSScriptRoot/../Public/LM/Get-LMDiagnosticRemediationExecutionResult.ps1"
        . "$PSScriptRoot/../Public/LM/Get-LMDiagnosticSource.ps1"
        . "$PSScriptRoot/../Public/LM/Get-LMRemediationSource.ps1"
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

    Context 'Get-LMDiagnosticRemediationModule' {
        It 'Builds query string from parameters' {
            Mock Invoke-LMRestMethod {
                param($Uri)
                $Uri | Should -Match 'alertId=DS12345'
                $Uri | Should -Match 'moduleType=diagnostic'
                return @(
                    [PSCustomObject]@{ id = 1; name = 'Module A'; type = 'diagnostic' }
                )
            }

            $result = Get-LMDiagnosticRemediationModule -AlertId 'DS12345' -ModuleType diagnostic
            $result[0].name | Should -Be 'Module A'
        }
    }

    Context 'Get-LMDiagnosticRemediationExecutionResult' {
        It 'Includes hostId in the request URI' {
            Mock Invoke-LMRestMethod {
                param($Uri)
                $Uri | Should -Match 'hostId=10'
                $Uri | Should -Match 'perPageCount=1000'
                return [PSCustomObject]@{
                    items = @([PSCustomObject]@{ executionId = 1; moduleName = 'Diag A' })
                    cursor = $null
                    remediationCursor = $null
                }
            }

            $result = Get-LMDiagnosticRemediationExecutionResult -HostId 10
            $result[0].moduleName | Should -Be 'Diag A'
        }

        It 'Aggregates all pages by default' {
            $script:CallCount = 0
            Mock Invoke-LMRestMethod {
                $script:CallCount++
                if ($script:CallCount -eq 1) {
                    return [PSCustomObject]@{
                        items = @([PSCustomObject]@{ executionId = 1; moduleName = 'Diag A' })
                        cursor = 'next'
                        remediationCursor = $null
                    }
                }
                return [PSCustomObject]@{
                    items = @([PSCustomObject]@{ executionId = 2; moduleName = 'Diag B' })
                    cursor = $null
                    remediationCursor = $null
                }
            }

            $result = Get-LMDiagnosticRemediationExecutionResult -HostId 10
            ($result | Measure-Object).Count | Should -Be 2
            $script:CallCount | Should -Be 2
        }
    }
}
