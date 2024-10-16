Describe 'NetScanGroup Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging -SkipCredValidation
    }
    
    Describe 'New-LMNetScanGroup' {
        It 'When given mandatory parameters, returns a created NetScan group with matching values' {
            $Script:NewNetScanGroup = New-LMNetScanGroup -Name "NetScanGroup.Build.Test" -Description "BuildTest"
            $Script:NewNetScanGroup | Should -Not -BeNullOrEmpty
            $Script:NewNetScanGroup.Name | Should -Be "NetScanGroup.Build.Test"
            $Script:NewNetScanGroup.Description | Should -Be "BuildTest"
        }
    }
    
    Describe 'Get-LMNetScanGroup' {
        It 'When given no parameters, returns all NetScan groups' {
            $NetScanGroup = Get-LMNetScanGroup
            ($NetScanGroup | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that NetScan group' {
            $NetScanGroup = Get-LMNetScanGroup -Id $Script:NewNetScanGroup.Id
            ($NetScanGroup | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a name should return specified NetScan group matching that name' {
            $NetScanGroup = Get-LMNetScanGroup -Name $Script:NewNetScanGroup.Name
            ($NetScanGroup | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a wildcard name should return all NetScan groups matching that wildcard value' {
            $NetScanGroup = Get-LMNetScanGroup -Name "$(($Script:NewNetScanGroup.Name.Split(".")[0]))*"
            ($NetScanGroup | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an invalid id, should throw an error' {
            { Get-LMNetScanGroup -Id 0 -ErrorAction Stop } | Should -Throw
        }
    }

    Describe 'Set-LMNetScanGroup' {
        It 'When given a set of parameters, returns an updated NetScan group with matching values' {
            { $NetScanGroup = Set-LMNetScanGroup -Id $Script:NewNetScanGroup.Id -Description "Updated" -NewName "NetScanGroup.Build.Test.Updated" -ErrorAction Stop
                $NetScanGroup.Description | Should -Be "Updated"
                $NetScanGroup.Name | Should -Be "NetScanGroup.Build.Test.Updated"
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMNetScanGroup' {
        It 'When given an id, remove the NetScan group from logic monitor' {
            { Remove-LMNetScanGroup -Id $Script:NewNetScanGroup.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}