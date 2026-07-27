BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Test-EAIEventPayload optional field coercion' {
    It 'Removes empty optional CEF fields' {
        InModuleScope -ModuleName $script:DevModuleName {
            $testPayload = @{
                cef = @{
                    event_ci              = 'ci'
                    event_object          = 'object'
                    event_source          = 'source'
                    event_name            = 'name'
                    event_description     = 'description'
                    event_severity        = 'major'
                    event_time            = '2024-01-01T00:00:00.000Z'
                    event_id              = [guid]::NewGuid().ToString()
                    event_domain          = ''
                    source_record         = @{ id = 1 }
                    event_details         = ''
                    event_ci_link         = ''
                    event_name_link       = $null
                    event_source_id       = ''
                    event_source_id_link  = ''
                }
                enrichments = @{}
            }

            $normalized = Test-EAIEventPayload -Event $testPayload
            $cef = @{}
            foreach ($property in $normalized.cef.PSObject.Properties) {
                $cef[$property.Name] = $property.Value
            }

            $cef.ContainsKey('event_details') | Should -Be $false
            $cef.ContainsKey('event_ci_link') | Should -Be $false
            $cef.ContainsKey('event_name_link') | Should -Be $false
            $cef.ContainsKey('event_source_id') | Should -Be $false
            $cef.ContainsKey('event_source_id_link') | Should -Be $false
        }
    }

    It 'Keeps event_domain when empty' {
        InModuleScope -ModuleName $script:DevModuleName {
            $testPayload = @{
                cef = @{
                    event_ci          = 'ci'
                    event_object      = 'object'
                    event_source      = 'source'
                    event_name        = 'name'
                    event_description = 'description'
                    event_severity    = 'major'
                    event_time        = '2024-01-01T00:00:00.000Z'
                    event_id          = [guid]::NewGuid().ToString()
                    event_domain      = ''
                    source_record     = @{ id = 1 }
                }
                enrichments = @{}
            }

            $normalized = Test-EAIEventPayload -Event $testPayload

            $normalized.cef.event_domain | Should -Be ''
        }
    }

    It 'Keeps whitespace-only optional fields' {
        InModuleScope -ModuleName $script:DevModuleName {
            $testPayload = @{
                cef = @{
                    event_ci          = 'ci'
                    event_object      = 'object'
                    event_source      = 'source'
                    event_name        = 'name'
                    event_description = 'description'
                    event_severity    = 'major'
                    event_time        = '2024-01-01T00:00:00.000Z'
                    event_id          = [guid]::NewGuid().ToString()
                    event_domain      = ''
                    source_record     = @{ id = 1 }
                    event_details     = '   '
                }
                enrichments = @{}
            }

            $normalized = Test-EAIEventPayload -Event $testPayload

            $normalized.cef.event_details | Should -Be '   '
        }
    }

    It 'Keeps populated optional fields' {
        InModuleScope -ModuleName $script:DevModuleName {
            $testPayload = @{
                cef = @{
                    event_ci          = 'ci'
                    event_object      = 'object'
                    event_source      = 'source'
                    event_name        = 'name'
                    event_description = 'description'
                    event_severity    = 'major'
                    event_time        = '2024-01-01T00:00:00.000Z'
                    event_id          = [guid]::NewGuid().ToString()
                    event_domain      = ''
                    source_record     = @{ id = 1 }
                    event_details     = 'extra context'
                    event_ci_link     = 'https://example.com/ci/host'
                }
                enrichments = @{}
            }

            $normalized = Test-EAIEventPayload -Event $testPayload

            $normalized.cef.event_details | Should -Be 'extra context'
            $normalized.cef.event_ci_link | Should -Be 'https://example.com/ci/host'
        }
    }
}
