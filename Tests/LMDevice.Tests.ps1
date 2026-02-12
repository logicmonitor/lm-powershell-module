Describe 'Device Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging -SkipCredValidation

        $script:InvokeTestRetry = {
            param(
                [Parameter(Mandatory)]
                [scriptblock]$ScriptBlock,
                [Parameter(Mandatory)]
                [string]$OperationName,
                [int]$MaxAttempts = 8,
                [int]$DelaySeconds = 5
            )

            $lastError = $null

            for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
                try {
                    return & $ScriptBlock
                }
                catch {
                    $lastError = $_

                    if ($attempt -lt $MaxAttempts) {
                        Start-Sleep -Seconds $DelaySeconds
                    }
                }
            }

            throw "$OperationName failed after $MaxAttempts attempts. Last error: $($lastError.Exception.Message)"
        }

        $script:DeviceTestSuffix = [guid]::NewGuid().ToString('N').Substring(0, 8)
        $script:DeviceTestName = "device-build-test-$($script:DeviceTestSuffix).example.com"
        $script:DeviceTestDisplayName = "Device.Build.Test.$($script:DeviceTestSuffix)"
    }
    
    Describe 'New-LMDevice' {
        It 'When given mandatory parameters, returns a created resource with matching values' {
            $Script:NewDevice = New-LMDevice -Name $script:DeviceTestName -DisplayName $script:DeviceTestDisplayName -PreferredCollectorId $PreferredCollectorId -DisableAlerting $true
            $Script:NewDevice | Should -Not -BeNullOrEmpty

            & $script:InvokeTestRetry -OperationName 'Get-LMDevice by Id for newly created device' -ScriptBlock {
                $device = Get-LMDevice -Id $Script:NewDevice.Id -ErrorAction Stop
                if (($device | Measure-Object).Count -ne 1) {
                    throw "Device '$($Script:NewDevice.Id)' is not queryable yet."
                }
            } | Out-Null
        }
    }

    Describe 'New-LMDeviceProperty' {
        It 'When given mandatory parameters, returns a created property with matching values' {
            $DeviceProp = New-LMDeviceProperty -Id $Script:NewDevice.Id -PropertyName "newpropname" -PropertyValue "NewPropValue"
            $DeviceProp | Should -Not -BeNullOrEmpty
            $DeviceProp.name | Should -BeLike "newpropname"
            $DeviceProp.value | Should -BeLike "NewPropValue"
        }
    }

    Describe 'Get-LMDeviceProperty' {
        It 'When given mandatory parameters, returns a specified property' {
            $DeviceProp = Get-LMDeviceProperty -Id $Script:NewDevice.Id -PropertyName "newpropname"
            $DeviceProp | Should -Not -BeNullOrEmpty
            $DeviceProp.name | Should -BeLike "newpropname"
        }
    }

    Describe 'Set-LMDeviceProperty' {
        It 'When given mandatory parameters, returns a updated property with matching values' {
            $DeviceProp = Set-LMDeviceProperty -Id $Script:NewDevice.Id -PropertyName "newpropname" -PropertyValue "UpdatedPropValue"
            $DeviceProp | Should -Not -BeNullOrEmpty
            $DeviceProp.name | Should -BeLike "newpropname"
            $DeviceProp.value | Should -BeLike "UpdatedPropValue"
        }
    }

    Describe 'Remove-LMDeviceProperty' {
        It 'When given an id, remove the device property from resource' {
            { Remove-LMDeviceProperty -Id $Script:NewDevice.Id -PropertyName "newpropname" -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
        }
    }
    
    Describe 'Get-LMDevice' {
        It 'When given no parameters, returns all devices' {
            $Device = Get-LMDevice
            ($Device | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that device' {
            $Device = & $script:InvokeTestRetry -OperationName 'Get-LMDevice by Id' -ScriptBlock {
                $result = Get-LMDevice -Id $Script:NewDevice.Id -ErrorAction Stop
                if (($result | Measure-Object).Count -ne 1) {
                    throw "Expected one device for id '$($Script:NewDevice.Id)'."
                }
                $result
            }
            ($Device | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a name should return all devices matching that name' {
            $Device = & $script:InvokeTestRetry -OperationName 'Get-LMDevice by Name' -ScriptBlock {
                $result = Get-LMDevice -Name $Script:NewDevice.Name -ErrorAction Stop
                if (($result | Measure-Object).Count -lt 1) {
                    throw "Device '$($Script:NewDevice.Name)' not visible yet."
                }
                $result
            }
            ($Device | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a wildcard displayname should return all devices matching that wildcard value' {
            $Device = & $script:InvokeTestRetry -OperationName 'Get-LMDevice by wildcard DisplayName' -ScriptBlock {
                $result = Get-LMDevice -DisplayName "$(($Script:NewDevice.DisplayName.Split(".")[0]))*" -ErrorAction Stop
                if (($result | Measure-Object).Count -lt 1) {
                    throw "No devices returned for wildcard display name query."
                }
                $result
            }
            ($Device | Measure-Object).Count | Should -BeGreaterThan 0
        }
    }

    Describe 'Set-LMDevice' {
        It 'When given a set of parameters, returns an updated resource with matching values' {
            { $Device = Set-LMDevice -Id $Script:NewDevice.Id -Description "Updated" -Properties @{"test" = "123"; "test2" = "456" } -ErrorAction Stop
                $Device.Description | Should -Be "Updated"
                $Device.CustomProperties.name.IndexOf("test") | Should -Not -BeExactly -1
                $Device.CustomProperties.name.IndexOf("test2") | Should -Not -BeExactly -1
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMDevice' {
        It 'When given an id, remove the device from logic monitor' {
            { Remove-LMDevice -Id $Script:NewDevice.Id -HardDelete $true -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}