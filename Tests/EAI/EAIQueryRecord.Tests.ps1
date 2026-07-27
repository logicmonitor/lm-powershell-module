BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Get-EAIQueryRecord' {
    BeforeEach {
        Disconnect-EAIAccount
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAIAuth.AccessToken = 'test-token' | ConvertTo-SecureString -AsPlainText -Force
            $Script:EAIAuth.TokenExpiresAt = (Get-Date).ToUniversalTime().AddHours(1)
        }
    }

    It 'Requires an authenticated Edwin session' {
        Disconnect-EAIAccount
        InModuleScope -ModuleName $script:DevModuleName {
            { Get-EAIQueryRecord -RecordType events -RecordId 'abc' -ErrorAction Stop } | Should -Throw
        }
    }

    It 'Gets a record with an encoded path for IDs containing slashes' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod {
                return [PSCustomObject]@{
                    meta    = [PSCustomObject]@{ recordType = 'events'; count = 1 }
                    results = @([PSCustomObject]@{ _id = 'eventId/12345abc' })
                }
            }

            $record = Get-EAIQueryRecord -RecordType events -RecordId 'eventId/12345abc'

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/ui/query/record/events/eventId%2F12345abc' -and
                $Method -eq 'GET'
            }

            $record.PSTypeNames | Should -Contain 'Edwin.Event'
            $record._id | Should -Be 'eventId/12345abc'
        }
    }

    It 'Returns the full response envelope with -AsResponse' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod {
                return [PSCustomObject]@{
                    meta    = [PSCustomObject]@{ recordType = 'events'; count = 1 }
                    results = @([PSCustomObject]@{ _id = 'abc' })
                }
            }

            $response = Get-EAIQueryRecord -RecordType events -RecordId 'abc' -AsResponse

            $response.PSTypeNames | Should -Contain 'Edwin.Query.Response'
            $response.results[0]._id | Should -Be 'abc'
        }
    }

    It 'Rejects an empty RecordId' {
        InModuleScope -ModuleName $script:DevModuleName {
            { Get-EAIQueryRecord -RecordType events -RecordId ' ' } | Should -Throw '*RecordId is required*'
        }
    }
}
