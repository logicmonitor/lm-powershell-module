BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Convert-EAISdtApiTimestamp helpers' {
    It 'Converts epoch seconds to UTC DateTime' {
        InModuleScope -ModuleName $script:DevModuleName {
            $result = ConvertFrom-EAISdtApiTimestamp -Value 1784649600
            $result.Kind | Should -Be 'Utc'
        }
    }

    It 'Formats API instants with millisecond precision' {
        InModuleScope -ModuleName $script:DevModuleName {
            $result = ConvertTo-EAISdtApiInstant -DateTime '2026-07-22T16:00:00Z'
            $result | Should -Be '2026-07-22T16:00:00.000Z'
        }
    }

    It 'Formats instance IDs for delete paths' {
        InModuleScope -ModuleName $script:DevModuleName {
            $result = Format-EAISdtInstanceId -ScheduleId '97038d1b-648a-4718-b287-33726ed49624' `
                -StartTime '2026-07-22T16:00:00Z'
            $result | Should -Be '97038d1b-648a-4718-b287-33726ed49624:2026-07-22T16:00:00.000Z'
        }
    }

    It 'Normalizes instance API objects' {
        InModuleScope -ModuleName $script:DevModuleName {
            $raw = [PSCustomObject]@{
                startTime  = 1784649600
                endTime    = 1784653200
                instanceId = [PSCustomObject]@{
                    scheduleId = '97038d1b-648a-4718-b287-33726ed49624'
                    startTime  = 1784649600
                }
            }

            $result = ConvertTo-EAISdtInstanceObject -InputObject $raw

            $result.startTime | Should -BeOfType [datetime]
            $result.originalInstanceId.startTime | Should -BeOfType [datetime]
            $result.instanceId | Should -Be '97038d1b-648a-4718-b287-33726ed49624:2026-07-21T16:00:00.000Z'
        }
    }
}

Describe 'Get-EAISdtInstance' {
    BeforeEach {
        Disconnect-EAIAccount
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAIAuth.AccessToken = 'test-token' | ConvertTo-SecureString -AsPlainText -Force
            $Script:EAIAuth.TokenExpiresAt = (Get-Date).ToUniversalTime().AddHours(1)
        }
    }

    It 'Queries instances with start and end time parameters' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod {
                return @(
                    [PSCustomObject]@{
                        startTime  = 1784649600
                        endTime    = 1784653200
                        status     = 'SCHEDULED'
                        instanceId = [PSCustomObject]@{
                            scheduleId = '97038d1b-648a-4718-b287-33726ed49624'
                            startTime  = 1784649600
                        }
                    }
                )
            }

            $start = [datetime]'2026-07-19T04:00:00Z'
            $end = [datetime]'2026-07-26T03:59:59Z'
            $results = Get-EAISdtInstance -ScheduleId '97038d1b-648a-4718-b287-33726ed49624' -StartTime $start -EndTime $end

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -like 'https://myorg.dexda.ai/action/sdt/97038d1b-648a-4718-b287-33726ed49624/instance?startTime=*&endTime=*' -and
                $Method -eq 'GET'
            }

            @($results).Count | Should -Be 1
            $results[0].PSTypeNames | Should -Contain 'Edwin.SDT.Instance'
        }
    }

    It 'Accepts piped Edwin.SDT objects by scheduleId' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return @() }

            $schedule = Add-ObjectTypeInfo -InputObject ([PSCustomObject]@{
                    scheduleId = '97038d1b-648a-4718-b287-33726ed49624'
                    name       = 'Maintenance window'
                }) -TypeName 'Edwin.SDT'

            $schedule | Get-EAISdtInstance

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -like 'https://myorg.dexda.ai/action/sdt/97038d1b-648a-4718-b287-33726ed49624/instance?startTime=*&endTime=*' -and
                $Method -eq 'GET'
            }
        }
    }

    It 'Retrieves a single instance by ID' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod {
                return [PSCustomObject]@{
                    startTime  = 1784649600
                    endTime    = 1784653200
                    status     = 'ACTIVE'
                    instanceId = [PSCustomObject]@{
                        scheduleId = '97038d1b-648a-4718-b287-33726ed49624'
                        startTime  = 1784649600
                    }
                }
            }

            $result = Get-EAISdtInstance -InstanceId '97038d1b-648a-4718-b287-33726ed49624:2026-07-21T16:00:00.000Z'

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -like 'https://myorg.dexda.ai/action/sdt/instance/*' -and
                $Method -eq 'GET'
            }

            $result.PSTypeNames | Should -Contain 'Edwin.SDT.Instance'
        }
    }
}
