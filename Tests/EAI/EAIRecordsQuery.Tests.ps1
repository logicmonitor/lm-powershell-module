BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Invoke-EAIRecordsQuery' {
    BeforeEach {
        $ConfirmPreference = 'None'
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
            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }
            { Invoke-EAIRecordsQuery -RecordType events -Field '_id' -Filter $filter -ErrorAction Stop } |
                Should -Throw
        }
    }

    It 'Queries with UI defaults when Field and Filter are omitted' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod {
                return [PSCustomObject]@{
                    meta    = [PSCustomObject]@{ recordType = 'events'; count = 0 }
                    results = @()
                }
            }

            Invoke-EAIRecordsQuery -RecordType events -Confirm:$false | Out-Null

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Body -match '"fields"\s*:\s*null' -and
                $Body -match 'meta.eventTimestamp' -and
                $Body -match '"type"\s*:\s*"desc"'
            }
        }
    }

    It 'Posts with the UI default filter when Filter is omitted' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod {
                return [PSCustomObject]@{
                    meta    = [PSCustomObject]@{ recordType = 'events'; count = 0 }
                    results = @()
                }
            }

            Invoke-EAIRecordsQuery -RecordType events -Field '_id' -Confirm:$false | Out-Null

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Body -match 'meta.eventTimestamp' -and $Body -match 'meta.insightType'
            }
        }
    }

    It 'Uses projected typename when -Field is specified' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod {
                return [PSCustomObject]@{
                    meta    = [PSCustomObject]@{ recordType = 'events'; count = 1 }
                    results = @([PSCustomObject]@{ _id = 'abc' })
                }
            }

            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }
            $records = Invoke-EAIRecordsQuery -RecordType events -Field '_id' -Filter $filter -Confirm:$false

            $records.PSTypeNames | Should -Contain 'Edwin.Event.Projected'
        }
    }

    It 'Posts to /ui/query/records with a built payload' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod {
                return [PSCustomObject]@{
                    meta    = [PSCustomObject]@{ recordType = 'events'; count = 1 }
                    results = @([PSCustomObject]@{ _id = 'abc' })
                }
            }

            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }

            $records = Invoke-EAIRecordsQuery -RecordType events `
                -Field '_id', 'cf.eventName' `
                -Filter $filter `
                -Timezone 'Europe/London' `
                -Size 5 `
                -Confirm:$false

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/ui/query/records' -and
                $Method -eq 'POST' -and
                $Body -match 'recordType' -and
                $Body -match 'events' -and
                $Body -match 'Europe/London' -and
                $Body -match '"size"\s*:\s*5'
            }

            $records.PSTypeNames | Should -Contain 'Edwin.Event.Projected'
            $records[0]._id | Should -Be 'abc'
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

            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }
            $response = Invoke-EAIRecordsQuery -RecordType events -Field '_id' -Filter $filter -AsResponse -Confirm:$false

            $response.PSTypeNames | Should -Contain 'Edwin.Query.Response'
            $response.results[0]._id | Should -Be 'abc'
        }
    }

    It 'Honors -WhatIf without calling the API' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return $null }

            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }
            Invoke-EAIRecordsQuery -RecordType events -Field '_id' -Filter $filter -WhatIf | Should -BeNullOrEmpty

            Should -Invoke Invoke-EAIRestMethod -Times 0 -Exactly
        }
    }

    It 'Accepts a custom RequestBody JSON string' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return [PSCustomObject]@{ meta = @{}; results = @() } }

            $json = '{"recordType":"events","fields":["_id"],"filter":{"schemaName":"filterCondition","schemaVersion":4,"expression":{"AND":[]}},"env":{"timezone":"UTC"},"order":[]}'
            Invoke-EAIRecordsQuery -RequestBody $json -Confirm:$false | Out-Null

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Body -match 'recordType' -and $Body -match 'events'
            }
        }
    }
}
