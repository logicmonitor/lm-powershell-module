BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Get-EAISdt' {
    BeforeEach {
        Disconnect-EAIAccount
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAIAuth.AccessToken = 'test-token' | ConvertTo-SecureString -AsPlainText -Force
            $Script:EAIAuth.TokenExpiresAt = (Get-Date).ToUniversalTime().AddHours(1)
        }
    }

    It 'Requires an active Edwin connection' {
        Disconnect-EAIAccount

        { Get-EAISdt -ErrorAction Stop } | Should -Throw
    }

    It 'Retrieves scheduled downtimes from Edwin' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod {
                param($Headers)
                $script:capturedHeaders = $Headers
                return @(
                    [PSCustomObject]@{
                        scheduleId = 'schedule-1'
                        name       = 'Maintenance window'
                    }
                    [PSCustomObject]@{
                        scheduleId = 'schedule-2'
                        name       = 'Change freeze'
                    }
                )
            }

            $results = Get-EAISdt

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/action/sdt' -and
                $Method -eq 'GET'
            }

            $script:capturedHeaders.Authorization | Should -Be 'Bearer test-token'

            $results.Count | Should -Be 2
            $results[0].name | Should -Be 'Maintenance window'
            $results[0].PSObject.TypeNames[0] | Should -Be 'Edwin.SDT'
        }
    }

    It 'Retrieves a single schedule by ID' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod {
                return [PSCustomObject]@{
                    scheduleId = '6d18821f-8f3c-48ca-8331-3e4c8d77cac3'
                    name       = 'Maintenance window'
                }
            }

            $result = Get-EAISdt -Id '6d18821f-8f3c-48ca-8331-3e4c8d77cac3'

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/action/sdt/6d18821f-8f3c-48ca-8331-3e4c8d77cac3' -and
                $Method -eq 'GET'
            }

            $result.scheduleId | Should -Be '6d18821f-8f3c-48ca-8331-3e4c8d77cac3'
            $result.PSObject.TypeNames[0] | Should -Be 'Edwin.SDT'
        }
    }

    It 'Returns an empty array when Edwin has no schedules' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return @() }

            $results = Get-EAISdt

            @($results).Count | Should -Be 0
        }
    }
}

Describe 'New-EAISdt' {
    BeforeEach {
        Disconnect-EAIAccount
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAIAuth.AccessToken = 'test-token' | ConvertTo-SecureString -AsPlainText -Force
            $Script:EAIAuth.TokenExpiresAt = (Get-Date).ToUniversalTime().AddHours(1)
        }
    }

    It 'Posts a create payload to /action/sdt' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = [PSCustomObject]@{
                schemaName    = 'filterCondition'
                schemaVersion = '4'
                expression    = @{ AND = @() }
            }
            Mock Invoke-EAIRestMethod { return $null }

            New-EAISdt -Name 'Maintenance' -Duration 60 -Filter $filter -Confirm:$false

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/action/sdt' -and
                $Method -eq 'POST' -and
                $Body -match '"name":"Maintenance"' -and
                $Body -match '"enabled":"ENABLED"'
            }
        }
    }

    It 'Merges wizard output before creating' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAISdtCmdletWizard {
                return @{
                    Name     = 'Wizard schedule'
                    Filter   = [PSCustomObject]@{
                        schemaName    = 'filterCondition'
                        schemaVersion = '4'
                        expression    = @{ AND = @() }
                    }
                    Duration = 45
                }
            }
            Mock Invoke-EAIRestMethod { return $null }

            New-EAISdt -ScheduleWizard -Confirm:$false

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Body -match '"name":"Wizard schedule"' -and
                $Body -match '"duration":"PT45M"'
            }
        }
    }
}

Describe 'Set-EAISdt' {
    BeforeEach {
        Disconnect-EAIAccount
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAIAuth.AccessToken = 'test-token' | ConvertTo-SecureString -AsPlainText -Force
            $Script:EAIAuth.TokenExpiresAt = (Get-Date).ToUniversalTime().AddHours(1)
        }
    }

    It 'Posts disable metadata to update/metadata' {
        InModuleScope -ModuleName $script:DevModuleName {
            $existing = [PSCustomObject]@{
                name              = 'Maintenance window'
                description       = 'Patch window'
                enabled           = 'ENABLED'
                timezone          = 'America/New_York'
                startTime         = '2026-07-21T12:00:00'
                duration          = 'PT1H'
                filter            = [PSCustomObject]@{
                    schemaName    = 'filterCondition'
                    schemaVersion = '4'
                    expression    = @{ AND = @() }
                }
                recurrencePattern = [PSCustomObject]@{
                    downtimeScheduleType = 'ONE_TIME'
                    frequency            = 'DAILY'
                }
            }

            Mock Get-EAISdt { return $existing }
            Mock Invoke-EAIRestMethod { return $null }

            Set-EAISdt -Id '6d18821f-8f3c-48ca-8331-3e4c8d77cac3' -Enabled:$false -Confirm:$false

            Should -Invoke Get-EAISdt -Times 1 -ParameterFilter {
                $Id -eq '6d18821f-8f3c-48ca-8331-3e4c8d77cac3'
            }
            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/action/sdt/6d18821f-8f3c-48ca-8331-3e4c8d77cac3/update/metadata' -and
                $Method -eq 'POST' -and
                $Body -match '"enabled":"DISABLED"' -and
                $Body -match '"name":"Maintenance window"' -and
                $Body -match '"description":"Patch window"'
            }
        }
    }

    It 'Accepts piped Edwin.SDT objects by scheduleId' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return $null }

            $schedule = Add-ObjectTypeInfo -InputObject ([PSCustomObject]@{
                    scheduleId        = '6d18821f-8f3c-48ca-8331-3e4c8d77cac3'
                    name              = 'Maintenance window'
                    description       = 'Patch window'
                    enabled           = 'ENABLED'
                    timezone          = 'America/New_York'
                    startTime         = '2026-07-21T12:00:00'
                    duration          = 'PT1H'
                    filter            = [PSCustomObject]@{
                        schemaName    = 'filterCondition'
                        schemaVersion = '4'
                        expression    = @{ AND = @() }
                    }
                    recurrencePattern = [PSCustomObject]@{
                        downtimeScheduleType = 'ONE_TIME'
                        frequency            = 'DAILY'
                    }
                }) -TypeName 'Edwin.SDT'

            $schedule | Set-EAISdt -Enabled:$false -Confirm:$false

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/action/sdt/6d18821f-8f3c-48ca-8331-3e4c8d77cac3/update/metadata' -and
                $Body -match '"name":"Maintenance window"'
            }
        }
    }

    It 'Routes filter and recurrence updates to separate endpoints' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = [PSCustomObject]@{
                schemaName    = 'filterCondition'
                schemaVersion = '4'
                expression    = @{ AND = @() }
            }
            $existing = [PSCustomObject]@{
                scheduleId        = '6d18821f-8f3c-48ca-8331-3e4c8d77cac3'
                name              = 'Weekly window'
                description       = 'Original'
                enabled           = 'ENABLED'
                timezone          = 'America/New_York'
                startTime         = '2026-07-02T13:07:00'
                duration          = 'PT1H'
                filter            = [PSCustomObject]@{
                    schemaName    = 'filterCondition'
                    schemaVersion = '4'
                    expression    = @{ AND = @() }
                }
                recurrencePattern = [PSCustomObject]@{
                    downtimeScheduleType = 'RECURRING'
                    frequency            = 'WEEKLY'
                    weekDays             = @('Monday')
                }
            }

            Mock Get-EAISdt { return $existing }
            Mock Invoke-EAIRestMethod { return $null }

            Set-EAISdt -Id '6d18821f-8f3c-48ca-8331-3e4c8d77cac3' `
                -Description 'Updated' `
                -Filter $filter `
                -WeekDay Monday, Thursday `
                -Confirm:$false

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -like '*/update/metadata' -and $Body -match '"description":"Updated"'
            }
            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -like '*/update/filter' -and $Body -match '"newFilter"'
            }
            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -like '*/update/recurrence' -and $Body -match '"newPattern"'
            }
        }
    }

}
