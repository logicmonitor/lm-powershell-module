Describe 'Uptime Device Testing New/Get/Set/Remove' {

    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging -SkipCredValidation

        $script:UptimeDeviceName = "Uptime.Build.Test." + ([guid]::NewGuid().ToString('N').Substring(0, 8))
        $script:UptimeDomain = "uptime-" + ([guid]::NewGuid().ToString('N').Substring(0, 6)) + ".example.com"
        $script:UptimePingHost = "ping-" + ([guid]::NewGuid().ToString('N').Substring(0, 6)) + ".example.com"
    }

    Describe 'New-LMUptimeDevice' {
        It 'When given mandatory parameters for WebExternal, returns a created uptime device with matching values' {
            $script:NewUptimeDevice = New-LMUptimeDevice `
                -Name $script:UptimeDeviceName `
                -HostGroupIds @('1') `
                -Domain $script:UptimeDomain `
                -Description 'BuildUptimeTest' `
                -TestLocationSmgIds @(2, 3) `
                -Properties @{ 'testprop' = 'BuildTest' }

            $script:NewUptimeDevice | Should -Not -BeNullOrEmpty
            $script:NewUptimeDevice.description | Should -BeExactly 'BuildUptimeTest'
            $script:NewUptimeDevice.deviceType | Should -Be 18
            ($script:NewUptimeDevice.customProperties | Where-Object { $_.name -eq 'testprop' }).value | Should -BeExactly 'BuildTest'
        }

        It 'When given PingExternal parameters, returns a ping uptime device' {
            $script:NewPingDevice = New-LMUptimeDevice `
                -Name ("Ping." + $script:UptimeDeviceName) `
                -HostGroupIds @('1') `
                -Hostname $script:UptimePingHost `
                -Description 'BuildPingTest' `
                -TestLocationSmgIds @(2, 3)

            $script:NewPingDevice | Should -Not -BeNullOrEmpty
            $script:NewPingDevice.deviceType | Should -Be 19
        }

        It 'When given invalid PollingInterval, should throw validation error' {
            { New-LMUptimeDevice `
                -Name "InvalidPolling" `
                -HostGroupIds @('1') `
                -Domain "invalid.example.com" `
                -TestLocationSmgIds @(2) `
                -PollingInterval 30 } | Should -Throw
        }

        It 'When given invalid PercentPktsNotReceiveInTime, should throw validation error' {
            { New-LMUptimeDevice `
                -Name "InvalidPercent" `
                -HostGroupIds @('1') `
                -Hostname "invalid.example.com" `
                -TestLocationSmgIds @(2) `
                -PercentPktsNotReceiveInTime 15 } | Should -Throw
        }
    }

    Describe 'Get-LMUptimeDevice' {
        It 'When given type parameter, returns uptime devices of that type' {
            $devices = Get-LMUptimeDevice -Type uptimewebcheck
            ($devices | Measure-Object).Count | Should -BeGreaterThan 0
        }

        It 'When given an id should return that uptime device' {
            $device = Get-LMUptimeDevice -Id $script:NewUptimeDevice.id -Type uptimewebcheck
            ($device | Measure-Object).Count | Should -BeExactly 1
            $device.id | Should -BeExactly $script:NewUptimeDevice.id
        }

        It 'When given a name should return devices matching that name' {
            $device = Get-LMUptimeDevice -Name $script:NewUptimeDevice.name -Type uptimewebcheck
            ($device | Measure-Object).Count | Should -BeExactly 1
            $device[0].name | Should -BeExactly $script:NewUptimeDevice.name
        }

        It 'When given uptimewebcheck type parameter should return only matching devices' {
            $devices = Get-LMUptimeDevice -Type uptimewebcheck
            ($devices | Where-Object { $_.deviceType -ne '18' } | Measure-Object).Count | Should -BeExactly 0
            ($devices | Where-Object { $_.deviceType -eq '18' } | Measure-Object).Count | Should -BeGreaterThan 1
        }

        It 'When given uptimepingcheck type parameter should return only matching devices' {
            $devices = Get-LMUptimeDevice -Type uptimepingcheck
            ($devices | Where-Object { $_.deviceType -ne '19' } | Measure-Object).Count | Should -BeExactly 0
        }
    }

    Describe 'Set-LMUptimeDevice' {
        It 'When given a set of parameters, returns an updated uptime device with matching values' {
            { $device = Set-LMUptimeDevice -Id $script:NewUptimeDevice.id -Type uptimewebcheck -Description 'UpdatedUptime' -GlobalSmAlertCond half -Properties @{ 'testpropupdated' = 'UpdatedValue' } -ErrorAction Stop
                $device.description | Should -BeExactly 'UpdatedUptime'
                ($device.customProperties | Where-Object { $_.name -eq 'testpropupdated' }).value | Should -BeExactly 'UpdatedValue'
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMUptimeDevice' {
        It 'When given an id, removes the uptime device from LogicMonitor' {
            { Remove-LMUptimeDevice -Id $script:NewUptimeDevice.id -Confirm:$false -HardDelete $true -ErrorAction Stop } | Should -Not -Throw
            $script:NewUptimeDevice = $null
        }

        It 'When given a name, removes the uptime device from LogicMonitor' {
            if ($script:NewPingDevice) {
                { Remove-LMUptimeDevice -Name $script:NewPingDevice.name -Confirm:$false -HardDelete $true -ErrorAction Stop } | Should -Not -Throw
                $script:NewPingDevice = $null
            }
        }

        It 'When given a non-existent name, returns an error' {
            { Remove-LMUptimeDevice -Name "NonExistentDevice12345" -Confirm:$false -ErrorAction Stop } | Should -Throw
        }
    }

    AfterAll {
        if ($script:NewUptimeDevice) {
            try { Remove-LMUptimeDevice -Id $script:NewUptimeDevice.id -Confirm:$false -HardDelete $true -ErrorAction Stop } catch { }
        }
        if ($script:NewPingDevice) {
            try { Remove-LMUptimeDevice -Id $script:NewPingDevice.id -Confirm:$false -HardDelete $true -ErrorAction Stop } catch { }
        }
        Disconnect-LMAccount
    }
}

