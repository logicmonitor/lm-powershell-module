BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'EAISdt filter helpers' {
    It 'Builds an EQUALS condition' {
        InModuleScope -ModuleName $script:DevModuleName {
            $condition = New-EAISdtFilterCondition -Operator 'EQUALS' `
                -FieldReference (New-EAISdtFilterFieldReference -Field 'cf.eventSource' -Type 'string') `
                -Value 'LogicMonitor'

            $condition.EQUALS[0].field | Should -Be 'cf.eventSource'
            $condition.EQUALS[1] | Should -Be 'LogicMonitor'
        }
    }

    It 'Builds a complete filter object' {
        InModuleScope -ModuleName $script:DevModuleName {
            $expression = New-EAISdtFilterCondition -Operator 'IN' `
                -FieldReference (New-EAISdtFilterFieldReference -Field 'cf.eventSeverity' -Type 'integer') `
                -Value @(4, 5, 6)
            $filter = New-EAISdtFilterObject -Expression $expression

            $filter.schemaName | Should -Be 'filterCondition'
            $filter.schemaVersion | Should -Be '4'
            @($filter.expression.IN[1]) | Should -Be @(4, 5, 6)
        }
    }

    It 'Builds unary NOT_EMPTY conditions' {
        InModuleScope -ModuleName $script:DevModuleName {
            $field = New-EAISdtFilterFieldReference -Field 'extra.lm_auto_network_names' -Type 'string'
            $condition = New-EAISdtFilterCondition -Operator 'NOT_EMPTY' -FieldReference $field

            $condition.NOT_EMPTY.Count | Should -Be 1
            $condition.NOT_EMPTY[0].field | Should -Be 'extra.lm_auto_network_names'
        }
    }

    It 'Exposes string operators supported by the Edwin UI' {
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAISdtFilterOperatorsByFieldType['string'] | Should -Be @(
                'EQUALS', 'NOT_EQUALS', 'CONTAINS', 'NOT_CONTAINS', 'IN', 'NOT_IN', 'IS_EMPTY', 'NOT_EMPTY'
            )
        }
    }

    It 'Exposes integer operators supported by the Edwin UI' {
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAISdtFilterOperatorsByFieldType['integer'] | Should -Contain 'GREATER_THAN_EQUAL'
            $Script:EAISdtFilterOperatorsByFieldType['integer'] | Should -Contain 'LESS_THAN_EQUAL'
        }
    }

    It 'Exposes long timestamp operators supported by the Edwin UI' {
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:EAISdtFilterOperatorsByFieldType['long'] | Should -Be @(
                'GREATER_THAN', 'LESS_THAN', 'OLDER_THAN', 'WITHIN', 'IS_EMPTY', 'NOT_EMPTY'
            )
        }
    }
}
