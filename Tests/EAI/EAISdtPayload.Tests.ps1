BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Build-EAISdtSchedulePayload' {
    It 'Builds a one-time duration create payload with enabled default' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = [PSCustomObject]@{
                schemaName    = 'filterCondition'
                schemaVersion = '4'
                expression    = @{ AND = @() }
            }
            $startDate = (Get-Date).AddHours(2)
            $result = Build-EAISdtSchedulePayload -BoundParameters @{
                Name      = 'Maintenance'
                Filter    = $filter
                Duration  = 60
                StartDate = $startDate
                Timezone  = 'America/New_York'
            }

            $result.name | Should -Be 'Maintenance'
            $result.enabled | Should -Be 'ENABLED'
            $result.version | Should -Be 1
            $result.timezone | Should -Be 'America/New_York'
            $result.duration | Should -Be 'PT1H'
            $result.startTime | Should -Be (Format-EAISdtLocalDateTime -DateTime $startDate)
            $result.recurrencePattern.downtimeScheduleType | Should -Be 'ONE_TIME'
            $result.filter.schemaName | Should -Be 'filterCondition'
        }
    }

    It 'Uses a future startTime when StartDate is omitted' {
        InModuleScope -ModuleName $script:DevModuleName {
            $now = Get-EAISdtWallClockNow -Timezone 'America/New_York'
            $result = Build-EAISdtScheduleFields -BoundParameters @{
                Duration = 60
                Timezone = 'America/New_York'
            }

            $parsedStart = [Datetime]::ParseExact($result.startTime, 'yyyy-MM-ddTHH:mm:ss', $null)
            $parsedStart | Should -BeGreaterThan $now
        }
    }

    It 'Rejects a StartDate in the past' {
        InModuleScope -ModuleName $script:DevModuleName {
            {
                Build-EAISdtScheduleFields -BoundParameters @{
                    Duration  = 60
                    StartDate = (Get-Date).AddHours(-1)
                    Timezone  = 'America/New_York'
                }
            } | Should -Throw '*must be in the future*'
        }
    }

    It 'Maps -Enabled:$false to DISABLED' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = [PSCustomObject]@{
                schemaName    = 'filterCondition'
                schemaVersion = '4'
                expression    = @{ AND = @() }
            }
            $result = Build-EAISdtSchedulePayload -BoundParameters @{
                Name     = 'Disabled window'
                Filter   = $filter
                Duration = 30
                Enabled  = $false
            }

            $result.enabled | Should -Be 'DISABLED'
        }
    }

    It 'Builds a weekly recurring payload' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = [PSCustomObject]@{
                schemaName    = 'filterCondition'
                schemaVersion = '4'
                expression    = @{ AND = @() }
            }
            $result = Build-EAISdtSchedulePayload -BoundParameters @{
                Name        = 'Weekly window'
                Filter      = $filter
                SdtType     = 'Weekly'
                StartHour   = 13
                StartMinute = 7
                EndHour     = 14
                EndMinute   = 7
                WeekDay     = @('Monday', 'Thursday')
                Timezone    = 'America/New_York'
            }

            $result.recurrencePattern.downtimeScheduleType | Should -Be 'RECURRING'
            $result.recurrencePattern.frequency | Should -Be 'WEEKLY'
            $result.recurrencePattern.weekDays | Should -Be @('Monday', 'Thursday')
            $result.duration | Should -Be 'PT1H'
            $result.startTime | Should -Match 'T13:07:00$'
        }
    }
}

Describe 'Build-EAISdt update payloads' {
    It 'Builds metadata payload for disable using the existing schedule snapshot' {
        InModuleScope -ModuleName $script:DevModuleName {
            $existing = [PSCustomObject]@{
                name              = 'Test'
                description       = 'Test description'
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

            $result = Build-EAISdtMetadataUpdatePayload -BoundParameters @{
                Enabled = $false
            } -ExistingSchedule $existing

            $result.enabled | Should -Be 'DISABLED'
            $result.name | Should -Be 'Test'
            $result.description | Should -Be 'Test description'
            $result.filter.schemaName | Should -Be 'filterCondition'
            $result.timezone | Should -Be 'America/New_York'
            $result.startTime | Should -Be '2026-07-21T12:00:00'
            $result.recurrencePattern.downtimeScheduleType | Should -Be 'ONE_TIME'
        }
    }

    It 'Builds filter update payload' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = [PSCustomObject]@{
                schemaName    = 'filterCondition'
                schemaVersion = '4'
                expression    = @{ AND = @() }
            }
            $result = Build-EAISdtFilterUpdatePayload -BoundParameters @{
                Filter = $filter
            }

            $result.newFilter.schemaName | Should -Be 'filterCondition'
        }
    }

    It 'Merges partial recurrence updates with an existing schedule' {
        InModuleScope -ModuleName $script:DevModuleName {
            $existing = [PSCustomObject]@{
                timezone          = 'America/New_York'
                startTime         = '2026-07-02T13:07:00'
                duration          = 'PT1H'
                recurrencePattern = [PSCustomObject]@{
                    downtimeScheduleType = 'RECURRING'
                    frequency            = 'WEEKLY'
                    weekDays             = @('Monday')
                }
            }

            $result = Build-EAISdtRecurrenceUpdatePayload -BoundParameters @{
                WeekDay = @('Monday', 'Thursday')
            } -ExistingSchedule $existing

            $result.newPattern.frequency | Should -Be 'WEEKLY'
            $result.newPattern.weekDays | Should -Be @('Monday', 'Thursday')
        }
    }
}

Describe 'ConvertFrom-EAISdtIsoDuration' {
    It 'Parses hour and minute durations' {
        InModuleScope -ModuleName $script:DevModuleName {
            ConvertFrom-EAISdtIsoDuration -Duration 'PT2H' | Should -Be 120
            ConvertFrom-EAISdtIsoDuration -Duration 'PT90M' | Should -Be 90
            ConvertFrom-EAISdtIsoDuration -Duration 'P1D' | Should -Be 1440
        }
    }
}
