BeforeAll {
    Import-Module $Module -Force
    
    # Dot source the validation functions for unit testing
    . "$PSScriptRoot/../Private/Test-LMFilterField.ps1"
    . "$PSScriptRoot/../Private/Format-LMFilter-v1.ps1"
    . "$PSScriptRoot/../Private/Format-LMFilter.ps1"
}

Describe 'Filter Field Validation' {
    
    Context 'Valid Filters - String Format' {
        It 'Should accept valid device filter with correct field names' {
            { Format-LMFilter -Filter "displayName -eq 'test' -and deviceType -eq '0'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should accept valid alert filter with severity and cleared fields' {
            { Format-LMFilter -Filter "severity -eq 'Error' -and cleared -eq 'false'" -ResourcePath "/alert/alerts" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should accept valid device group filter with fullPath field' {
            { Format-LMFilter -Filter "fullPath -eq 'test' -and disableAlerting -eq 'false'" -ResourcePath "/device/groups" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should accept property-based filter (customProperties)' {
            { Format-LMFilter -Filter "customProperties -contains 'test'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should accept property-based filter (systemProperties)' {
            { Format-LMFilter -Filter "systemProperties -contains 'test'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should accept multiple valid operators (-ne, -gt, -lt, -ge, -le, -notcontains)' {
            { Format-LMFilter -Filter "id -ne '0'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
            { Format-LMFilter -Filter "id -gt '100'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
            { Format-LMFilter -Filter "id -lt '1000'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
            { Format-LMFilter -Filter "id -ge '100'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
            { Format-LMFilter -Filter "id -le '1000'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
            { Format-LMFilter -Filter "name -notcontains 'test'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
        }
    }
    
    Context 'Valid Filters - Hashtable Format' {
        It 'Should accept valid hashtable filter with correct fields' {
            { Format-LMFilter -Filter @{displayName="test"; deviceType="0"} -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should accept hashtable filter with single field' {
            { Format-LMFilter -Filter @{name="test"} -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should accept hashtable filter with multiple valid fields' {
            { Format-LMFilter -Filter @{displayName="test"; name="test"; id="123"} -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
        }
    }
    
    Context 'Invalid Filters - Case Sensitivity' {
        It 'Should reject lowercase field name and suggest correct casing' {
            { Format-LMFilter -Filter "displayname -eq 'test'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Throw -ExpectedMessage "*displayName*"
        }
        
        It 'Should reject mixed case typo in field name' {
            { Format-LMFilter -Filter "DisplayName -eq 'test'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Throw -ExpectedMessage "*displayName*"
        }
        
        It 'Should reject all uppercase field name' {
            { Format-LMFilter -Filter "DISPLAYNAME -eq 'test'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Throw
        }
    }
    
    Context 'Invalid Filters - Completely Wrong Field Names' {
        It 'Should reject completely invalid field name in string filter' {
            { Format-LMFilter -Filter "invalidField -eq 'test'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Throw -ExpectedMessage "*Invalid filter field*"
        }
        
        It 'Should reject completely invalid field name in hashtable filter' {
            { Format-LMFilter -Filter @{badFieldName="test"} -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Throw -ExpectedMessage "*Invalid filter field*"
        }
        
        It 'Should reject invalid field even when mixed with valid fields' {
            { Format-LMFilter -Filter "displayName -eq 'test' -and badField -eq 'value'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Throw -ExpectedMessage "*Invalid filter field*"
        }
        
        It 'Should reject multiple invalid fields and list them all' {
            { Format-LMFilter -Filter "badField1 -eq 'test' -and badField2 -eq 'value'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Throw -ExpectedMessage "*Invalid filter field*"
        }
    }
    
    Context 'Invalid Filters - Wrong Endpoint Fields' {
        It 'Should reject device field when used on alert endpoint' {
            { Format-LMFilter -Filter "deviceType -eq '0'" -ResourcePath "/alert/alerts" -ErrorAction Stop } | Should -Throw -ExpectedMessage "*Invalid filter field*"
        }
        
        It 'Should reject alert field when used on device endpoint' {
            { Format-LMFilter -Filter "severity -eq 'Error'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Throw -ExpectedMessage "*Invalid filter field*"
        }
    }
    
    Context 'Error Messages' {
        It 'Should provide helpful error message with field name' {
            try {
                Format-LMFilter -Filter "badField -eq 'test'" -ResourcePath "/device/devices" -ErrorAction Stop
            }
            catch {
                $_.Exception.Message | Should -Match "Invalid filter field"
                $_.Exception.Message | Should -Match "badField"
            }
        }
        
        It 'Should suggest valid fields in error message' {
            try {
                Format-LMFilter -Filter "invalidField -eq 'test'" -ResourcePath "/device/devices" -ErrorAction Stop
            }
            catch {
                $_.Exception.Message | Should -Match "Valid fields for this endpoint include"
            }
        }
        
        It 'Should suggest similar field for typos' {
            try {
                Format-LMFilter -Filter "displayname -eq 'test'" -ResourcePath "/device/devices" -ErrorAction Stop
            }
            catch {
                $_.Exception.Message | Should -Match "Did you mean.*displayName"
            }
        }
    }
    
    Context 'Configuration Loading' {
        It 'Should load validation config successfully' {
            $ConfigPath = "$PSScriptRoot/../Private/LMFilterValidationConfig.psd1"
            $ConfigPath | Should -Exist
            
            $Config = Import-PowerShellDataFile -Path $ConfigPath
            $Config | Should -Not -BeNullOrEmpty
            $Config.Keys.Count | Should -BeGreaterThan 0
        }
        
        It 'Should have device endpoint in config' {
            $ConfigPath = "$PSScriptRoot/../Private/LMFilterValidationConfig.psd1"
            $Config = Import-PowerShellDataFile -Path $ConfigPath
            $Config.ContainsKey('/device/devices') | Should -Be $true
        }
        
        It 'Should have alert endpoint in config' {
            $ConfigPath = "$PSScriptRoot/../Private/LMFilterValidationConfig.psd1"
            $Config = Import-PowerShellDataFile -Path $ConfigPath
            $Config.ContainsKey('/alert/alerts') | Should -Be $true
        }
        
        It 'Should have device group endpoint in config' {
            $ConfigPath = "$PSScriptRoot/../Private/LMFilterValidationConfig.psd1"
            $Config = Import-PowerShellDataFile -Path $ConfigPath
            $Config.ContainsKey('/device/groups') | Should -Be $true
        }
        
        It 'Should have displayName in device fields' {
            $ConfigPath = "$PSScriptRoot/../Private/LMFilterValidationConfig.psd1"
            $Config = Import-PowerShellDataFile -Path $ConfigPath
            $Config['/device/devices'] | Should -Contain 'displayName'
        }
        
        It 'Should have severity in alert fields' {
            $ConfigPath = "$PSScriptRoot/../Private/LMFilterValidationConfig.psd1"
            $Config = Import-PowerShellDataFile -Path $ConfigPath
            $Config['/alert/alerts'] | Should -Contain 'severity'
        }
    }
    
    Context 'Multiple Endpoints' {
        It 'Should validate correctly for device endpoint' {
            { Format-LMFilter -Filter "displayName -eq 'test'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should validate correctly for alert endpoint' {
            { Format-LMFilter -Filter "severity -eq 'Error'" -ResourcePath "/alert/alerts" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should validate correctly for device group endpoint' {
            { Format-LMFilter -Filter "fullPath -eq 'test'" -ResourcePath "/device/groups" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should validate correctly for collector endpoint' {
            { Format-LMFilter -Filter "description -eq 'test'" -ResourcePath "/setting/collector/collectors" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should validate correctly for dashboard endpoint' {
            { Format-LMFilter -Filter "name -eq 'test'" -ResourcePath "/dashboard/dashboards" -ErrorAction Stop } | Should -Not -Throw
        }
    }
    
    Context 'Special Cases' {
        It 'Should handle filters with quoted values containing special characters' {
            { Format-LMFilter -Filter "displayName -eq 'test-device.example.com'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should handle filters with AND logical operator' {
            { Format-LMFilter -Filter "displayName -eq 'test' -and deviceType -eq '0'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should handle filters with OR logical operator' {
            { Format-LMFilter -Filter "displayName -eq 'test' -or displayName -eq 'test2'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should handle complex filters with multiple conditions' {
            { Format-LMFilter -Filter "displayName -eq 'test' -and deviceType -eq '0' -or name -eq 'test'" -ResourcePath "/device/devices" -ErrorAction Stop } | Should -Not -Throw
        }
    }
}

Describe 'Filter Validation Config Generator' {
    
    Context 'Build-LMFilterValidationConfig Script' {
        It 'Should exist in root directory' {
            "$PSScriptRoot/../Build-LMFilterValidationConfig.ps1" | Should -Exist
        }
        
        It 'Should be a valid PowerShell script' {
            $ScriptContent = Get-Content "$PSScriptRoot/../Build-LMFilterValidationConfig.ps1" -Raw
            { [scriptblock]::Create($ScriptContent) } | Should -Not -Throw
        }
    }
    
    Context 'Generated Config File' {
        It 'Should exist in Private directory' {
            "$PSScriptRoot/../Private/LMFilterValidationConfig.psd1" | Should -Exist
        }
        
        It 'Should be a valid PowerShell data file' {
            { Import-PowerShellDataFile "$PSScriptRoot/../Private/LMFilterValidationConfig.psd1" -ErrorAction Stop } | Should -Not -Throw
        }
        
        It 'Should contain hashtable structure' {
            $Config = Import-PowerShellDataFile "$PSScriptRoot/../Private/LMFilterValidationConfig.psd1"
            $Config | Should -BeOfType [hashtable]
        }
        
        It 'Should have multiple endpoints configured' {
            $Config = Import-PowerShellDataFile "$PSScriptRoot/../Private/LMFilterValidationConfig.psd1"
            $Config.Keys.Count | Should -BeGreaterThan 10
        }
        
        It 'Should have arrays of field names for each endpoint' {
            $Config = Import-PowerShellDataFile "$PSScriptRoot/../Private/LMFilterValidationConfig.psd1"
            foreach ($endpoint in $Config.Keys) {
                # PowerShell data files with single items may be strings, so ensure it's an array
                $fields = @($Config[$endpoint])
                $fields | Should -Not -BeNullOrEmpty
                $fields.Count | Should -BeGreaterThan 0
            }
        }
    }
}



