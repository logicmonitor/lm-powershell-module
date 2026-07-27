BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Format-EAIErrorMessage' {
    It 'Appends Edwin trace id when present' {
        InModuleScope -ModuleName $script:DevModuleName {
            $message = Format-EAIErrorMessage -ResponseBody '{"code":422,"message":"Invalid event_time format","id":"7eec5062-abcd-efgh-ijkl-1234567890ab"}' -StatusCode 422

            $message | Should -Be '422: Invalid event_time format (trace id: 7eec5062-abcd-efgh-ijkl-1234567890ab)'
        }
    }

    It 'Appends trace id when errors array is present' {
        InModuleScope -ModuleName $script:DevModuleName {
            $message = Format-EAIErrorMessage -ResponseBody '{"code":422,"message":"Validation failed","errors":["event_time"],"id":"abc-123"}' -StatusCode 422

            $message | Should -Be '422: Validation failed [event_time] (trace id: abc-123)'
        }
    }

    It 'Does not append trace id when id is missing' {
        InModuleScope -ModuleName $script:DevModuleName {
            $message = Format-EAIErrorMessage -ResponseBody '{"code":401,"message":"Credentials are required to access this resource."}' -StatusCode 401

            $message | Should -Be '401: Credentials are required to access this resource.'
        }
    }

    It 'Returns non-JSON response bodies unchanged' {
        InModuleScope -ModuleName $script:DevModuleName {
            Format-EAIErrorMessage -ResponseBody 'Gateway Timeout' -StatusCode 504 | Should -Be 'Gateway Timeout'
        }
    }
}
