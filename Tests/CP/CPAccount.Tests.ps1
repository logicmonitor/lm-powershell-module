BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Catchpoint auth cmdlets' {
    BeforeEach {
        Disconnect-CPAccount
    }

    It 'Sets CP auth state from a bearer token' {
        Connect-CPAccount -BearerToken 'test-token' -SkipCredValidation

        $status = Get-CPAccountStatus

        $status.Valid | Should -Be $true
        $status.PortalUrl | Should -Be 'https://io.catchpoint.com/api'
        $status.Type | Should -Be 'Bearer'
    }

    It 'Stores an optional account name' {
        Connect-CPAccount -BearerToken 'test-token' -AccountName 'prod' -SkipCredValidation

        $status = Get-CPAccountStatus

        $status.AccountName | Should -Be 'prod'
    }

    It 'Uses a custom API base URL' {
        Connect-CPAccount -BearerToken 'test-token' -ApiBaseUrl 'https://io.catchpoint.com/api/' -SkipCredValidation

        $status = Get-CPAccountStatus

        $status.PortalUrl | Should -Be 'https://io.catchpoint.com/api'
    }

    It 'Clears auth state on disconnect' {
        Connect-CPAccount -BearerToken 'test-token' -SkipCredValidation
        Disconnect-CPAccount

        Get-CPAccountStatus | Should -Be 'Not currently connected to any Catchpoint account.'
    }

    It 'Stores console logging preference when DisableConsoleLogging is used' {
        Connect-CPAccount -BearerToken 'test-token' -SkipCredValidation -DisableConsoleLogging

        $status = Get-CPAccountStatus

        $status.Logging | Should -Be $false
        InModuleScope -ModuleName $script:DevModuleName {
            $Script:InformationPreference | Should -Be 'SilentlyContinue'
        }
    }

    It 'Connects using a cached account by name' {
        Mock Get-SecretVault { }
        Mock Get-SecretInfo -ModuleName $script:DevModuleName {
            [PSCustomObject]@{
                Name     = 'CP:prod'
                Metadata = @{
                    Portal    = 'prod'
                    PortalUrl = 'https://io.catchpoint.com/api'
                    Id        = 'prod'
                    Type      = 'CP'
                }
            }
        }
        Mock Get-Secret -ModuleName $script:DevModuleName {
            'cached-token' | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
        }

        Connect-CPAccount -CachedAccountName 'CP:prod' -SkipCredValidation

        $status = Get-CPAccountStatus
        $status.AccountName | Should -Be 'prod'
        $status.Type | Should -Be 'Cached'

        InModuleScope -ModuleName $script:DevModuleName {
            $token = [System.Net.NetworkCredential]::new('', $Script:CPAuth.BearerToken).Password
            $token | Should -Be 'cached-token'
        }
    }

    It 'Connects using normalized selection numbers from -UseCachedCredential' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Get-SecretVault { }
            Mock Get-SecretInfo {
                @(
                    [PSCustomObject]@{
                        Name     = 'CP:first'
                        Metadata = @{
                            Portal = 'first'
                            Type   = 'CP'
                        }
                    }
                    [PSCustomObject]@{
                        Name     = 'commercial-account'
                        Metadata = @{
                            Portal = 'company'
                            Id     = 'lm-id'
                            Type   = 'LMv1'
                        }
                    }
                    [PSCustomObject]@{
                        Name     = 'CP:second'
                        Metadata = @{
                            Portal    = 'second'
                            PortalUrl = 'https://io.catchpoint.com/api'
                            Type      = 'CP'
                        }
                    }
                )
            }
            Mock Get-Secret {
                'second-token' | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
            }
            Mock Read-Host { '1' }

            Connect-CPAccount -UseCachedCredential -SkipCredValidation

            $status = Get-CPAccountStatus
            $status.AccountName | Should -Be 'second'
        }
    }

    It 'Validates credentials via GET /v2/products when SkipCredValidation is not set' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod {
                return [PSCustomObject]@{
                    data      = @()
                    completed = $true
                }
            }

            { Connect-CPAccount -BearerToken 'test-token' } | Should -Not -Throw

            Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://io.catchpoint.com/api/v2/products' -and
                $Method -eq 'GET' -and
                $Headers.Authorization -eq 'Bearer test-token'
            }
        }
    }

    It 'Fails connect when the API returns HTTP 401' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod {
                $httpResponse = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::Unauthorized)
                $httpResponse.Content = [System.Net.Http.StringContent]::new(
                    '{"errors":[{"message":"Invalid credentials"}],"traceId":"7eec5062-abcd-efgh-ijkl-1234567890ab"}',
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

            $errorRecord = { Connect-CPAccount -BearerToken 'bad-token' } |
                Should -Throw -ExpectedMessage '*Invalid Catchpoint credentials*' -PassThru

            $errorRecord.FullyQualifiedErrorId | Should -Be 'CP.AuthenticationError,Connect-CPAccount'
            $errorRecord.CategoryInfo.Category | Should -Be 'AuthenticationError'
        }
    }

    It 'Includes trace id in invalid credential errors when Catchpoint returns one' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod {
                $httpResponse = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::Unauthorized)
                $httpResponse.Content = [System.Net.Http.StringContent]::new(
                    '{"errors":[{"message":"Expired Token"}],"traceId":"7eec5062-abcd-efgh-ijkl-1234567890ab"}',
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

            { Connect-CPAccount -BearerToken 'bad-token' } |
                Should -Throw '*Invalid Catchpoint credentials*trace id: 7eec5062-abcd-efgh-ijkl-1234567890ab*'
        }
    }

    It 'Skips the API check when SkipCredValidation is set' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod { throw 'Should not be called' }

            { Connect-CPAccount -BearerToken 'test-token' -SkipCredValidation } | Should -Not -Throw

            Should -Invoke Invoke-RestMethod -Times 0 -Exactly
        }
    }
}

Describe 'Catchpoint private helpers' {
    It 'Builds a Bearer auth header' {
        InModuleScope -ModuleName $script:DevModuleName {
            $auth = [PSCustomObject]@{
                BearerToken = 'bearer-token' | ConvertTo-SecureString -AsPlainText -Force
                PortalUrl   = 'https://io.catchpoint.com/api'
            }

            $headers = New-CPHeader -Auth $auth

            $headers.Authorization | Should -Be 'Bearer bearer-token'
            $headers.'Content-Type' | Should -Be 'application/json'
            $headers.Accept | Should -Be 'application/json'
            $headers.'__CPMethod' | Should -Be 'GET'
        }
    }

    It 'Joins portal URL and resource path' {
        InModuleScope -ModuleName $script:DevModuleName {
            Join-CPUri -PortalUrl 'https://io.catchpoint.com/api/' -ResourcePath '/v2/products' |
                Should -Be 'https://io.catchpoint.com/api/v2/products'
        }
    }

    It 'Requires an active Catchpoint connection' {
        Disconnect-CPAccount

        InModuleScope -ModuleName $script:DevModuleName {
            Test-CPAuth -ErrorAction SilentlyContinue | Should -Be $false
        }
    }

    It 'Formats Catchpoint API error messages with trace id' {
        InModuleScope -ModuleName $script:DevModuleName {
            $message = Format-CPErrorMessage -ResponseBody '{"errors":[{"message":"Invalid credentials"}],"traceId":"abc-123"}' -StatusCode 401

            $message | Should -Be '401: Invalid credentials (trace id: abc-123)'
        }
    }

    It 'Returns non-JSON response bodies unchanged' {
        InModuleScope -ModuleName $script:DevModuleName {
            Format-CPErrorMessage -ResponseBody 'Gateway Timeout' -StatusCode 504 | Should -Be 'Gateway Timeout'
        }
    }
}

Describe 'CPCachedAccount cmdlets' {
    It 'Filters Catchpoint cached accounts by metadata type' {
        Mock Get-SecretInfo -ModuleName $script:DevModuleName {
            @(
                [PSCustomObject]@{
                    Name     = 'CP:prod'
                    Metadata = @{
                        Portal    = 'prod'
                        PortalUrl = 'https://io.catchpoint.com/api'
                        Modified  = Get-Date
                        Type      = 'CP'
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

        $accounts = Get-CPCachedAccount

        $accounts.Count | Should -Be 1
        $accounts[0].CachedAccountName | Should -Be 'CP:prod'
        $accounts[0].AccountName | Should -Be 'prod'
    }
}
