BeforeAll {
    Import-Module $Module -Force
    . "$PSScriptRoot/Connect-LMTestAccount.ps1"
}

Describe 'Connect-LMAccount with LMv1' {
    It 'Connects successfully with admin level credentials using LMv1 auth' -Skip:($AuthType -eq 'Bearer' -or $CachedAccountName) {
        { Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging -ErrorAction Stop } | Should -Not -Throw
    }
}
Describe 'Connect-LMAccount with BearerToken' {
    It 'Connects successfully with admin level credentials using BearerToken auth' -Skip:($AuthType -eq 'LMv1' -or $CachedAccountName) {
        { Connect-LMAccount -BearerToken $BearerToken -AccountName $AccountName -DisableConsoleLogging -ErrorAction Stop } | Should -Not -Throw
    }
}
Describe 'Connect-LMAccount with CachedAccountName' {
    It 'Connects successfully using a cached account' -Skip:(-not $CachedAccountName) {
        { Connect-LMAccount -CachedAccountName $CachedAccountName -DisableConsoleLogging -ErrorAction Stop } | Should -Not -Throw
    }
}

Describe 'Disconnect-LMAccount' {
    It 'Disconnect should remove auth variables from scope without throwing exception' {
        { Disconnect-LMAccount -ErrorAction Stop } | Should -Not -Throw

    }
}
