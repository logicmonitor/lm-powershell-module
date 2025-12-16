Describe 'ConvertTo-LMUptimeDevice Testing' -Skip {

    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging -SkipCredValidation

        $script:SourceWebsite = New-LMWebsite -Name ("Website.Uptime.Migration." + ([guid]::NewGuid().ToString('N').Substring(0, 8))) -IsInternal $true -Webcheck -WebsiteDomain 'migration.example.com' -Description 'MigrationTest' -Properties @{ 'migrate' = 'true' } -TestLocationCollectorIds @($PreferredCollectorId)
    }

    Describe 'ConvertTo-LMUptimeDevice' {
        It 'Creates an uptime device from an existing website' {
            $targetGroups = @('1')
            $result = $script:SourceWebsite | ConvertTo-LMUptimeDevice -TargetHostGroupIds $targetGroups -NameSuffix '-uptime'

            $result | Should -Not -BeNullOrEmpty
            $result.Name | Should -BeExactly ($script:SourceWebsite.name + '-uptime')
            $result.hostGroupIds.split(',') | Should -Contain '4982' #Dynamic group for Uptime Devices

            # Cleanup created uptime device
            Try { Remove-LMUptimeDevice -Id $result.id -Confirm:$false -HardDelete $true -ErrorAction Stop } Catch { }
        }

        It 'Disables the source website when DisableSourceAlerting is specified' {
            $targetGroups = @('1')
            $site = Get-LMWebsite -Id $script:SourceWebsite.Id
            $site.disableAlerting | Should -BeFalse

            $result = $site | ConvertTo-LMUptimeDevice -TargetHostGroupIds $targetGroups -DisableSourceAlerting -NameSuffix '-uptime2'
            $result | Should -Not -BeNullOrEmpty

            $updatedSite = Get-LMWebsite -Id $script:SourceWebsite.Id
            $updatedSite.disableAlerting | Should -BeTrue

            Try { Remove-LMUptimeDevice -Id $result.id -Confirm:$false -HardDelete $true -ErrorAction Stop } Catch { }
        }
    }

    AfterAll {
        if ($script:SourceWebsite) {
            try { Remove-LMWebsite -Id $script:SourceWebsite.Id -Confirm:$false -ErrorAction Stop } catch { }
        }
        Disconnect-LMAccount
    }
}

