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
}
