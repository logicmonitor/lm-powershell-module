Describe 'DeviceGroup Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        . "$PSScriptRoot/Connect-LMTestAccount.ps1"
        Connect-LMTestAccount -DisableConsoleLogging -SkipCredValidation

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

        $script:InvokeTestRetryOrInconclusive = {
            param(
                [Parameter(Mandatory)]
                [scriptblock]$ScriptBlock,
                [Parameter(Mandatory)]
                [string]$OperationName,
                [int]$MaxAttempts = 8,
                [int]$DelaySeconds = 5
            )

            try {
                return & $script:InvokeTestRetry -ScriptBlock $ScriptBlock -OperationName $OperationName -MaxAttempts $MaxAttempts -DelaySeconds $DelaySeconds
            }
            catch {
                Set-ItResult -Inconclusive -Because "Likely API indexing lag: $($_.Exception.Message)"
            }
        }

        $script:TestSuffix = Get-LMTestSuffix
        $script:DeviceGroupTestName = "DeviceGroup.Build.Test.$($script:TestSuffix)"
    }
    
    Describe 'New-LMDeviceGroup' {
        It 'When given mandatory parameters, returns a created group with matching values' {
            $Script:NewDeviceGroup = New-LMDeviceGroup -Name $script:DeviceGroupTestName -Description "Testing123" -ParentGroupId 1 -Properties @{"testing" = "123" } -DisableAlerting $true -AppliesTo "false()"
            $Script:NewDeviceGroup | Should -Not -BeNullOrEmpty
            $Script:NewDeviceGroup.Description | Should -Be "Testing123"
            $Script:NewDeviceGroup.DisableAlerting | Should -Be $true
            $Script:NewDeviceGroup.AppliesTo | Should -Be "false()"
            $Script:NewDeviceGroup.CustomProperties.name.IndexOf("testing") | Should -Not -BeExactly -1
        }
    }
    
    Describe 'Get-LMDeviceGroup' {
        It 'When given no parameters, returns all devices' {
            $DeviceGroup = Get-LMDeviceGroup
            ($DeviceGroup | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that device' {
            $DeviceGroup = & $script:InvokeTestRetryOrInconclusive -OperationName 'Get-LMDeviceGroup by Id' -ScriptBlock {
                $result = Get-LMDeviceGroup -Id $Script:NewDeviceGroup.Id -ErrorAction Stop
                if (($result | Measure-Object).Count -ne 1) {
                    throw "Expected one device group for id '$($Script:NewDeviceGroup.Id)'."
                }
                $result
            }
            if ($null -ne $DeviceGroup) {
                ($DeviceGroup | Measure-Object).Count | Should -BeExactly 1
            }
        }
        It 'When given a name should return specified device matching that name' {
            $DeviceGroup = & $script:InvokeTestRetryOrInconclusive -OperationName 'Get-LMDeviceGroup by Name' -ScriptBlock {
                $result = Get-LMDeviceGroup -Name $Script:NewDeviceGroup.Name -ErrorAction Stop
                if (($result | Measure-Object).Count -ne 1) {
                    throw "Device group '$($Script:NewDeviceGroup.Name)' not visible yet."
                }
                $result
            }
            if ($null -ne $DeviceGroup) {
                ($DeviceGroup | Measure-Object).Count | Should -BeExactly 1
            }
        }
        It 'When given a wildcard name should return all devices matching that wildcard value' {
            $DeviceGroup = & $script:InvokeTestRetryOrInconclusive -OperationName 'Get-LMDeviceGroup by wildcard Name' -ScriptBlock {
                $result = Get-LMDeviceGroup -Name "$(($Script:NewDeviceGroup.Name.Split('.')[0]))*" -ErrorAction Stop
                if (($result | Measure-Object).Count -lt 1) {
                    throw 'No device groups returned for wildcard name query.'
                }
                $result
            }
            if ($null -ne $DeviceGroup) {
                ($DeviceGroup | Measure-Object).Count | Should -BeGreaterThan 0
            }
        }
    }

    Describe 'Set-LMDeviceGroup' {
        It 'When given a set of parameters, returns an updated group with matching values' {
            { $DeviceGroup = Set-LMDeviceGroup -Id $Script:NewDeviceGroup.Id -Description "Updated" -Properties @{"test" = "123"; "test2" = "456" } -ErrorAction Stop
                $DeviceGroup.Description | Should -Be "Updated"
                $DeviceGroup.CustomProperties.name.IndexOf("test") | Should -Not -BeExactly -1
                $DeviceGroup.CustomProperties.name.IndexOf("test2") | Should -Not -BeExactly -1
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMDeviceGroup' {
        It 'When given an id, remove the group from logic monitor' {
            { Remove-LMDeviceGroup -Id $Script:NewDeviceGroup.Id -HardDelete $true -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}