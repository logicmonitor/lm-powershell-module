BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Request-EAIAccessToken' {
    It 'Requests a token using client credentials' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod {
                return [PSCustomObject]@{
                    access_token = 'issued-token'
                    token_type   = 'Bearer'
                    expires_in   = 1800
                }
            }

            $result = Request-EAIAccessToken -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret ('secret' | ConvertTo-SecureString -AsPlainText -Force)

            Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://myorg.dexda.ai/auth/token' -and
                $Method -eq 'POST' -and
                $ContentType -eq 'application/x-www-form-urlencoded' -and
                $Body -match 'grant_type=client_credentials' -and
                $Body -match 'client_id=client' -and
                $Body -match 'client_secret=secret'
            }

            [System.Net.NetworkCredential]::new('', $result.AccessToken).Password | Should -Be 'issued-token'
            $result.ExpiresAt | Should -BeOfType [DateTime]
        }
    }

    It 'Parses expires_at epoch milliseconds when present' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-RestMethod {
                return [PSCustomObject]@{
                    access_token = 'issued-token'
                    expires_at   = 1759145595335
                }
            }

            $result = Request-EAIAccessToken -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret ('secret' | ConvertTo-SecureString -AsPlainText -Force)

            $result.ExpiresAt | Should -Be ([DateTimeOffset]::FromUnixTimeMilliseconds(1759145595335).UtcDateTime)
        }
    }

    It 'Throws a connect-specific error for HTTP 401' {
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

            { Request-EAIAccessToken -EdwinOrg 'myorg' -ClientId 'client' -ClientSecret ('secret' | ConvertTo-SecureString -AsPlainText -Force) } |
                Should -Throw '*Invalid Edwin credentials for portal*myorg*'
        }
    }
}

Describe 'Get-EAIBearerToken' {
    It 'Returns a cached token when it expires more than 60 seconds from now' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Request-EAIAccessToken { throw 'Should not refresh' }

            $auth = [PSCustomObject]@{
                EdwinOrg       = 'myorg'
                ClientId       = 'client'
                ClientSecret   = 'secret' | ConvertTo-SecureString -AsPlainText -Force
                AccessToken    = 'cached-token' | ConvertTo-SecureString -AsPlainText -Force
                TokenExpiresAt = (Get-Date).ToUniversalTime().AddMinutes(10)
            }

            Get-EAIBearerToken -Auth $auth | Should -Be 'cached-token'
            Should -Invoke Request-EAIAccessToken -Times 0 -Exactly
        }
    }

    It 'Refreshes the token when it is near expiry' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Request-EAIAccessToken {
                return [PSCustomObject]@{
                    AccessToken = ('fresh-token' | ConvertTo-SecureString -AsPlainText -Force)
                    ExpiresAt   = (Get-Date).ToUniversalTime().AddHours(1)
                }
            }

            $auth = [PSCustomObject]@{
                EdwinOrg       = 'myorg'
                ClientId       = 'client'
                ClientSecret   = 'secret' | ConvertTo-SecureString -AsPlainText -Force
                AccessToken    = 'stale-token' | ConvertTo-SecureString -AsPlainText -Force
                TokenExpiresAt = (Get-Date).ToUniversalTime().AddSeconds(30)
            }

            Get-EAIBearerToken -Auth $auth | Should -Be 'fresh-token'
            Should -Invoke Request-EAIAccessToken -Times 1 -Exactly
        }
    }

    It 'Forces a refresh when requested' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Request-EAIAccessToken {
                return [PSCustomObject]@{
                    AccessToken = ('forced-token' | ConvertTo-SecureString -AsPlainText -Force)
                    ExpiresAt   = (Get-Date).ToUniversalTime().AddHours(1)
                }
            }

            $auth = [PSCustomObject]@{
                EdwinOrg       = 'myorg'
                ClientId       = 'client'
                ClientSecret   = 'secret' | ConvertTo-SecureString -AsPlainText -Force
                AccessToken    = 'cached-token' | ConvertTo-SecureString -AsPlainText -Force
                TokenExpiresAt = (Get-Date).ToUniversalTime().AddHours(1)
            }

            Get-EAIBearerToken -Auth $auth -ForceRefresh | Should -Be 'forced-token'
            Should -Invoke Request-EAIAccessToken -Times 1 -Exactly
        }
    }
}
