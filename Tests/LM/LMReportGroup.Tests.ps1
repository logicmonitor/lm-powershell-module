Describe 'ReportGroup Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        . "$PSScriptRoot/Connect-LMTestAccount.ps1"
        Connect-LMTestAccount -DisableConsoleLogging -SkipCredValidation

        $script:TestSuffix = Get-LMTestSuffix
        $script:ReportGroupTestName = "ReportGroup.Build.Test.$($script:TestSuffix)"
        $script:ReportGroupUpdatedName = "ReportGroup.Build.Test.$($script:TestSuffix).Updated"
    }
    
    Describe 'New-LMReportGroup' {
        It 'When given mandatory parameters, returns a created Report group with matching values' {
            $Script:NewReportGroup = New-LMReportGroup -Name $script:ReportGroupTestName -Description "BuildTest"
            $Script:NewReportGroup | Should -Not -BeNullOrEmpty
            $Script:NewReportGroup.Name | Should -Be $script:ReportGroupTestName
            $Script:NewReportGroup.Description | Should -Be "BuildTest"
        }
    }
    
    Describe 'Get-LMReportGroup' {
        It 'When given no parameters, returns all Report groups' {
            $ReportGroup = Get-LMReportGroup
            ($ReportGroup | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that Report group' {
            $ReportGroup = Get-LMReportGroup -Id $Script:NewReportGroup.Id
            ($ReportGroup | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a name should return specified Report group matching that name' {
            $ReportGroup = Get-LMReportGroup -Name $Script:NewReportGroup.Name
            ($ReportGroup | Measure-Object).Count | Should -BeExactly 1
        }
        It 'When given a wildcard name should return all Report groups matching that wildcard value' {
            $ReportGroup = Get-LMReportGroup -Name "$(($Script:NewReportGroup.Name.Split(".")[0]))*"
            ($ReportGroup | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an invalid id, should throw an error' {
            { Get-LMReportGroup -Id -1 -ErrorAction Stop } | Should -Throw
        }
    }

    Describe 'Set-LMReportGroup' {
        It 'When given a set of parameters, returns an updated Report group with matching values' {
            { $ReportGroup = Set-LMReportGroup -Id $Script:NewReportGroup.Id -Description "Updated" -NewName $script:ReportGroupUpdatedName -ErrorAction Stop
                $ReportGroup.Description | Should -Be "Updated"
                $ReportGroup.Name | Should -Be $script:ReportGroupUpdatedName
            } | Should -Not -Throw
        }
    }

    Describe 'Remove-LMReportGroup' {
        It 'When given an id, remove the Report group from logic monitor' {
            { Remove-LMReportGroup -Id $Script:NewReportGroup.Id -ErrorAction Stop -Confirm:$false } | Should -Not -Throw
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}