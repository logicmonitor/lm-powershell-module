Describe 'AccessGroup Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging  -SkipCredValidation
    }
    
    Describe 'New-LMAccessGroup' {
        It 'When given mandatory parameters, returns a created access group with matching values' {
            $Script:NewAccessGroup = New-LMAccessGroup -Name "AccessGroup.Build.Test" -Description "BuildTest"
            $Script:NewAccessGroup | Should -Not -BeNullOrEmpty
            $Script:NewAccessGroup.Name | Should -Be "AccessGroup.Build.Test"
            $Script:NewAccessGroup.Description | Should -Be "BuildTest"
        }
    }
    
    Describe 'Get-LMAccessGroup' {
        It 'When given no parameters, returns all access groups' {
            $AccessGroup = Get-LMAccessGroup
            ($AccessGroup | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that access group' {
            $AccessGroup = Get-LMAccessGroup -Id $Script:NewAccessGroup.Id
            ($AccessGroup | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a name should return specified access group matching that name' {
            $AccessGroup = Get-LMAccessGroup -Name $Script:NewAccessGroup.Name
            ($AccessGroup | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a wildcard name should return all access groups matching that wildcard value' {
            $AccessGroup = Get-LMAccessGroup -Name "$(($Script:NewAccessGroup.Name.Split(".")[0]))*"
            ($AccessGroup | Measure-Object).Count | Should -BeGreaterThan 0
        }
    }

    Describe 'Set-LMAccessGroup' {
        It 'When given a set of parameters, returns an updated access group with matching values' {
            { $AccessGroup = Set-LMAccessGroup -Id $Script:NewAccessGroup.Id -Description "Updated" -NewName "AccessGroup.Build.Test.Updated" -ErrorAction Stop
                $AccessGroup.Description | Should -Be "Updated"
                $AccessGroup.Name | Should -Be "AccessGroup.Build.Test.Updated"
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMAccessGroup' {
        It 'When given an id, remove the access group from logic monitor' {
            { Remove-LMAccessGroup -Id $Script:NewAccessGroup.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}
