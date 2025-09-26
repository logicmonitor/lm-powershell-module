Describe 'Uptime Device Testing New/Get/Set/Remove' {

    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging -SkipCredValidation

        $script:UptimeDeviceName = "Uptime.Build.Test." + ([guid]::NewGuid().ToString('N').Substring(0, 8))
        $script:UptimeDomain = "uptime-" + ([guid]::NewGuid().ToString('N').Substring(0, 6)) + ".example.com"
    }

    Describe 'New-LMUptimeDevice' {
        It 'When given mandatory parameters, returns a created uptime device with matching values' {
            $script:NewUptimeDevice = New-LMUptimeDevice `
                -Name $script:UptimeDeviceName `
                -GroupIds @('1') `
                -Domain $script:UptimeDomain `
                -Description 'BuildUptimeTest' `
                -TestLocationAll `
                -Properties @{ 'testprop' = 'BuildTest' }

            $script:NewUptimeDevice | Should -Not -BeNullOrEmpty
            $script:NewUptimeDevice.description | Should -BeExactly 'BuildUptimeTest'
            ($script:NewUptimeDevice.customProperties | Where-Object { $_.name -eq 'testprop' }).value | Should -BeExactly 'BuildTest'
        }
    }

    Describe 'Get-LMUptimeDevice' {
        It 'When given no parameters, returns uptime devices' {
            $devices = Get-LMUptimeDevice
            ($devices | Measure-Object).Count | Should -BeGreaterThan 0
        }

        It 'When given an id should return that uptime device' {
            $device = Get-LMUptimeDevice -Id $script:NewUptimeDevice.id
            ($device | Measure-Object).Count | Should -BeExactly 1
            $device.id | Should -BeExactly $script:NewUptimeDevice.id
        }

        It 'When given a name should return devices matching that name' {
            $device = Get-LMUptimeDevice -Name $script:NewUptimeDevice.name
            ($device | Measure-Object).Count | Should -BeExactly 1
            $device[0].name | Should -BeExactly $script:NewUptimeDevice.name
        }

        It 'When given a type parameter should return only matching devices' {
            $devices = Get-LMUptimeDevice -Type webcheck
            ($devices | Where-Object { $_.type -ne 'webcheck' } | Measure-Object).Count | Should -BeExactly 0
        }
    }

    Describe 'Set-LMUptimeDevice' {
        It 'When given a set of parameters, returns an updated uptime device with matching values' {
            { $device = Set-LMUptimeDevice -Id $script:NewUptimeDevice.id -Description 'UpdatedUptime' -GlobalSmAlertCond half -Properties @{ 'testpropupdated' = 'UpdatedValue' } -ErrorAction Stop
                $device.description | Should -BeExactly 'UpdatedUptime'
                $device.globalSmAlertCond | Should -BeExactly 1
                ($device.customProperties | Where-Object { $_.name -eq 'testpropupdated' }).value | Should -BeExactly 'UpdatedValue'
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMUptimeDevice' {
        It 'When given an id, removes the uptime device from LogicMonitor' {
            { Remove-LMUptimeDevice -Id $script:NewUptimeDevice.id -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
            $script:NewUptimeDevice = $null
        }
    }

    AfterAll {
        if ($script:NewUptimeDevice) {
            try { Remove-LMUptimeDevice -Id $script:NewUptimeDevice.id -Confirm:$false -ErrorAction Stop } catch { }
        }
        Disconnect-LMAccount
    }
}

