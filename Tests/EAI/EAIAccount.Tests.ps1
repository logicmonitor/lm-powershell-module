BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'EAI auth cmdlets' {
    BeforeEach {
        Disconnect-EAIAccount
    }

    It 'Sets EAI auth state from credentials' {
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation

        $status = Get-EAIAccountStatus

        $status.Valid | Should -Be $true
        $status.EdwinOrg | Should -Be 'myorg'
        $status.PortalUrl | Should -Be 'https://myorg.dexda.ai'
    }

    It 'Reads auth values from YAML file' {
        $authFile = Join-Path $TestDrive 'edwin-auth.yaml'
        @'
edwin_org: fileorg
client_id: file-client
client_secret: file-secret
'@ | Set-Content -Path $authFile

        Connect-EAIAccount -AuthFilePath $authFile -SkipCredValidation

        $status = Get-EAIAccountStatus

        $status.EdwinOrg | Should -Be 'fileorg'
        $status.ClientId | Should -Be 'file-client'
    }

    It 'Returns account status when connected' {
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation

        $status = Get-EAIAccountStatus

        $status.Valid | Should -Be $true
        $status.EdwinOrg | Should -Be 'myorg'
    }

    It 'Clears auth state on disconnect' {
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation
        Disconnect-EAIAccount

        Get-EAIAccountStatus | Should -Be 'Not currently connected to any Edwin portals.'
    }

    It 'Stores console logging preference when DisableConsoleLogging is used' {
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation -DisableConsoleLogging

        $status = Get-EAIAccountStatus

        $status.Logging | Should -Be $false
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:InformationPreference | Should -Be 'SilentlyContinue'
        }
    }

    It 'Connects using a cached account by name' {
        Mock Get-SecretVault { }
        Mock Get-SecretInfo -ModuleName $script:DevModuleName {
            [PSCustomObject]@{
                Name     = 'EAI:myorg'
                Metadata = @{
                    Portal = 'myorg'
                    Id     = 'client-id'
                    Type   = 'EAI'
                }
            }
        }
        Mock Get-Secret -ModuleName $script:DevModuleName {
            'client-secret' | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
        }

        Connect-EAIAccount -CachedAccountName 'EAI:myorg' -SkipCredValidation

        $status = Get-EAIAccountStatus
        $status.EdwinOrg | Should -Be 'myorg'
        $status.ClientId | Should -Be 'client-id'

        InModuleScope -ModuleName $script:DevModuleName {
            $clientSecret = [System.Net.NetworkCredential]::new('', $Script:EAIAuth.ClientSecret).Password
            $clientSecret | Should -Be 'client-secret'
        }
    }

    It 'Validates credentials via remote ping when SkipCredValidation is not set' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod {
                $httpResponse = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::BadRequest)
                $httpResponse.Content = [System.Net.Http.StringContent]::new(
                    '{"code":400,"message":"Invalid empty request"}',
                    [System.Text.Encoding]::UTF8,
                    'application/json'
                )

                $exception = [Microsoft.PowerShell.Commands.HttpResponseException]::new(
                    'Response status code does not indicate success: 400 (Bad Request).',
                    $httpResponse
                )

                throw [System.Management.Automation.ErrorRecord]::new(
                    $exception,
                    'InvokeRestMethod',
                    [System.Management.Automation.ErrorCategory]::InvalidOperation,
                    $null
                )
            }

            { Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' } | Should -Not -Throw

            Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/integration/event/v1' -and
                $Method -eq 'POST' -and
                $Body -eq '[]'
            }
        }
    }

    It 'Fails connect when remote ping returns HTTP 401' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod {
                $httpResponse = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::Unauthorized)
                $httpResponse.Content = [System.Net.Http.StringContent]::new(
                    '{"code":401,"message":"Credentials are required to access this resource."}',
                    [System.Text.Encoding]::UTF8,
                    'application/json'
                )

                $exception = [Microsoft.PowerShell.Commands.HttpResponseException]::new(
                    'Response status code does not indicate success: 401 (Unauthorized).',
                    $httpResponse
                )

                throw [System.Management.Automation.ErrorRecord]::new(
                    $exception,
                    'InvokeRestMethod',
                    [System.Management.Automation.ErrorCategory]::InvalidOperation,
                    $null
                )
            }

            $errorRecord = { Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' } |
                Should -Throw -ExpectedMessage '*Invalid Edwin credentials for portal*myorg*Verify EdwinOrg, ClientId, and ClientSecret*' -PassThru

            $errorRecord.FullyQualifiedErrorId | Should -Be 'EAI.AuthenticationError,Connect-EAIAccount'
            $errorRecord.CategoryInfo.Category | Should -Be 'AuthenticationError'
        }
    }

    It 'Includes trace id in invalid credential errors when Edwin returns one' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod {
                $httpResponse = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::Unauthorized)
                $httpResponse.Content = [System.Net.Http.StringContent]::new(
                    '{"code":401,"message":"Credentials are required to access this resource.","id":"7eec5062-abcd-efgh-ijkl-1234567890ab"}',
                    [System.Text.Encoding]::UTF8,
                    'application/json'
                )

                $exception = [Microsoft.PowerShell.Commands.HttpResponseException]::new(
                    'Response status code does not indicate success: 401 (Unauthorized).',
                    $httpResponse
                )

                throw [System.Management.Automation.ErrorRecord]::new(
                    $exception,
                    'InvokeRestMethod',
                    [System.Management.Automation.ErrorCategory]::InvalidOperation,
                    $null
                )
            }

            { Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' } |
                Should -Throw '*Invalid Edwin credentials for portal*trace id: 7eec5062-abcd-efgh-ijkl-1234567890ab*'
        }
    }

    It 'Skips remote ping when SkipCredValidation is set' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod { throw 'Should not be called' }

            { Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation } | Should -Not -Throw

            Should -Invoke Invoke-RestMethod -Times 0 -Exactly
        }
    }
}

Describe 'New-EAIHeader' {
    It 'Builds a Basic auth header' {
        InModuleScope -ModuleName $script:DevModuleName {
            $auth = [PSCustomObject]@{
                ClientId     = 'user'
                ClientSecret = 'pass' | ConvertTo-SecureString -AsPlainText -Force
            }

            $headers = New-EAIHeader -Auth $auth

            $expected = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes('user:pass'))
            $headers.Authorization | Should -Be "Basic $expected"
            $headers.'Content-Type' | Should -Be 'application/json'
            $headers.'__EAIMethod' | Should -Be 'POST'
        }
    }
}

Describe 'Resolve-EAIDebugInfo' {
    It 'Strips __EAIMethod from headers before the HTTP request is sent' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod {
                return @([PSCustomObject]@{ eventId = '123'; acceptedStatus = $true })
            }

            $auth = [PSCustomObject]@{
                ClientId     = 'user'
                ClientSecret = 'pass' | ConvertTo-SecureString -AsPlainText -Force
            }

            $headers = New-EAIHeader -Auth $auth -Method 'POST'

            Invoke-EAIRestMethod -Uri 'https://myorg.dexda.ai/integration/event/v1' -Method POST -Headers $headers -Auth $auth -Body '[]'

            Should -Invoke Invoke-RestMethod -ParameterFilter {
                -not $Headers.ContainsKey('__EAIMethod')
            }
        }
    }
}

Describe 'Test-EAIEventPayload' {
    It 'Normalizes valid CEF payloads' {
        InModuleScope -ModuleName $script:DevModuleName {
            $event = @{
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

            $normalized = Test-EAIEventPayload -Event $event

            $normalized.cef.event_severity | Should -Be 4
            $normalized.cef.class | Should -Be 'event'
            $normalized.cef.version | Should -Be '1.1'
            $normalized.cef.event_time | Should -Match '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{5}Z$'
        }
    }

    It 'Normalizes event_time to Edwin five-digit fractional format' {
        InModuleScope -ModuleName $script:DevModuleName {
            $event = @{
                cef = @{
                    event_ci          = 'ci'
                    event_object      = 'object'
                    event_source      = 'source'
                    event_name        = 'name'
                    event_description = 'description'
                    event_severity    = 'major'
                    event_time        = '2026-07-20T19:40:55.107Z'
                    event_id          = [guid]::NewGuid().ToString()
                    event_domain      = ''
                    source_record     = @{ id = 1 }
                }
                enrichments = @{}
            }

            $normalized = Test-EAIEventPayload -Event $event

            $normalized.cef.event_time | Should -Be '2026-07-20T19:40:55.10700Z'
        }
    }

    It 'Throws when required CEF fields are missing' {
        InModuleScope -ModuleName $script:DevModuleName {
            { Test-EAIEventPayload -Event @{ cef = @{ event_name = 'only-name' }; enrichments = @{} } } |
                Should -Throw "CEF payload is missing required field 'event_ci'."
        }
    }
}

Describe 'Send-EAIEvents' {
    BeforeEach {
        Disconnect-EAIAccount
        Connect-EAIAccount -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret 'secret' -SkipCredValidation
    }

    It 'Requires an active Edwin connection' {
        Disconnect-EAIAccount

        { Send-EAIEvents -Events @{ cef = @{}; enrichments = @{} } -ErrorAction Stop } |
            Should -Throw
    }

    It 'Posts normalized events to Edwin' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-EAIRestMethod { return @(@{ eventId = '123'; acceptedStatus = $true }) }

            $event = New-EAIEvent -EventCi 'ci' -EventObject 'obj' -EventSource 'vendor' -EventName 'alert' -EventDescription 'details' -Severity Major -SourceRecord @{ id = 1 }

            $result = Send-EAIEvents -Events $event -PassThru -Confirm:$false

            Should -Invoke Invoke-EAIRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/integration/event/v1' -and
                $Method -eq 'POST' -and
                $Body -match '"event_severity":\s*4'
            }
            $result.acceptedStatus | Should -Be $true
        }
    }
}

Describe 'Invoke-EAIRestMethod' {
    It 'Returns parsed JSON for successful responses' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod {
                return @([PSCustomObject]@{ eventId = '123'; acceptedStatus = $true })
            }

            $auth = [PSCustomObject]@{
                ClientId     = 'user'
                ClientSecret = 'pass' | ConvertTo-SecureString -AsPlainText -Force
            }

            $result = Invoke-EAIRestMethod -Uri 'https://myorg.dexda.ai/integration/event/v1' -Method POST -Headers @{} -Auth $auth

            $result[0].acceptedStatus | Should -Be $true
        }
    }

    It 'Formats Edwin API error responses' {
        InModuleScope -ModuleName $script:DevModuleName {
            $message = Format-EAIErrorMessage -ResponseBody '{"code":401,"message":"Credentials are required to access this resource."}' -StatusCode 401

            $message | Should -Be '401: Credentials are required to access this resource.'
        }
    }

    It 'Throws a formatted authentication error for HTTP 401' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod {
                $httpResponse = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::Unauthorized)
                $httpResponse.Content = [System.Net.Http.StringContent]::new(
                    '{"code":401,"message":"Credentials are required to access this resource."}',
                    [System.Text.Encoding]::UTF8,
                    'application/json'
                )

                $exception = [Microsoft.PowerShell.Commands.HttpResponseException]::new(
                    'Response status code does not indicate success: 401 (Unauthorized).',
                    $httpResponse
                )

                throw [System.Management.Automation.ErrorRecord]::new(
                    $exception,
                    'InvokeRestMethod',
                    [System.Management.Automation.ErrorCategory]::InvalidOperation,
                    $null
                )
            }

            $auth = [PSCustomObject]@{
                ClientId     = 'user'
                ClientSecret = 'pass' | ConvertTo-SecureString -AsPlainText -Force
            }

            { Invoke-EAIRestMethod -Uri 'https://myorg.dexda.ai/integration/event/v1' -Method POST -Headers @{} -Auth $auth } |
                Should -Throw '*401: Credentials are required to access this resource.*Connect-EAIAccount*'
        }
    }

    It 'Reads error bodies from ErrorDetails on PowerShell 7' {
        InModuleScope -ModuleName $script:DevModuleName {
            $errorRecord = [System.Management.Automation.ErrorRecord]::new(
                [System.InvalidOperationException]::new('Request failed'),
                'InvokeWebRequest',
                [System.Management.Automation.ErrorCategory]::InvalidOperation,
                $null
            )
            $errorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('{"message":"invalid payload"}')

            $details = Get-EAIHttpErrorDetails -ErrorRecord $errorRecord

            $details.Body | Should -Be '{"message":"invalid payload"}'
        }
    }
}

Describe 'New-EAIEvent and Convert-EAIEvent' {
    It 'Builds a CEF object from parameters' {
        $event = New-EAIEvent -EventCi 'host' -EventObject 'cpu' -EventSource 'VendorX' -EventName 'High CPU' -EventDescription 'threshold exceeded' -Severity Critical -SourceRecord @{ host = 'host' }

        $event.cef.event_severity | Should -Be 5
        $event.cef.class | Should -Be 'event'
        $event.PSObject.Properties.Name | Should -Contain 'enrichments'
    }

    It 'Maps third-party objects using PropertyMap' {
        $source = [PSCustomObject]@{
            HostName   = 'server01'
            AlertTitle = 'Disk full'
            Details    = 'Disk usage exceeded 90%'
            Component  = 'disk'
            Severity   = 'maj'
        }

        $event = $source | Convert-EAIEvent -PropertyMap @{
            event_ci          = 'HostName'
            event_name        = 'AlertTitle'
            event_description = 'Details'
            event_object      = 'Component'
            event_severity    = 'Severity'
            event_source      = { 'VendorX' }
        } -SeverityMap @{
            major = @('maj')
        }

        $event.cef.event_ci | Should -Be 'server01'
        $event.cef.event_severity | Should -Be 4
        $event.cef.event_source | Should -Be 'VendorX'
    }
}

Describe 'EAICachedAccount cmdlets' {
    It 'Filters Edwin cached accounts by metadata type' {
        Mock Get-SecretInfo -ModuleName $script:DevModuleName {
            @(
                [PSCustomObject]@{
                    Name     = 'EAI:myorg'
                    Metadata = @{
                        Portal   = 'myorg'
                        Id       = 'client-id'
                        Modified = Get-Date
                        Type     = 'EAI'
                    }
                }
                [PSCustomObject]@{
                    Name     = 'commercial-account'
                    Metadata = @{
                        Portal   = 'company'
                        Id       = 'lm-id'
                        Modified = Get-Date
                        Type     = 'LMv1'
                    }
                }
            )
        }

        $accounts = Get-EAICachedAccount

        $accounts.Count | Should -Be 1
        $accounts[0].CachedAccountName | Should -Be 'EAI:myorg'
        $accounts[0].EdwinOrg | Should -Be 'myorg'
    }
}
