BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Build-EAISdtOverridePayload' {
    It 'Builds a skip override payload' {
        InModuleScope -ModuleName $script:DevModuleName {
            $result = Build-EAISdtOverridePayload -Skip -OriginalInstanceId @{
                scheduleId = '97038d1b-648a-4718-b287-33726ed49624'
                startTime  = '2026-07-21T16:00:00.000Z'
            } -Summary 'skip note'

            $result.status | Should -Be 'SKIPPED'
            $result.summary | Should -Be 'skip note'
            $result.PSObject.Properties.Name | Should -Not -Contain 'newStartTime'
            $result.PSObject.Properties.Name | Should -Not -Contain 'newEndTime'
            $result.originalInstanceId.scheduleId | Should -Be '97038d1b-648a-4718-b287-33726ed49624'
        }
    }

    It 'Builds an adjust override payload' {
        InModuleScope -ModuleName $script:DevModuleName {
            $result = Build-EAISdtOverridePayload -OriginalInstanceId @{
                scheduleId = '97038d1b-648a-4718-b287-33726ed49624'
                startTime  = '2026-07-21T16:00:00.000Z'
            } -NewStartTime '2026-07-28T16:00:00Z' -NewEndTime '2026-07-28T17:00:00Z' -Summary 'adjusted note'

            $result.status | Should -Be 'SCHEDULED'
            $result.newStartTime | Should -Be '2026-07-28T16:00:00.000Z'
            $result.newEndTime | Should -Be '2026-07-28T17:00:00.000Z'
            $result.summary | Should -Be 'adjusted note'
        }
    }

    It 'Rejects skip payloads that include new times' {
        InModuleScope -ModuleName $script:DevModuleName {
            {
                Build-EAISdtOverridePayload -OriginalInstanceId @{
                    scheduleId = '97038d1b-648a-4718-b287-33726ed49624'
                    startTime  = '2026-07-21T16:00:00.000Z'
                } -NewStartTime '2026-07-28T16:00:00Z'
            } | Should -Throw '*NewEndTime*'
        }
    }
}

Describe 'New-EAISdtOverride' {
    BeforeEach {
        Disconnect-EAIAccount
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAIAuth.AccessToken = 'test-token' | ConvertTo-SecureString -AsPlainText -Force
            $Script:EAIAuth.TokenExpiresAt = (Get-Date).ToUniversalTime().AddHours(1)
        }
    }

    It 'Posts a skip override from a piped instance' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return $null }

            $instance = Add-ObjectTypeInfo -InputObject ([PSCustomObject]@{
                    instanceId         = '97038d1b-648a-4718-b287-33726ed49624:2026-07-21T16:00:00.000Z'
                    originalInstanceId = [PSCustomObject]@{
                        scheduleId = '97038d1b-648a-4718-b287-33726ed49624'
                        startTime  = [datetime]'2026-07-21T16:00:00Z'
                    }
                }) -TypeName 'Edwin.SDT.Instance'

            $instance | New-EAISdtOverride -Skip -Summary 'skip note'

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/action/sdt/97038d1b-648a-4718-b287-33726ed49624/override' -and
                $Method -eq 'POST' -and
                $Body -match '"status":"SKIPPED"' -and
                $Body -match '"summary":"skip note"'
            }
        }
    }

    It 'Posts an adjust override' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return $null }

            New-EAISdtOverride -ScheduleId '97038d1b-648a-4718-b287-33726ed49624' `
                -OriginalStartTime '2026-07-21T16:00:00Z' `
                -NewStartTime '2026-07-28T16:00:00Z' `
                -NewEndTime '2026-07-28T17:00:00Z' `
                -Summary 'adjusted note'

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Body -match '"status":"SCHEDULED"' -and
                $Body -match '"newStartTime":"2026-07-28T16:00:00.000Z"' -and
                $Body -match '"newEndTime":"2026-07-28T17:00:00.000Z"'
            }
        }
    }
}

Describe 'Remove-EAISdtOverride' {
    BeforeEach {
        Disconnect-EAIAccount
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAIAuth.AccessToken = 'test-token' | ConvertTo-SecureString -AsPlainText -Force
            $Script:EAIAuth.TokenExpiresAt = (Get-Date).ToUniversalTime().AddHours(1)
        }
    }

    It 'Deletes an override by instance ID' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return $null }

            Remove-EAISdtOverride -InstanceId '97038d1b-648a-4718-b287-33726ed49624:2026-07-22T16:00:00.000Z'

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -like 'https://myorg.dexda.ai/action/sdt/override/*' -and
                $Method -eq 'DELETE'
            }
        }
    }

    It 'Deletes an override from a piped instance using instanceId' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return $null }

            $instance = Add-ObjectTypeInfo -InputObject ([PSCustomObject]@{
                    instanceId         = '97038d1b-648a-4718-b287-33726ed49624:2026-07-22T16:00:00.000Z'
                    originalInstanceId = [PSCustomObject]@{
                        scheduleId = '97038d1b-648a-4718-b287-33726ed49624'
                        startTime  = [datetime]'2026-07-22T16:00:00Z'
                    }
                }) -TypeName 'Edwin.SDT.Instance'

            $instance | Remove-EAISdtOverride

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -like 'https://myorg.dexda.ai/action/sdt/override/*97038d1b-648a-4718-b287-33726ed49624*' -and
                $Method -eq 'DELETE'
            }
        }
    }

    It 'Deletes an override from a piped schedule override object with epoch timestamps' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return $null }

            $override = [PSCustomObject]@{
                newStartTime       = 1785342362
                newEndTime         = 1785515162
                status             = 'SCHEDULED'
                originalInstanceId = [PSCustomObject]@{
                    scheduleId = '97038d1b-648a-4718-b287-33726ed49624'
                    startTime  = 1785168000
                }
            }

            $override | Remove-EAISdtOverride

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -like 'https://myorg.dexda.ai/action/sdt/override/*97038d1b-648a-4718-b287-33726ed49624*' -and
                $Uri -like '*2026-07-27T16*' -and
                $Method -eq 'DELETE'
            }
        }
    }
}

Describe 'Set-EAISdtOverride' {
    BeforeEach {
        Disconnect-EAIAccount
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAIAuth.AccessToken = 'test-token' | ConvertTo-SecureString -AsPlainText -Force
            $Script:EAIAuth.TokenExpiresAt = (Get-Date).ToUniversalTime().AddHours(1)
        }
    }

    It 'Replaces all overrides with a PUT request body array' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return $null }

            Set-EAISdtOverride -ScheduleId '97038d1b-648a-4718-b287-33726ed49624' -Override @(
                @{
                    originalInstanceId = @{
                        scheduleId = '97038d1b-648a-4718-b287-33726ed49624'
                        startTime  = '2026-07-21T16:00:00.000Z'
                    }
                    status  = 'SKIPPED'
                    summary = 'bulk skip'
                }
            )

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/action/sdt/97038d1b-648a-4718-b287-33726ed49624/override' -and
                $Method -eq 'PUT' -and
                $Body -match '"status":"SKIPPED"'
            }
        }
    }

    It 'Clears all overrides with an empty array body' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return $null }

            Set-EAISdtOverride -ScheduleId '97038d1b-648a-4718-b287-33726ed49624' -Override @()

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/action/sdt/97038d1b-648a-4718-b287-33726ed49624/override' -and
                $Method -eq 'PUT' -and
                $Body -eq '[]'
            }
        }
    }

    It 'Clears all overrides with -Clear' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return $null }

            Set-EAISdtOverride -ScheduleId '97038d1b-648a-4718-b287-33726ed49624' -Clear

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Method -eq 'PUT' -and
                $Body -eq '[]'
            }
        }
    }
}
