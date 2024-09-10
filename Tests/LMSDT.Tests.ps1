Describe 'SDT Testing' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging -SkipCredValidation
    }
    
    Describe 'New-LMDeviceGroupSDT' {
        It 'When given mandatory parameters, returns a created DeviceGroup SDT with matching values' {
            $StartDate = (Get-Date).AddMinutes(5)
            $EndDate = $StartDate.AddHours(1)
            $Script:NewDeviceGroupSDT = New-LMDeviceGroupSDT -DeviceGroupId 1 -StartDate $StartDate -EndDate $EndDate -Comment "DeviceGroupSDT.Build.Test"
            $Script:NewDeviceGroupSDT | Should -Not -BeNullOrEmpty
            $Script:NewDeviceGroupSDT.Comment | Should -Be "DeviceGroupSDT.Build.Test"
            $Script:NewDeviceGroupSDT.Type | Should -Be "ResourceGroupSDT"
        }
    }

    Describe 'New-LMDeviceSDT' {
        It 'When given mandatory parameters, returns a created Device SDT with matching values' {
            $StartDate = (Get-Date).AddMinutes(5)
            $EndDate = $StartDate.AddHours(1)
            $Script:NewDeviceSDT = New-LMDeviceSDT -DeviceId 123 -StartDate $StartDate -EndDate $EndDate -Comment "DeviceSDT.Build.Test"
            $Script:NewDeviceSDT | Should -Not -BeNullOrEmpty
            $Script:NewDeviceSDT.Comment | Should -Be "DeviceSDT.Build.Test"
            $Script:NewDeviceSDT.Type | Should -Be "ResourceSDT"
        }
    }

    Describe 'Get-LMDeviceGroupSDT' {
        It 'When given a DeviceGroupId, returns SDTs for that group' {
            $SDTs = Get-LMDeviceGroupSDT -Id 1
            $SDTs | Should -Not -BeNullOrEmpty
            $SDTs.Count | Should -BeGreaterThan 0
        }
    }

    Describe 'Get-LMDeviceSDT' {
        It 'When given a DeviceId, returns SDTs for that device' {
            $SDTs = Get-LMDeviceSDT -Id 123
            $SDTs | Should -Not -BeNullOrEmpty
            $SDTs.Count | Should -BeGreaterThan 0
        }
    }

    Describe 'Get-LMSDT' {
        It 'When given no parameters, returns all SDTs' {
            $SDT = Get-LMSDT
            $SDT | Should -Not -BeNullOrEmpty
            $SDT.Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that SDT' {
            $SDT = Get-LMSDT -Id $Script:NewDeviceGroupSDT.Id
            $SDT | Should -Not -BeNullOrEmpty
            $SDT.Count | Should -BeExactly 1
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
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}