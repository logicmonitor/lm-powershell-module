Describe 'SDT Timezone Resolution (Unit Tests)' {
    BeforeAll {
        $ModuleName = [IO.Path]::GetFileNameWithoutExtension($Module)
        Import-Module $Module -Force
    }

    Describe 'Find-LMTimeZoneInfo' {
        It 'Resolves IANA timezone to a valid TimeZoneInfo' {
            $result = InModuleScope $ModuleName { Find-LMTimeZoneInfo -Timezone 'America/New_York' }
            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeOfType [System.TimeZoneInfo]
        }
        It 'Resolves IANA Pacific timezone' {
            $result = InModuleScope $ModuleName { Find-LMTimeZoneInfo -Timezone 'America/Los_Angeles' }
            $result | Should -Not -BeNullOrEmpty
        }
        It 'Resolves Windows timezone name' {
            $result = InModuleScope $ModuleName { Find-LMTimeZoneInfo -Timezone 'Eastern Standard Time' }
            $result | Should -Not -BeNullOrEmpty
        }
        It 'Resolves Get-TimeZone StandardName' {
            $result = InModuleScope $ModuleName { Find-LMTimeZoneInfo -Timezone (Get-TimeZone).StandardName }
            $result | Should -Not -BeNullOrEmpty
        }
        It 'Resolves UTC' {
            $result = InModuleScope $ModuleName { Find-LMTimeZoneInfo -Timezone 'UTC' }
            $result | Should -Not -BeNullOrEmpty
        }
        It 'Resolves legacy US shorthand' {
            $result = InModuleScope $ModuleName { Find-LMTimeZoneInfo -Timezone 'US/Eastern' }
            $result | Should -Not -BeNullOrEmpty
        }
        It 'Throws on invalid timezone' {
            { InModuleScope $ModuleName { Find-LMTimeZoneInfo -Timezone 'Not/A/Real/Timezone' } } | Should -Throw
        }
    }

    Describe 'Resolve-LMTimezoneToIANAId' {
        It 'Passes through IANA timezone unchanged' {
            $result = InModuleScope $ModuleName { Resolve-LMTimezoneToIANAId -Timezone 'America/New_York' }
            $result | Should -Be 'America/New_York'
        }
        It 'Converts Windows Eastern to IANA' {
            $result = InModuleScope $ModuleName { Resolve-LMTimezoneToIANAId -Timezone 'Eastern Standard Time' }
            $result | Should -Be 'America/New_York'
        }
        It 'Converts Windows Pacific to IANA' {
            $result = InModuleScope $ModuleName { Resolve-LMTimezoneToIANAId -Timezone 'Pacific Standard Time' }
            $result | Should -Be 'America/Los_Angeles'
        }
        It 'Converts Windows Central to IANA' {
            $result = InModuleScope $ModuleName { Resolve-LMTimezoneToIANAId -Timezone 'Central Standard Time' }
            $result | Should -Be 'America/Chicago'
        }
        It 'Converts Windows Mountain to IANA' {
            $result = InModuleScope $ModuleName { Resolve-LMTimezoneToIANAId -Timezone 'Mountain Standard Time' }
            $result | Should -Be 'America/Denver'
        }
        It 'Passes through unknown timezone unchanged' {
            $result = InModuleScope $ModuleName { Resolve-LMTimezoneToIANAId -Timezone 'Some/Unknown_Zone' }
            $result | Should -Be 'Some/Unknown_Zone'
        }
        It 'Handles UTC' {
            $result = InModuleScope $ModuleName { Resolve-LMTimezoneToIANAId -Timezone 'UTC' }
            $result | Should -Be 'UTC'
        }
        It 'Resolves Get-TimeZone StandardName to an IANA ID' {
            $result = InModuleScope $ModuleName { Resolve-LMTimezoneToIANAId -Timezone (Get-TimeZone).StandardName }
            $result | Should -Not -BeNullOrEmpty
        }
    }

    Describe 'Test-LMTimezoneId' {
        It 'Accepts IANA timezone' {
            $result = InModuleScope $ModuleName { Test-LMTimezoneId -Timezone 'America/New_York' }
            $result | Should -Be $true
        }
        It 'Accepts Windows timezone' {
            $result = InModuleScope $ModuleName { Test-LMTimezoneId -Timezone 'Eastern Standard Time' }
            $result | Should -Be $true
        }
        It 'Accepts Get-TimeZone StandardName format' {
            $result = InModuleScope $ModuleName { Test-LMTimezoneId -Timezone (Get-TimeZone).StandardName }
            $result | Should -Be $true
        }
        It 'Accepts empty string' {
            $result = InModuleScope $ModuleName { Test-LMTimezoneId -Timezone '' }
            $result | Should -Be $true
        }
        It 'Rejects invalid timezone' {
            { InModuleScope $ModuleName { Test-LMTimezoneId -Timezone 'Not/A/Real/Timezone' } } | Should -Throw
        }
    }

    Describe 'ConvertTo-LMSDTEpochMillis' {
        It 'Produces same epoch for equivalent IANA and Windows timezones' {
            $TestDate = Get-Date '2026-06-15 14:00:00'
            $ianaResult = InModuleScope $ModuleName -Parameters @{ TestDate = $TestDate } {
                ConvertTo-LMSDTEpochMillis -DateTime $TestDate -Timezone 'America/New_York'
            }
            $windowsResult = InModuleScope $ModuleName -Parameters @{ TestDate = $TestDate } {
                ConvertTo-LMSDTEpochMillis -DateTime $TestDate -Timezone 'Eastern Standard Time'
            }
            $ianaResult | Should -Be $windowsResult
        }
        It 'Produces different epochs for different timezones with same wall clock time' {
            $TestDate = Get-Date '2026-06-15 14:00:00'
            $easternResult = InModuleScope $ModuleName -Parameters @{ TestDate = $TestDate } {
                ConvertTo-LMSDTEpochMillis -DateTime $TestDate -Timezone 'America/New_York'
            }
            $pacificResult = InModuleScope $ModuleName -Parameters @{ TestDate = $TestDate } {
                ConvertTo-LMSDTEpochMillis -DateTime $TestDate -Timezone 'America/Los_Angeles'
            }
            ($pacificResult - $easternResult) | Should -Be (3 * 3600 * 1000)
        }
    }
}

Describe 'SDT Schedule Payload (Unit Tests)' {
    BeforeAll {
        $ModuleName = [IO.Path]::GetFileNameWithoutExtension($Module)
        Import-Module $Module -Force
    }

    Describe 'Test-LMSDTDayOfMonth' {
        It 'Accepts valid calendar days' {
            InModuleScope $ModuleName { Test-LMSDTDayOfMonth -DayOfMonth 31 } | Should -Be $true
        }
        It 'Accepts -3 for last day of month' {
            InModuleScope $ModuleName { Test-LMSDTDayOfMonth -DayOfMonth -3 } | Should -Be $true
        }
        It 'Rejects invalid day values' {
            { InModuleScope $ModuleName { Test-LMSDTDayOfMonth -DayOfMonth 0 } } | Should -Throw
        }
    }

    Describe 'ConvertTo-LMSDTWeekDayApiValue' {
        It 'Joins multiple weekdays without spaces' {
            $result = InModuleScope $ModuleName {
                ConvertTo-LMSDTWeekDayApiValue -WeekDay @('Monday', 'Thursday')
            }
            $result | Should -Be 'Monday,Thursday'
        }
    }

    Describe 'Get-LMSDTRecurringDurationMinutes' {
        It 'Calculates duration for same-day window' {
            $result = InModuleScope $ModuleName {
                Get-LMSDTRecurringDurationMinutes -StartHour 13 -StartMinute 7 -EndHour 14 -EndMinute 7
            }
            $result | Should -Be 60
        }
    }

    Describe 'Resolve-LMSDTScheduleParameterSetName' {
        It 'Infers OneTimeRange from StartDate and EndDate' {
            $result = InModuleScope $ModuleName {
                Resolve-LMSDTScheduleParameterSetName -BoundParameters @{
                    StartDate = (Get-Date)
                    EndDate   = (Get-Date).AddHours(1)
                }
            }
            $result | Should -Be 'OneTimeRange'
        }

        It 'Infers OneTimeDuration from Duration' {
            $result = InModuleScope $ModuleName {
                Resolve-LMSDTScheduleParameterSetName -BoundParameters @{ Duration = 60 }
            }
            $result | Should -Be 'OneTimeDuration'
        }

        It 'Infers Recurring from SdtType and time fields' {
            $result = InModuleScope $ModuleName {
                Resolve-LMSDTScheduleParameterSetName -BoundParameters @{
                    SdtType     = 'Weekly'
                    StartHour   = 13
                    StartMinute = 7
                    EndHour     = 14
                    EndMinute   = 7
                    WeekDay     = @('Monday', 'Thursday')
                }
            }
            $result | Should -Be 'Recurring'
        }

        It 'Defaults recurring time-only schedules to Daily' {
            $result = InModuleScope $ModuleName {
                Build-LMSDTSchedulePayload -BoundParameters @{
                    StartHour   = 13
                    StartMinute = 7
                    EndHour     = 14
                    EndMinute   = 7
                    Timezone    = 'America/New_York'
                }
            }
            $result.sdtType | Should -Be 'daily'
        }
    }

    Describe 'Build-LMSDTSchedulePayload' {
        It 'Builds one-time duration payload' {
            $StartDate = Get-Date '2026-07-02 13:07:58'
            $result = InModuleScope $ModuleName -Parameters @{ StartDate = $StartDate } {
                Build-LMSDTSchedulePayload -ParameterSetName OneTimeDuration -BoundParameters @{
                    Duration  = 60
                    StartDate = $StartDate
                    Timezone  = 'America/New_York'
                }
            }
            $result.sdtType | Should -Be 'oneTime'
            $result.duration | Should -Be 60
            $result.timezone | Should -Be 'America/New_York'
            $result.startDateTime | Should -Not -BeNullOrEmpty
            $result.endDateTime | Should -BeGreaterThan $result.startDateTime
        }

        It 'Builds one-time range payload' {
            $StartDate = Get-Date '2026-07-02 13:08:44'
            $EndDate = Get-Date '2026-07-10 14:08:59'
            $result = InModuleScope $ModuleName -Parameters @{ StartDate = $StartDate; EndDate = $EndDate } {
                Build-LMSDTSchedulePayload -ParameterSetName OneTimeRange -BoundParameters @{
                    StartDate = $StartDate
                    EndDate   = $EndDate
                    Timezone  = 'America/New_York'
                }
            }
            $result.sdtType | Should -Be 'oneTime'
            $result.duration | Should -BeGreaterThan 0
            $result.startDateTime | Should -Not -BeNullOrEmpty
            $result.endDateTime | Should -BeGreaterThan $result.startDateTime
        }

        It 'Builds daily recurring payload' {
            $result = InModuleScope $ModuleName {
                Build-LMSDTSchedulePayload -ParameterSetName Recurring -BoundParameters @{
                    SdtType     = 'Daily'
                    StartHour   = 13
                    StartMinute = 7
                    EndHour     = 14
                    EndMinute   = 7
                    Timezone    = 'America/New_York'
                }
            }
            $result.sdtType | Should -Be 'daily'
            $result.duration | Should -Be 60
            $result.hour | Should -Be 13
            $result.minute | Should -Be 7
            $result.endHour | Should -Be 14
            $result.endMinute | Should -Be 7
        }

        It 'Builds weekly recurring payload with multiple weekdays' {
            $result = InModuleScope $ModuleName {
                Build-LMSDTSchedulePayload -ParameterSetName Recurring -BoundParameters @{
                    SdtType     = 'Weekly'
                    StartHour   = 13
                    StartMinute = 7
                    EndHour     = 14
                    EndMinute   = 7
                    WeekDay     = @('Monday', 'Thursday')
                    Timezone    = 'America/New_York'
                }
            }
            $result.sdtType | Should -Be 'weekly'
            $result.weekDay | Should -Be 'Monday,Thursday'
        }

        It 'Builds monthly recurring payload with monthDay 31' {
            $result = InModuleScope $ModuleName {
                Build-LMSDTSchedulePayload -ParameterSetName Recurring -BoundParameters @{
                    SdtType     = 'Monthly'
                    StartHour   = 13
                    StartMinute = 7
                    EndHour     = 14
                    EndMinute   = 7
                    DayOfMonth  = 31
                    Timezone    = 'America/New_York'
                }
            }
            $result.sdtType | Should -Be 'monthly'
            $result.monthDay | Should -Be 31
        }

        It 'Builds monthly recurring payload with last day of month' {
            $result = InModuleScope $ModuleName {
                Build-LMSDTSchedulePayload -ParameterSetName Recurring -BoundParameters @{
                    SdtType     = 'Monthly'
                    StartHour   = 13
                    StartMinute = 7
                    EndHour     = 14
                    EndMinute   = 7
                    DayOfMonth  = -3
                    Timezone    = 'America/New_York'
                }
            }
            $result.sdtType | Should -Be 'monthly'
            $result.monthDay | Should -Be -3
        }

        It 'Builds monthlyByWeek recurring payload' {
            $result = InModuleScope $ModuleName {
                Build-LMSDTSchedulePayload -ParameterSetName Recurring -BoundParameters @{
                    SdtType     = 'MonthlyByWeek'
                    StartHour   = 13
                    StartMinute = 7
                    EndHour     = 14
                    EndMinute   = 7
                    WeekDay     = @('Wednesday', 'Thursday')
                    WeekOfMonth = 'Third'
                    Timezone    = 'America/New_York'
                }
            }
            $result.sdtType | Should -Be 'monthlyByWeek'
            $result.weekDay | Should -Be 'Wednesday,Thursday'
            $result.weekOfMonth | Should -Be 'Third'
        }

        It 'Rejects OneTimeDuration with EndDate' {
            {
                InModuleScope $ModuleName {
                    Build-LMSDTSchedulePayload -ParameterSetName OneTimeDuration -BoundParameters @{
                        Duration  = 60
                        EndDate   = (Get-Date).AddHours(1)
                        Timezone  = 'America/New_York'
                    }
                }
            } | Should -Throw '*EndDate*'
        }

        It 'Rejects OneTimeRange with Duration' {
            {
                InModuleScope $ModuleName {
                    Build-LMSDTSchedulePayload -ParameterSetName OneTimeRange -BoundParameters @{
                        StartDate = (Get-Date)
                        EndDate   = (Get-Date).AddHours(1)
                        Duration  = 60
                        Timezone  = 'America/New_York'
                    }
                }
            } | Should -Throw '*Duration*'
        }
    }

    Describe 'ConvertTo-LMSDTScheduleSelection' {
        It 'Maps one-time duration only selection' {
            $result = InModuleScope $ModuleName {
                ConvertTo-LMSDTScheduleSelection -Selection @{
                    ScheduleType = 'OneTimeDurationOnly'
                    Duration     = 60
                }
            }
            $result.Duration | Should -Be 60
            $result.Keys | Should -Not -Contain 'StartDate'
        }

        It 'Maps one-time start plus duration selection' {
            $StartDate = Get-Date '2026-07-02 13:00:00'
            $result = InModuleScope $ModuleName -Parameters @{ StartDate = $StartDate } {
                ConvertTo-LMSDTScheduleSelection -Selection @{
                    ScheduleType = 'OneTimeStartDuration'
                    StartDate    = $StartDate
                    Duration     = 90
                }
            }
            $result.StartDate | Should -Be $StartDate
            $result.Duration | Should -Be 90
        }

        It 'Maps one-time range selection' {
            $StartDate = Get-Date '2026-07-02 13:00:00'
            $EndDate = Get-Date '2026-07-10 14:00:00'
            $result = InModuleScope $ModuleName -Parameters @{ StartDate = $StartDate; EndDate = $EndDate } {
                ConvertTo-LMSDTScheduleSelection -Selection @{
                    ScheduleType = 'OneTimeRange'
                    StartDate    = $StartDate
                    EndDate      = $EndDate
                }
            }
            $result.StartDate | Should -Be $StartDate
            $result.EndDate | Should -Be $EndDate
        }

        It 'Maps daily recurring selection' {
            $result = InModuleScope $ModuleName {
                ConvertTo-LMSDTScheduleSelection -Selection @{
                    ScheduleType = 'Daily'
                    StartHour    = 13
                    StartMinute  = 7
                    EndHour      = 14
                    EndMinute    = 7
                }
            }
            $result.SdtType | Should -Be 'Daily'
            $result.StartHour | Should -Be 13
            $result.EndMinute | Should -Be 7
        }

        It 'Maps weekly recurring selection with multiple weekdays' {
            $result = InModuleScope $ModuleName {
                ConvertTo-LMSDTScheduleSelection -Selection @{
                    ScheduleType = 'Weekly'
                    StartHour    = 13
                    StartMinute  = 7
                    EndHour      = 14
                    EndMinute    = 7
                    WeekDay      = @('Monday', 'Thursday')
                }
            }
            $result.SdtType | Should -Be 'Weekly'
            $result.WeekDay | Should -Be @('Monday', 'Thursday')
        }

        It 'Maps monthly selection with day 31' {
            $result = InModuleScope $ModuleName {
                ConvertTo-LMSDTScheduleSelection -Selection @{
                    ScheduleType = 'Monthly'
                    StartHour    = 13
                    StartMinute  = 7
                    EndHour      = 14
                    EndMinute    = 7
                    DayOfMonth   = 31
                }
            }
            $result.SdtType | Should -Be 'Monthly'
            $result.DayOfMonth | Should -Be 31
        }

        It 'Maps monthly selection with last day of month' {
            $result = InModuleScope $ModuleName {
                ConvertTo-LMSDTScheduleSelection -Selection @{
                    ScheduleType = 'Monthly'
                    StartHour    = 13
                    StartMinute  = 7
                    EndHour      = 14
                    EndMinute    = 7
                    DayOfMonth   = -3
                }
            }
            $result.DayOfMonth | Should -Be -3
        }

        It 'Maps monthlyByWeek selection' {
            $result = InModuleScope $ModuleName {
                ConvertTo-LMSDTScheduleSelection -Selection @{
                    ScheduleType = 'MonthlyByWeek'
                    StartHour    = 13
                    StartMinute  = 7
                    EndHour      = 14
                    EndMinute    = 7
                    WeekDay      = @('Wednesday', 'Thursday')
                    WeekOfMonth  = 'Third'
                }
            }
            $result.SdtType | Should -Be 'MonthlyByWeek'
            $result.WeekOfMonth | Should -Be 'Third'
            $result.WeekDay | Should -Be @('Wednesday', 'Thursday')
        }

        It 'Includes timezone when provided' {
            $result = InModuleScope $ModuleName {
                ConvertTo-LMSDTScheduleSelection -Selection @{
                    ScheduleType = 'OneTimeDurationOnly'
                    Duration     = 30
                    Timezone     = 'America/New_York'
                }
            }
            $result.Timezone | Should -Be 'America/New_York'
        }
    }

    Describe 'Test-LMSDTResourceComplete' {
        It 'Returns true when device ID is supplied' {
            $result = InModuleScope $ModuleName {
                Test-LMSDTResourceComplete -ResourceType Device -BoundParameters @{ DeviceId = '123' }
            }
            $result | Should -Be $true
        }

        It 'Returns false when device resource is missing' {
            $result = InModuleScope $ModuleName {
                Test-LMSDTResourceComplete -ResourceType Device -BoundParameters @{ Comment = 'test' }
            }
            $result | Should -Be $false
        }

        It 'Returns true when device datasource ID is supplied' {
            $result = InModuleScope $ModuleName {
                Test-LMSDTResourceComplete -ResourceType DeviceDatasource -BoundParameters @{ DeviceDataSourceId = '456' }
            }
            $result | Should -Be $true
        }
    }

    Describe 'Get-LMSDTCleanBoundParameters' {
        It 'Removes ScheduleWizard from bound parameters' {
            $result = InModuleScope $ModuleName {
                Get-LMSDTCleanBoundParameters -BoundParameters @{
                    ScheduleWizard = $true
                    Comment        = 'test'
                    DeviceId       = '123'
                }
            }
            $result.ContainsKey('ScheduleWizard') | Should -Be $false
            $result.Comment | Should -Be 'test'
            $result.DeviceId | Should -Be '123'
        }
    }

    Describe 'Select-LMResourceFromList' {
        It 'Returns null for an empty item list without throwing' {
            $result = InModuleScope $ModuleName {
                Select-LMResourceFromList -Items @() -DisplayProperty 'name' -IdProperty 'id' -ResourceLabel 'collector'
            }
            $result | Should -Be $null
        }
    }

    Describe 'Get-LMSDTWizardFilteredBrowseItems' {
        It 'Filters browse items using partial name match' {
            $result = InModuleScope $ModuleName {
                $items = @(
                    [pscustomobject]@{ hostname = 'lm-collector-01'; id = 1 }
                    [pscustomobject]@{ hostname = 'prod-collector-02'; id = 2 }
                )
                Get-LMSDTWizardFilteredBrowseItems -Browse { return $items } -FilterProperty 'hostname' -FilterText 'lm'
            }
            $result.Count | Should -Be 1
            $result[0].hostname | Should -Be 'lm-collector-01'
        }
    }

    Describe 'Read-LMWizardHost' {
        It 'Treats q as a wizard cancellation' {
            {
                InModuleScope $ModuleName {
                    Test-LMSDTWizardCancelKeyword -UserInput 'q'
                }
            } | Should -Throw '*SDT wizard cancelled*'
        }
    }

    Describe 'Get-LMSDTWizardTargetSummaryLines' {
        It 'Formats collector target details for the summary' {
            $lines = InModuleScope $ModuleName {
                function Get-LMCollector {
                    param($Id)
                    [pscustomobject]@{ hostname = 'lm-collector-01'; id = 114 }
                }

                Get-LMSDTWizardTargetSummaryLines -ResourceType Collector -BoundParameters @{
                    CollectorId = '114'
                }
            }

            $lines | Should -Be @('Collector: lm-collector-01 (ID: 114)')
        }
    }

    Describe 'Invoke-LMSDTCmdletWizard' {
        It 'Skips resource and comment prompts when pre-supplied and only runs schedule wizard' {
            $result = InModuleScope $ModuleName {
                $Script:LMAuth = @{ Valid = $true }
                function Invoke-LMSDTResourceWizard { throw 'Resource wizard should not run' }
                function Read-LMStringValue { param($Prompt) throw 'Comment prompt should not run' }
                function Build-LMSDTSchedule {
                    param([switch]$PassThru)
                    return @{ Duration = 120 }
                }
                function Confirm-LMSDTWizardSummary { return $true }

                Invoke-LMSDTCmdletWizard -ResourceType Device -BoundParameters @{
                    Comment  = 'Maint'
                    DeviceId = '214'
                }
            }

            $result.Comment | Should -Be 'Maint'
            $result.DeviceId | Should -Be '214'
            $result.Duration | Should -Be 120
        }

        It 'Skips schedule wizard when schedule parameters are pre-supplied' {
            $result = InModuleScope $ModuleName {
                $Script:LMAuth = @{ Valid = $true }
                function Invoke-LMSDTResourceWizard { return @{} }
                function Read-LMStringValue { param($Prompt) return 'Maint' }
                function Build-LMSDTSchedule {
                    param([switch]$PassThru)
                    throw 'Schedule wizard should not run'
                }
                function Confirm-LMSDTWizardSummary { return $true }

                Invoke-LMSDTCmdletWizard -ResourceType Device -BoundParameters @{
                    DeviceId = '214'
                    Duration = 60
                }
            }

            $result.Duration | Should -Be 60
            $result.Comment | Should -Be 'Maint'
        }

        It 'Returns null when schedule wizard is cancelled' {
            $result = InModuleScope $ModuleName {
                $Script:LMAuth = @{ Valid = $true }
                function Invoke-LMSDTResourceWizard { return @{ DeviceId = '214' } }
                function Read-LMStringValue { param($Prompt) return 'Maint' }
                function Build-LMSDTSchedule { return $null }
                function Confirm-LMSDTWizardSummary { return $true }

                Invoke-LMSDTCmdletWizard -ResourceType Device -BoundParameters @{}
            }

            $result | Should -Be $null
        }
    }

    Describe 'Invoke-LMSDTUpdateWizard' {
        It 'Skips SDT ID prompt when Id is pre-supplied' {
            $result = InModuleScope $ModuleName {
                $Script:LMAuth = @{ Valid = $true }
                function Build-LMSDTSchedule {
                    param([switch]$PassThru)
                    return @{ Duration = 90 }
                }
                function Confirm-LMSDTWizardSummary { return $true }

                Invoke-LMSDTUpdateWizard -BoundParameters @{
                    Id      = 'A_591'
                    Comment = 'Updated'
                }
            }

            $result.Id | Should -Be 'A_591'
            $result.Comment | Should -Be 'Updated'
            $result.Duration | Should -Be 90
        }
    }

    Describe 'Wizard selection to API payload' {
        It 'Produces expected API keys for weekly wizard selection' {
            $result = InModuleScope $ModuleName {
                $bound = ConvertTo-LMSDTScheduleSelection -Selection @{
                    ScheduleType = 'Weekly'
                    StartHour    = 13
                    StartMinute  = 7
                    EndHour      = 14
                    EndMinute    = 7
                    WeekDay      = @('Monday', 'Thursday')
                    Timezone     = 'America/New_York'
                }
                Build-LMSDTSchedulePayload -BoundParameters $bound
            }
            $result.sdtType | Should -Be 'weekly'
            $result.weekDay | Should -Be 'Monday,Thursday'
            $result.timezone | Should -Be 'America/New_York'
        }

        It 'Produces expected API keys for monthly last-day wizard selection' {
            $result = InModuleScope $ModuleName {
                $bound = ConvertTo-LMSDTScheduleSelection -Selection @{
                    ScheduleType = 'Monthly'
                    StartHour    = 13
                    StartMinute  = 7
                    EndHour      = 14
                    EndMinute    = 7
                    DayOfMonth   = -3
                    Timezone     = 'America/New_York'
                }
                Build-LMSDTSchedulePayload -BoundParameters $bound
            }
            $result.sdtType | Should -Be 'monthly'
            $result.monthDay | Should -Be -3
        }
    }
}

Describe 'SDT Testing' {
    BeforeAll {
        $ModuleName = [IO.Path]::GetFileNameWithoutExtension($Module)
        Import-Module $Module -Force
        . "$PSScriptRoot/Connect-LMTestAccount.ps1"
        Connect-LMTestAccount -DisableConsoleLogging -SkipCredValidation

        $script:TestSuffix = Get-LMTestSuffix
        $script:DeviceGroupSdtComment = "DeviceGroupSDT.Build.Test.$($script:TestSuffix)"
        $script:DeviceSdtComment = "DeviceSDT.Build.Test.$($script:TestSuffix)"
        $script:DeviceSdtWindowsTzComment = "DeviceSDT.Windows.TZ.Test.$($script:TestSuffix)"
        $script:DeviceSdtGetTzComment = "DeviceSDT.GetTZ.Test.$($script:TestSuffix)"
        $script:DeviceSdtDurationComment = "DeviceSDT.Duration.Test.$($script:TestSuffix)"
        $script:DeviceSdtWeeklyComment = "DeviceSDT.Weekly.Test.$($script:TestSuffix)"
    }
    
    Describe 'New-LMDeviceGroupSDT' {
        It 'When given mandatory parameters, returns a created DeviceGroup SDT with matching values' {
            $StartDate = (Get-Date).AddMinutes(5)
            $EndDate = $StartDate.AddHours(1)
            $Script:NewDeviceGroupSDT = New-LMDeviceGroupSDT -DeviceGroupId 1 -StartDate $StartDate -EndDate $EndDate -Timezone "America/New_York" -Comment $script:DeviceGroupSdtComment
            $Script:NewDeviceGroupSDT | Should -Not -BeNullOrEmpty
            $Script:NewDeviceGroupSDT.Comment | Should -Be $script:DeviceGroupSdtComment
            $Script:NewDeviceGroupSDT.Type | Should -Be "ResourceGroupSDT"
            $Script:NewDeviceGroupSDT.Timezone | Should -Be "America/New_York"
        }
    }

    Describe 'New-LMDeviceSDT' {
        It 'When given mandatory parameters with IANA timezone, returns a created Device SDT with matching values' {
            $StartDate = (Get-Date).AddMinutes(5)
            $EndDate = $StartDate.AddHours(1)
            $Script:NewDeviceSDT = New-LMDeviceSDT -DeviceId 123 -StartDate $StartDate -EndDate $EndDate -Timezone "America/New_York" -Comment $script:DeviceSdtComment
            $Script:NewDeviceSDT | Should -Not -BeNullOrEmpty
            $Script:NewDeviceSDT.Comment | Should -Be $script:DeviceSdtComment
            $Script:NewDeviceSDT.Type | Should -Be "ResourceSDT"
            $Script:NewDeviceSDT.Timezone | Should -Be "America/New_York"
        }
        It 'When given a Windows timezone name, converts to IANA and creates SDT successfully' {
            $StartDate = (Get-Date).AddMinutes(5)
            $EndDate = $StartDate.AddHours(1)
            $Script:NewDeviceSDTWindows = New-LMDeviceSDT -DeviceId 123 -StartDate $StartDate -EndDate $EndDate -Timezone "Eastern Standard Time" -Comment $script:DeviceSdtWindowsTzComment
            $Script:NewDeviceSDTWindows | Should -Not -BeNullOrEmpty
            $Script:NewDeviceSDTWindows.Comment | Should -Be $script:DeviceSdtWindowsTzComment
            $Script:NewDeviceSDTWindows.Type | Should -Be "ResourceSDT"
            $Script:NewDeviceSDTWindows.Timezone | Should -Be "America/New_York"
        }
        It 'When given Get-TimeZone StandardName, creates SDT successfully' {
            $StartDate = (Get-Date).AddMinutes(5)
            $EndDate = $StartDate.AddHours(1)
            $Script:NewDeviceSDTGetTZ = New-LMDeviceSDT -DeviceId 123 -StartDate $StartDate -EndDate $EndDate -Timezone (Get-TimeZone).StandardName -Comment $script:DeviceSdtGetTzComment
            $Script:NewDeviceSDTGetTZ | Should -Not -BeNullOrEmpty
            $Script:NewDeviceSDTGetTZ.Comment | Should -Be $script:DeviceSdtGetTzComment
            $Script:NewDeviceSDTGetTZ.Type | Should -Be "ResourceSDT"
        }
        It 'Creates a one-time duration SDT' {
            $Script:NewDeviceSDTDuration = New-LMDeviceSDT -DeviceId 123 -Duration 60 -Timezone "America/New_York" -Comment $script:DeviceSdtDurationComment
            $Script:NewDeviceSDTDuration | Should -Not -BeNullOrEmpty
            $Script:NewDeviceSDTDuration.SdtType | Should -Be "oneTime"
            $Script:NewDeviceSDTDuration.Duration | Should -Be 60
        }
        It 'Creates a weekly recurring SDT with multiple weekdays' {
            $Script:NewDeviceSDTWeekly = New-LMDeviceSDT -DeviceId 123 -SdtType Weekly -StartHour 13 -StartMinute 7 -EndHour 14 -EndMinute 7 -WeekDay Monday, Thursday -Timezone "America/New_York" -Comment $script:DeviceSdtWeeklyComment
            $Script:NewDeviceSDTWeekly | Should -Not -BeNullOrEmpty
            $Script:NewDeviceSDTWeekly.SdtType | Should -Be "weekly"
            $Script:NewDeviceSDTWeekly.WeekDay | Should -Be "Monday,Thursday"
        }
    }

    Describe 'Get-LMDeviceGroupSDT' {
        It 'When given a DeviceGroupId, returns SDTs for that group' {
            $SDT = Get-LMDeviceGroupSDT -Id 1
            $SDT | Should -Not -BeNullOrEmpty
            ($SDT | Measure-Object).Count  | Should -BeGreaterThan 0
        }
    }

    Describe 'Get-LMDeviceSDT' {
        It 'When given a DeviceId, returns SDTs for that device' {
            $SDT = Get-LMDeviceSDT -Id 123
            $SDT | Should -Not -BeNullOrEmpty
            ($SDT | Measure-Object).Count  | Should -BeGreaterThan 0
        }
    }

    Describe 'Get-LMSDT' {
        It 'When given no parameters, returns all SDTs' {
            $SDT = Get-LMSDT
            $SDT | Should -Not -BeNullOrEmpty
            ($SDT | Measure-Object).Count  | Should -BeGreaterThan 0
        }
        It 'When given an id should return that SDT' {
            $SDT = Get-LMSDT -Id $Script:NewDeviceGroupSDT.Id
            $SDT | Should -Not -BeNullOrEmpty
            ($SDT | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given an invalid id, should empty response' {
            $SDT = Get-LMSDT -Id 0
            $SDT | Should -BeNullOrEmpty
        }
    }

    Describe 'Remove-LMSDT' {
        It 'When given a DeviceGroup SDT id, remove the SDT from logic monitor' {
            { Remove-LMSDT -Id $Script:NewDeviceGroupSDT.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
        It 'When given a Device SDT id, remove the SDT from logic monitor' {
            { Remove-LMSDT -Id $Script:NewDeviceSDT.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
        It 'When given a Windows TZ Device SDT id, remove the SDT from logic monitor' {
            { Remove-LMSDT -Id $Script:NewDeviceSDTWindows.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
        It 'When given a Get-TZ Device SDT id, remove the SDT from logic monitor' {
            { Remove-LMSDT -Id $Script:NewDeviceSDTGetTZ.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
        It 'When given a duration Device SDT id, remove the SDT from logic monitor' {
            { Remove-LMSDT -Id $Script:NewDeviceSDTDuration.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
        It 'When given a weekly Device SDT id, remove the SDT from logic monitor' {
            { Remove-LMSDT -Id $Script:NewDeviceSDTWeekly.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}