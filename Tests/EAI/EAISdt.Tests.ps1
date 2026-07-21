BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Get-EAISdt' {
    BeforeEach {
        Disconnect-EAIAccount
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAIAuth.AccessToken = 'test-token' | ConvertTo-SecureString -AsPlainText -Force
            $Script:EAIAuth.TokenExpiresAt = (Get-Date).ToUniversalTime().AddHours(1)
        }
    }

    It 'Requires an active Edwin connection' {
        Disconnect-EAIAccount

        { Get-EAISdt -ErrorAction Stop } | Should -Throw
    }

    It 'Retrieves scheduled downtimes from Edwin' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod {
                param($Headers)
                $script:capturedHeaders = $Headers
                return @(
                    [PSCustomObject]@{
                        id      = 'schedule-1'
                        comment = 'Maintenance window'
                    }
                    [PSCustomObject]@{
                        id      = 'schedule-2'
                        comment = 'Change freeze'
                    }
                )
            }

            $results = Get-EAISdt

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/action/sdt' -and
                $Method -eq 'GET'
            }

            $script:capturedHeaders.Authorization | Should -Be 'Bearer test-token'

            $results.Count | Should -Be 2
            $results[0].comment | Should -Be 'Maintenance window'
            $results[0].PSObject.TypeNames[0] | Should -Be 'Edwin.SDT'
        }
    }

    It 'Returns an empty array when Edwin has no schedules' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return @() }

            $results = Get-EAISdt

            @($results).Count | Should -Be 0
        }
    }
}
