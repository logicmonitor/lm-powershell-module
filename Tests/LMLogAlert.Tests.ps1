Describe 'Log Alert Group Cmdlet Tests' {
    BeforeAll {
        . "$PSScriptRoot/../Private/Test-LMResponseHasPagination.ps1"
        . "$PSScriptRoot/../Private/Add-ObjectTypeInfo.ps1"
        . "$PSScriptRoot/../Private/Format-LMData.ps1"
        . "$PSScriptRoot/../Private/Get-LMPortalURI.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMPaginatedGet.ps1"
        . "$PSScriptRoot/../Private/New-LMHeader.ps1"
        . "$PSScriptRoot/../Private/Resolve-LMDebugInfo.ps1"
        . "$PSScriptRoot/../Private/Test-LookupResult.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMRestMethod.ps1"
        . "$PSScriptRoot/../Public/Get-LMLogAlertGroup.ps1"
        . "$PSScriptRoot/../Public/New-LMLogAlertGroup.ps1"
        . "$PSScriptRoot/../Public/Set-LMLogAlertGroup.ps1"
        . "$PSScriptRoot/../Public/Remove-LMLogAlertGroup.ps1"
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

    Context 'Get-LMLogAlertGroup' {
        It 'Returns a single log alert group by Id' {
            Mock Invoke-LMRestMethod {
                return [PSCustomObject]@{
                    id          = 10
                    name        = 'Test Group'
                    description = 'Test description'
                }
            }

            $result = Get-LMLogAlertGroup -Id 10
            $result.id | Should -Be 10
            $result.name | Should -Be 'Test Group'
            $result.PSTypeNames[0] | Should -Be 'LogicMonitor.LogAlertGroup'
        }

        It 'Filters by name client-side' {
            Mock Invoke-LMRestMethod {
                param($Uri)
                $Uri | Should -Match '/logpipelines$'
                return [PSCustomObject]@{
                    total = 2
                    items = @(
                        [PSCustomObject]@{ id = 10; name = 'Test Group' },
                        [PSCustomObject]@{ id = 11; name = 'Other Group' }
                    )
                }
            }

            $result = Get-LMLogAlertGroup -Name 'Test Group'
            $result.id | Should -Be 10
            $result.name | Should -Be 'Test Group'
        }
    }

    Context 'New-LMLogAlertGroup' {
        It 'Posts required fields in the request body' {
            Mock Invoke-LMRestMethod {
                param($Body)
                $payload = $Body | ConvertFrom-Json
                $payload.name | Should -Be 'Production Logs'
                $payload.query | Should -Be 'environment:production'
                $Body | Should -Match '"partitions"\s*:\s*\['
                $Body | Should -Match '"default"'
                return [PSCustomObject]@{ id = 99; name = 'Production Logs' }
            }

            $result = New-LMLogAlertGroup -Name 'Production Logs' -Query 'environment:production' -Partition 'default' -Confirm:$false
            $result.id | Should -Be 99
        }

        It 'Posts partitions as a JSON array when a single value is supplied' {
            Mock Invoke-LMRestMethod {
                param($Body)
                $Body | Should -Match '"partitions"\s*:\s*\['
                $Body | Should -Match '"0"'
                return [PSCustomObject]@{ id = 100; name = 'Test' }
            }

            $result = New-LMLogAlertGroup -Name 'Test' -Query 'environment:test' -Partition '0' -Confirm:$false
            $result.id | Should -Be 100
        }
    }

    Context 'Set-LMLogAlertGroup' {
        It 'Resolves name to id before patching' {
            Mock Get-LMLogAlertGroup {
                return [PSCustomObject]@{ id = 55; name = 'Lookup Group' }
            }
            Mock Invoke-LMRestMethod {
                param($Uri, $Body)
                $Uri | Should -Match '/logpipelines/55$'
                $payload = $Body | ConvertFrom-Json
                $payload.description | Should -Be 'Updated'
                return [PSCustomObject]@{ id = 55; description = 'Updated' }
            }

            $result = Set-LMLogAlertGroup -Name 'Lookup Group' -Description 'Updated' -Confirm:$false
            $result.id | Should -Be 55
        }
    }

    Context 'Remove-LMLogAlertGroup' {
        It 'Deletes by Id' {
            Mock Invoke-LMRestMethod { return $null }

            $result = Remove-LMLogAlertGroup -Id 77 -Confirm:$false
            $result.Id | Should -Be 77
            $result.Message | Should -Match 'Successfully removed'
        }
    }
}

Describe 'Log Alert Cmdlet Tests' {
    BeforeAll {
        . "$PSScriptRoot/../Private/Test-LMResponseHasPagination.ps1"
        . "$PSScriptRoot/../Private/Add-ObjectTypeInfo.ps1"
        . "$PSScriptRoot/../Private/Format-LMData.ps1"
        . "$PSScriptRoot/../Private/Get-LMPortalURI.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMPaginatedGet.ps1"
        . "$PSScriptRoot/../Private/New-LMHeader.ps1"
        . "$PSScriptRoot/../Private/Resolve-LMDebugInfo.ps1"
        . "$PSScriptRoot/../Private/Test-LookupResult.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMRestMethod.ps1"
        . "$PSScriptRoot/../Public/Get-LMLogAlert.ps1"
        . "$PSScriptRoot/../Public/New-LMLogAlert.ps1"
        . "$PSScriptRoot/../Public/Set-LMLogAlert.ps1"
        . "$PSScriptRoot/../Public/Remove-LMLogAlert.ps1"
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

    Context 'Get-LMLogAlert' {
        It 'Filters by PipelineId client-side' {
            Mock Invoke-LMRestMethod {
                return [PSCustomObject]@{
                    total = 2
                    items = @(
                        [PSCustomObject]@{ id = 1; name = 'Alert A'; pipelineId = 10 },
                        [PSCustomObject]@{ id = 2; name = 'Alert B'; pipelineId = 20 }
                    )
                }
            }

            $result = Get-LMLogAlert -PipelineId 10
            $result.Count | Should -Be 1
            $result[0].id | Should -Be 1
            $result.PSTypeNames[0] | Should -Be 'LogicMonitor.LogAlert'
        }
    }

    Context 'New-LMLogAlert' {
        It 'Posts pipelineId in the request body' {
            Mock Invoke-LMRestMethod {
                param($Body)
                $payload = $Body | ConvertFrom-Json
                $payload.name | Should -Be 'High Error Rate'
                $payload.pipelineId | Should -Be 10
                $payload.severity | Should -Be 'error'
                return [PSCustomObject]@{ id = 5; name = 'High Error Rate'; pipelineId = 10 }
            }

            $result = New-LMLogAlert -Name 'High Error Rate' -PipelineId 10 -Severity error -Confirm:$false
            $result.id | Should -Be 5
        }

        It 'Calls disable action endpoint when Disabled is specified' {
            $script:callCount = 0
            Mock Invoke-LMRestMethod {
                param($Uri, $Body)
                $script:callCount++
                if ($script:callCount -eq 1) {
                    return [PSCustomObject]@{ id = 5; name = 'Disabled Alert'; pipelineId = 10 }
                }
                $Uri | Should -Match '/logpipelines/processors/5/disable$'
                $payload = $Body | ConvertFrom-Json
                $payload.value | Should -Be $true
                return [PSCustomObject]@{ id = 5; name = 'Disabled Alert'; disabled = $true }
            }

            $result = New-LMLogAlert -Name 'Disabled Alert' -PipelineId 10 -Disabled $true -Confirm:$false
            $script:callCount | Should -Be 2
            $result.id | Should -Be 5
        }
    }

    Context 'Set-LMLogAlert' {
        It 'Calls enable action endpoint when Disabled is false' {
            Mock Invoke-LMRestMethod {
                param($Uri, $Body)
                $Uri | Should -Match '/logpipelines/processors/5/enable$'
                $payload = $Body | ConvertFrom-Json
                $payload.value | Should -Be $false
                return [PSCustomObject]@{ id = 5; disabled = $false }
            }

            $result = Set-LMLogAlert -Id 5 -Disabled $false -Confirm:$false
            $result.id | Should -Be 5
        }

        It 'Accepts pipeline input by Id when updating with NewName' {
            Mock Invoke-LMRestMethod {
                param($Uri, $Body)
                $Uri | Should -Match '/logpipelines/processors/5$'
                $payload = $Body | ConvertFrom-Json
                $payload.name | Should -Be 'Dynatrace Alerts Test'
                return [PSCustomObject]@{ id = 5; name = 'Dynatrace Alerts Test' }
            }

            $alert = [PSCustomObject]@{ id = 5; name = 'Original Name'; pipelineId = 10 }
            $alert = Add-ObjectTypeInfo -InputObject $alert -TypeName 'LogicMonitor.LogAlert'
            $result = $alert | Set-LMLogAlert -NewName 'Dynatrace Alerts Test' -Confirm:$false
            $result.name | Should -Be 'Dynatrace Alerts Test'
        }
    }

    Context 'Remove-LMLogAlert' {
        It 'Deletes by Id' {
            Mock Invoke-LMRestMethod { return $null }

            $result = Remove-LMLogAlert -Id 42 -Confirm:$false
            $result.Id | Should -Be 42
            $result.Message | Should -Match 'Successfully removed'
        }
    }
}
