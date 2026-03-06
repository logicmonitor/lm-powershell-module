Describe 'SDT Timezone Resolution (Unit Tests)' {
    BeforeAll {
        Import-Module $Module -Force
    }

    Describe 'Find-LMTimeZoneInfo' {
        It 'Resolves IANA timezone to a valid TimeZoneInfo' {
            $result = InModuleScope 'Logic.Monitor' { Find-LMTimeZoneInfo -Timezone 'America/New_York' }
            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeOfType [System.TimeZoneInfo]
        }
        It 'Resolves IANA Pacific timezone' {
            $result = InModuleScope 'Logic.Monitor' { Find-LMTimeZoneInfo -Timezone 'America/Los_Angeles' }
            $result | Should -Not -BeNullOrEmpty
        }
        It 'Resolves Windows timezone name' {
            $result = InModuleScope 'Logic.Monitor' { Find-LMTimeZoneInfo -Timezone 'Eastern Standard Time' }
            $result | Should -Not -BeNullOrEmpty
        }
        It 'Resolves Get-TimeZone StandardName' {
            $result = InModuleScope 'Logic.Monitor' { Find-LMTimeZoneInfo -Timezone (Get-TimeZone).StandardName }
            $result | Should -Not -BeNullOrEmpty
        }
        It 'Resolves UTC' {
            $result = InModuleScope 'Logic.Monitor' { Find-LMTimeZoneInfo -Timezone 'UTC' }
            $result | Should -Not -BeNullOrEmpty
        }
        It 'Resolves legacy US shorthand' {
            $result = InModuleScope 'Logic.Monitor' { Find-LMTimeZoneInfo -Timezone 'US/Eastern' }
            $result | Should -Not -BeNullOrEmpty
        }
        It 'Throws on invalid timezone' {
            { InModuleScope 'Logic.Monitor' { Find-LMTimeZoneInfo -Timezone 'Not/A/Real/Timezone' } } | Should -Throw
        }
    }

    Describe 'Resolve-LMTimezoneToIANAId' {
        It 'Passes through IANA timezone unchanged' {
            $result = InModuleScope 'Logic.Monitor' { Resolve-LMTimezoneToIANAId -Timezone 'America/New_York' }
            $result | Should -Be 'America/New_York'
        }
        It 'Converts Windows Eastern to IANA' {
            $result = InModuleScope 'Logic.Monitor' { Resolve-LMTimezoneToIANAId -Timezone 'Eastern Standard Time' }
            $result | Should -Be 'America/New_York'
        }
        It 'Converts Windows Pacific to IANA' {
            $result = InModuleScope 'Logic.Monitor' { Resolve-LMTimezoneToIANAId -Timezone 'Pacific Standard Time' }
            $result | Should -Be 'America/Los_Angeles'
        }
        It 'Converts Windows Central to IANA' {
            $result = InModuleScope 'Logic.Monitor' { Resolve-LMTimezoneToIANAId -Timezone 'Central Standard Time' }
            $result | Should -Be 'America/Chicago'
        }
        It 'Converts Windows Mountain to IANA' {
            $result = InModuleScope 'Logic.Monitor' { Resolve-LMTimezoneToIANAId -Timezone 'Mountain Standard Time' }
            $result | Should -Be 'America/Denver'
        }
        It 'Passes through unknown timezone unchanged' {
            $result = InModuleScope 'Logic.Monitor' { Resolve-LMTimezoneToIANAId -Timezone 'Some/Unknown_Zone' }
            $result | Should -Be 'Some/Unknown_Zone'
        }
        It 'Handles UTC' {
            $result = InModuleScope 'Logic.Monitor' { Resolve-LMTimezoneToIANAId -Timezone 'UTC' }
            $result | Should -Be 'UTC'
        }
        It 'Resolves Get-TimeZone StandardName to an IANA ID' {
            $result = InModuleScope 'Logic.Monitor' { Resolve-LMTimezoneToIANAId -Timezone (Get-TimeZone).StandardName }
            $result | Should -Not -BeNullOrEmpty
        }
    }

    Describe 'Test-LMTimezoneId' {
        It 'Accepts IANA timezone' {
            $result = InModuleScope 'Logic.Monitor' { Test-LMTimezoneId -Timezone 'America/New_York' }
            $result | Should -Be $true
        }
        It 'Accepts Windows timezone' {
            $result = InModuleScope 'Logic.Monitor' { Test-LMTimezoneId -Timezone 'Eastern Standard Time' }
            $result | Should -Be $true
        }
        It 'Accepts Get-TimeZone StandardName format' {
            $result = InModuleScope 'Logic.Monitor' { Test-LMTimezoneId -Timezone (Get-TimeZone).StandardName }
            $result | Should -Be $true
        }
        It 'Accepts empty string' {
            $result = InModuleScope 'Logic.Monitor' { Test-LMTimezoneId -Timezone '' }
            $result | Should -Be $true
        }
        It 'Rejects invalid timezone' {
            { InModuleScope 'Logic.Monitor' { Test-LMTimezoneId -Timezone 'Not/A/Real/Timezone' } } | Should -Throw
        }
    }

    Describe 'ConvertTo-LMSDTEpochMillis' {
        It 'Produces same epoch for equivalent IANA and Windows timezones' {
            $TestDate = Get-Date '2026-06-15 14:00:00'
            $ianaResult = InModuleScope 'Logic.Monitor' -Parameters @{ TestDate = $TestDate } {
                ConvertTo-LMSDTEpochMillis -DateTime $TestDate -Timezone 'America/New_York'
            }
            $windowsResult = InModuleScope 'Logic.Monitor' -Parameters @{ TestDate = $TestDate } {
                ConvertTo-LMSDTEpochMillis -DateTime $TestDate -Timezone 'Eastern Standard Time'
            }
            $ianaResult | Should -Be $windowsResult
        }
        It 'Produces different epochs for different timezones with same wall clock time' {
            $TestDate = Get-Date '2026-06-15 14:00:00'
            $easternResult = InModuleScope 'Logic.Monitor' -Parameters @{ TestDate = $TestDate } {
                ConvertTo-LMSDTEpochMillis -DateTime $TestDate -Timezone 'America/New_York'
            }
            $pacificResult = InModuleScope 'Logic.Monitor' -Parameters @{ TestDate = $TestDate } {
                ConvertTo-LMSDTEpochMillis -DateTime $TestDate -Timezone 'America/Los_Angeles'
            }
            ($pacificResult - $easternResult) | Should -Be (3 * 3600 * 1000)
        }
    }
}

Describe 'SDT Testing' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging -SkipCredValidation
    }
    
    Describe 'New-LMDeviceGroupSDT' {
        It 'When given mandatory parameters, returns a created DeviceGroup SDT with matching values' {
            $StartDate = (Get-Date).AddMinutes(5)
            $EndDate = $StartDate.AddHours(1)
            $Script:NewDeviceGroupSDT = New-LMDeviceGroupSDT -DeviceGroupId 1 -StartDate $StartDate -EndDate $EndDate -Timezone "America/New_York" -Comment "DeviceGroupSDT.Build.Test"
            $Script:NewDeviceGroupSDT | Should -Not -BeNullOrEmpty
            $Script:NewDeviceGroupSDT.Comment | Should -Be "DeviceGroupSDT.Build.Test"
            $Script:NewDeviceGroupSDT.Type | Should -Be "ResourceGroupSDT"
            $Script:NewDeviceGroupSDT.Timezone | Should -Be "America/New_York"
        }
    }

    Describe 'New-LMDeviceSDT' {
        It 'When given mandatory parameters with IANA timezone, returns a created Device SDT with matching values' {
            $StartDate = (Get-Date).AddMinutes(5)
            $EndDate = $StartDate.AddHours(1)
            $Script:NewDeviceSDT = New-LMDeviceSDT -DeviceId 123 -StartDate $StartDate -EndDate $EndDate -Timezone "America/New_York" -Comment "DeviceSDT.Build.Test"
            $Script:NewDeviceSDT | Should -Not -BeNullOrEmpty
            $Script:NewDeviceSDT.Comment | Should -Be "DeviceSDT.Build.Test"
            $Script:NewDeviceSDT.Type | Should -Be "ResourceSDT"
            $Script:NewDeviceSDT.Timezone | Should -Be "America/New_York"
        }
        It 'When given a Windows timezone name, converts to IANA and creates SDT successfully' {
            $StartDate = (Get-Date).AddMinutes(5)
            $EndDate = $StartDate.AddHours(1)
            $Script:NewDeviceSDTWindows = New-LMDeviceSDT -DeviceId 123 -StartDate $StartDate -EndDate $EndDate -Timezone "Eastern Standard Time" -Comment "DeviceSDT.Windows.TZ.Test"
            $Script:NewDeviceSDTWindows | Should -Not -BeNullOrEmpty
            $Script:NewDeviceSDTWindows.Comment | Should -Be "DeviceSDT.Windows.TZ.Test"
            $Script:NewDeviceSDTWindows.Type | Should -Be "ResourceSDT"
            $Script:NewDeviceSDTWindows.Timezone | Should -Be "America/New_York"
        }
        It 'When given Get-TimeZone StandardName, creates SDT successfully' {
            $StartDate = (Get-Date).AddMinutes(5)
            $EndDate = $StartDate.AddHours(1)
            $Script:NewDeviceSDTGetTZ = New-LMDeviceSDT -DeviceId 123 -StartDate $StartDate -EndDate $EndDate -Timezone (Get-TimeZone).StandardName -Comment "DeviceSDT.GetTZ.Test"
            $Script:NewDeviceSDTGetTZ | Should -Not -BeNullOrEmpty
            $Script:NewDeviceSDTGetTZ.Comment | Should -Be "DeviceSDT.GetTZ.Test"
            $Script:NewDeviceSDTGetTZ.Type | Should -Be "ResourceSDT"
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
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}