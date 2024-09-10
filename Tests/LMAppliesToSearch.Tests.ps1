Describe 'AppliesToQuery Testing' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging -SkipCredValidation
    }
    
    Describe 'Test-LMAppliesToQuery' {
        It 'When given a valid query, returns matching devices' {
            $Query = 'system.hostname =~ "lm*"'
            $Result = Test-LMAppliesToQuery -Query $Query
            $Result | Should -Not -BeNullOrEmpty
            $Result.Count | Should -BeGreaterThan 0
        }

        It 'When given an invalid query, throws an error' {
            $Query = 'invalid_property ~= "value"'
            { Test-LMAppliesToQuery -Query $Query -ErrorAction Stop } | Should -Throw
        }

        It 'When given a query that matches no devices, returns an empty result' {
            $Query = 'system.hostname == "non_existent_hostname"'
            $Result = Test-LMAppliesToQuery -Query $Query
            $Result | Should -BeNullOrEmpty
        }

        It 'When given a complex query, returns correct results' {
            $Query = 'system.hostname =~ "^lm" && system.displayname =~ "^lm"'
            $Result = Test-LMAppliesToQuery -Query $Query
            $Result | Should -Not -BeNullOrEmpty
            $Result | ForEach-Object { $_.name | Should -BeLike 'lm*' }
        }
    }

    AfterAll {
        Disconnect-LMAccount
    }
}