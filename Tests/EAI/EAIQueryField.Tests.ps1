BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Get-EAIQueryField' {
    It 'Returns catalog entries with Edwin.Query.Field typename' {
        InModuleScope -ModuleName $script:DevModuleName {
            $fields = Get-EAIQueryField -RecordType events -Usage Order

            $fields.Count | Should -BeGreaterThan 0
            $fields[0].PSTypeNames | Should -Contain 'Edwin.Query.Field'
            ($fields | Where-Object Field -eq 'meta.eventTimestamp').Count | Should -Be 1
        }
    }

    It 'Filters by usage' {
        InModuleScope -ModuleName $script:DevModuleName {
            $orderFields = Get-EAIQueryField -Usage Order
            $returnFields = Get-EAIQueryField -Usage Return

            ($orderFields | Where-Object Field -eq 'alertDetails.incidentId').Count | Should -Be 1
            ($returnFields | Where-Object Field -eq 'alertDetails.incidentId').Count | Should -Be 1
            ($orderFields | Where-Object Field -eq '_id').Count | Should -Be 1
        }
    }

    It 'Excludes event-only timestamp fields from alerts order list' {
        InModuleScope -ModuleName $script:DevModuleName {
            $fields = Get-EAIQueryField -RecordType alerts -Usage Order

            ($fields | Where-Object Field -eq 'meta.eventTimestamp').Count | Should -Be 0
            ($fields | Where-Object Field -eq 'meta.firstEventTimestamp').Count | Should -Be 1
        }
    }
}

Describe 'Resolve-EAIException query errors' {
    It 'Enriches Cannot evaluate query 400 responses with field guidance' {
        InModuleScope -ModuleName $script:DevModuleName {
            $context = [PSCustomObject]@{
                RecordType = 'events'
                Order      = @('badField desc')
            }

            $result = Resolve-EAIException -StatusCode 400 -ResponseBody '{"code":400,"message":"Cannot evaluate query","id":"trace-123"}' -ErrorContext $context

            $result.ErrorId | Should -Be 'EAI.QueryEvaluationError'
            $result.Message | Should -Match 'Cannot evaluate query'
            $result.Message | Should -Match 'badField desc'
            $result.Message | Should -Match 'Get-EAIQueryField'
            $result.Message | Should -Match 'meta.eventTimestamp'
        }
    }
}

Describe 'Invoke-EAIRecordsQuery query errors' {
    BeforeEach {
        $ConfirmPreference = 'None'
        Disconnect-EAIAccount
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAIAuth.AccessToken = 'test-token' | ConvertTo-SecureString -AsPlainText -Force
            $Script:EAIAuth.TokenExpiresAt = (Get-Date).ToUniversalTime().AddHours(1)
        }
    }

    It 'Surfaces enriched query evaluation errors from the API' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod {
                $resolved = Resolve-EAIException -StatusCode 400 -ResponseBody '{"code":400,"message":"Cannot evaluate query","id":"trace-123"}' -ErrorContext $ErrorContext
                $errorRecord = New-EAIErrorRecord -ResolvedError $resolved -Uri $Uri
                $PSCmdlet.ThrowTerminatingError($errorRecord)
            }

            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }

            {
                Invoke-EAIRecordsQuery -RecordType events -Field '_id' -Filter $filter -OrderField 'badField' -Confirm:$false -ErrorAction Stop
            } | Should -Throw '*Get-EAIQueryField*'
        }
    }
}
