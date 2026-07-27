BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Build-EAIRecordsQueryPayload' {
    It 'Builds a payload matching the Dexda-UIQuery record fixture shape' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = [PSCustomObject]@{
                schemaName    = 'filterCondition'
                schemaVersion = 4
                expression    = @{
                    WITHIN = @(
                        @{ field = 'cf.eventTime'; type = 'long' }
                        @{ unit = 'hour'; duration = 1 }
                    )
                }
            }

            $result = Build-EAIRecordsQueryPayload `
                -RecordType events `
                -Field '_id', 'cf.eventName', 'cf.eventSource' `
                -Filter $filter `
                -Timezone 'Europe/London' `
                -Order @{ field = '_id'; type = 'asc' } `
                -Size 1

            $result.recordType | Should -Be 'events'
            $result.env.timezone | Should -Be 'Europe/London'
            @($result.fields) | Should -Be @('_id', 'cf.eventName', 'cf.eventSource')
            $result.filter.schemaName | Should -Be 'filterCondition'
            $result.filter.schemaVersion | Should -Be '4'
            $result.order[0].field | Should -Be '_id'
            $result.order[0].type | Should -Be 'asc'
            $result.size | Should -Be 1
        }
    }

    It 'Uses default order when Order is omitted' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = New-EAISdtFilterObject -Expression @{
                AND = @()
            }

            $result = Build-EAIRecordsQueryPayload `
                -RecordType events `
                -Field '_id' `
                -Filter $filter

            $result.order.Count | Should -Be 1
            $result.order[0].field | Should -Be 'meta.eventTimestamp'
            $result.order[0].type | Should -Be 'desc'
            $result.PSObject.Properties.Name | Should -Not -Contain 'size'
        }
    }

    It 'Builds order from OrderField and OrderDirection' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }

            $result = Build-EAIRecordsQueryPayload `
                -RecordType events `
                -Field '_id' `
                -Filter $filter `
                -OrderField 'cf.eventName' `
                -OrderDirection asc

            $result.order[0].field | Should -Be 'cf.eventName'
            $result.order[0].type | Should -Be 'asc'
        }
    }

    It 'Defaults OrderDirection to desc when only OrderField is specified' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }

            $result = Build-EAIRecordsQueryPayload `
                -RecordType events `
                -Field '_id' `
                -Filter $filter `
                -OrderField 'cf.eventName'

            $result.order[0].field | Should -Be 'cf.eventName'
            $result.order[0].type | Should -Be 'desc'
        }
    }

    It 'Uses default order field when only OrderDirection is specified' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }

            $result = Build-EAIRecordsQueryPayload `
                -RecordType events `
                -Field '_id' `
                -Filter $filter `
                -OrderDirection asc

            $result.order[0].field | Should -Be 'meta.eventTimestamp'
            $result.order[0].type | Should -Be 'asc'
        }
    }

    It 'Uses meta.firstEventTimestamp for alerts default order' {
        InModuleScope -ModuleName $script:DevModuleName {
            $result = Build-EAIRecordsQueryPayload -RecordType alerts -Field '_id'

            $result.order[0].field | Should -Be 'meta.firstEventTimestamp'
            $result.order[0].type | Should -Be 'desc'
        }
    }

    It 'Rejects combining Order with OrderField' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }

            {
                Build-EAIRecordsQueryPayload `
                    -RecordType events `
                    -Field '_id' `
                    -Filter $filter `
                    -Order @{ field = '_id'; type = 'asc' } `
                    -OrderField 'cf.eventName'
            } | Should -Throw '*Cannot specify -Order together with -OrderField or -OrderDirection*'
        }
    }

    It 'Rejects size above the API maximum' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }

            {
                Build-EAIRecordsQueryPayload -RecordType events -Field '_id' -Filter $filter -Size 201
            } | Should -Throw '*cannot exceed 200*'
        }
    }

    It 'Uses a projected typename when fields are specified' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }
            $result = Build-EAIRecordsQueryPayload -RecordType events -Field '_id' -Filter $filter
            $typed = Add-EAIQueryRecordTypeInfo -InputObject ([PSCustomObject]@{ _id = 'abc' }) -RecordType events -Projected

            $typed.PSTypeNames | Should -Contain 'Edwin.Event.Projected'
        }
    }

    It 'Omits fields (null) when Field is not specified' {
        InModuleScope -ModuleName $script:DevModuleName {
            $result = Build-EAIRecordsQueryPayload -RecordType events

            $result.PSObject.Properties.Name | Should -Contain 'fields'
            $result.fields | Should -BeNullOrEmpty
            $json = ConvertTo-EAIQueryRequestJson -InputObject $result
            $json | Should -Match '"fields"\s*:\s*null'
        }
    }

    It 'Applies the events UI default filter when Filter is omitted' {
        InModuleScope -ModuleName $script:DevModuleName {
            $result = Build-EAIRecordsQueryPayload -RecordType events -Field '_id'

            $result.filter.expression.AND[0].OR[0].AND[0].WITHIN[0].field | Should -Be 'meta.eventTimestamp'
            $result.filter.expression.AND[0].OR[0].AND[0].WITHIN[1].duration | Should -Be 24
            $result.filter.expression.AND[1].OR[2].EMPTY[0].field | Should -Be 'meta.insightType'
        }
    }

    It 'Applies the alerts UI default filter when Filter is omitted' {
        InModuleScope -ModuleName $script:DevModuleName {
            $result = Build-EAIRecordsQueryPayload -RecordType alerts -Field '_id'

            $result.filter.expression.AND[0].OR[0].AND[0].WITHIN[0].field | Should -Be 'meta.firstEventTimestamp'
        }
    }

    It 'Uses an explicit filter when supplied' {
        InModuleScope -ModuleName $script:DevModuleName {
            $custom = New-EAISdtFilterObject -Expression @{
                EQUALS = @(
                    (New-EAISdtFilterFieldReference -Field 'cf.eventSource' -Type 'string')
                    'LogicMonitor'
                )
            }

            $result = Build-EAIRecordsQueryPayload -RecordType events -Field '_id' -Filter $custom

            $result.filter.expression.EQUALS[1] | Should -Be 'LogicMonitor'
        }
    }

    It 'Serializes order as a JSON array' {
        InModuleScope -ModuleName $script:DevModuleName {
            $filter = New-EAISdtFilterObject -Expression @{ AND = @() }
            $payload = Build-EAIRecordsQueryPayload -RecordType events -Field '_id' -Filter $filter
            $json = ConvertTo-EAIQueryRequestJson -InputObject $payload

            $json | Should -Match '"order"\s*:\s*\['
        }
    }
}

Describe 'Format-EAIQueryRecordPath' {
    It 'URL-encodes record IDs that contain slashes' {
        InModuleScope -ModuleName $script:DevModuleName {
            $path = Format-EAIQueryRecordPath -RecordType events -RecordId 'eventId/12345abc'
            $path | Should -Be '/ui/query/record/events/eventId%2F12345abc'
        }
    }
}
