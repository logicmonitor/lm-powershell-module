BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Get-CPTests' {
    BeforeEach {
        Disconnect-CPAccount
        Connect-CPAccount -BearerToken 'test-token' -SkipCredValidation
    }

    It 'Requires an active Catchpoint connection' {
        Disconnect-CPAccount

        { Get-CPTests -ErrorAction Stop } | Should -Throw
    }

    It 'Lists tests from /v4/Tests' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{
                        tests   = @(
                            [PSCustomObject]@{ id = 1; name = 'Homepage' }
                            [PSCustomObject]@{ id = 2; name = 'API check' }
                        )
                        hasMore = $false
                    }
                }
            }

            $results = Get-CPTests

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://io.catchpoint.com/api/v4/Tests?pageNumber=1&pageSize=100' -and
                $Method -eq 'GET'
            }

            $results.Count | Should -Be 2
            $results[0].name | Should -Be 'Homepage'
            $results[0].PSObject.TypeNames[0] | Should -Be 'Catchpoint.Test'
        }
    }

    It 'Retrieves a single test by ID' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{
                        tests = @(
                            [PSCustomObject]@{ id = 12345; name = 'Homepage' }
                        )
                    }
                }
            }

            $result = Get-CPTests -Id 12345

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://io.catchpoint.com/api/v4/Tests/12345' -and
                $Method -eq 'GET'
            }

            $result.id | Should -Be 12345
            $result.PSObject.TypeNames[0] | Should -Be 'Catchpoint.Test'
        }
    }

    It 'Applies name and status filters' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{
                        tests   = @([PSCustomObject]@{ id = 1; name = 'Homepage' })
                        hasMore = $false
                    }
                }
            }

            $null = Get-CPTests -Name 'Homepage' -Status Active

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -match '/v4/Tests\?' -and
                $Uri -match 'name=Homepage' -and
                $Uri -match 'statusId=0'
            }
        }
    }

    It 'Pages through results while hasMore is true' {
        InModuleScope -ModuleName $script:DevModuleName {
            $script:pageCalls = 0
            Mock Invoke-CPRestMethod {
                $script:pageCalls++
                if ($script:pageCalls -eq 1) {
                    return [PSCustomObject]@{
                        data = [PSCustomObject]@{
                            tests   = @([PSCustomObject]@{ id = 1; name = 'First' })
                            hasMore = $true
                        }
                    }
                }

                return [PSCustomObject]@{
                    data = [PSCustomObject]@{
                        tests   = @([PSCustomObject]@{ id = 2; name = 'Second' })
                        hasMore = $false
                    }
                }
            }

            $results = Get-CPTests -PageSize 1

            Should -Invoke Invoke-CPRestMethod -Times 2
            $results.Count | Should -Be 2
            $results[1].name | Should -Be 'Second'
        }
    }

    It 'Returns an empty array when no tests are found' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{
                        tests   = @()
                        hasMore = $false
                    }
                }
            }

            $results = Get-CPTests

            @($results).Count | Should -Be 0
        }
    }
}

Describe 'Catchpoint test helpers' {
    It 'Builds a query string from parameters' {
        InModuleScope -ModuleName $script:DevModuleName {
            New-CPQueryString -Parameters @{
                name     = 'Homepage'
                statusId = 0
                empty    = ''
            } | Should -Be 'name=Homepage&statusId=0'
        }
    }

    It 'Extracts tests and hasMore from a wrapped API response' {
        InModuleScope -ModuleName $script:DevModuleName {
            $page = Get-CPResponseItems -ItemPropertyName 'tests' -Response ([PSCustomObject]@{
                    data = [PSCustomObject]@{
                        tests   = @([PSCustomObject]@{ id = 1 })
                        hasMore = $true
                    }
                })

            $page.Items.Count | Should -Be 1
            $page.HasMore | Should -Be $true
        }
    }
}

Describe 'Catchpoint test write cmdlets' {
    BeforeEach {
        Disconnect-CPAccount
        Connect-CPAccount -BearerToken 'test-token' -SkipCredValidation
    }

    It 'Creates a test from a payload' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{ id = 55; name = 'Homepage' }
                }
            }

            $result = New-CPTest -Body @{ id = 0; name = 'Homepage' } -ObjectDetails -Confirm:$false

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://io.catchpoint.com/api/v4/Tests?objectDetails=true' -and
                $Method -eq 'POST' -and
                $Body -match '"name":"Homepage"'
            }

            $result.id | Should -Be 55
            $result.PSObject.TypeNames[0] | Should -Be 'Catchpoint.Test'
        }
    }

    It 'Patches a test property' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{ id = 55 }
                }
            }

            $null = Set-CPTest -Id 55 -Operation Replace -Path '/status/id' -Value 1 -Confirm:$false

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://io.catchpoint.com/api/v4/Tests/55' -and
                $Method -eq 'PATCH' -and
                $Body -match '"op":"replace"' -and
                $Body -match '"path":"/status/id"'
            }
        }
    }

    It 'Gets test alert state' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{
                        tests = @([PSCustomObject]@{ testId = 55; status = @{ id = 1 } })
                    }
                }
            }

            $result = Get-CPTestAlertState -Id 55

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://io.catchpoint.com/api/v4/Tests/alert/state/55' -and
                $Method -eq 'GET'
            }

            $result.testId | Should -Be 55
            $result.PSObject.TypeNames[0] | Should -Be 'Catchpoint.Test.AlertState'
        }
    }

    It 'Pauses test alerts' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{
                        tests = @([PSCustomObject]@{ testId = 55; status = @{ id = 0 } })
                    }
                }
            }

            $null = Set-CPTestAlertState -Id 55 -Status Paused -PauseExpiration '01:00' -Confirm:$false

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://io.catchpoint.com/api/v4/Tests/alert/state' -and
                $Method -eq 'PATCH' -and
                $Body -match '"testId":55' -and
                $Body -match '"pauseExpiration":"01:00"'
            }
        }
    }

    It 'Gets test enumerations' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{ displayTestType = @() }
                }
            }

            $null = Get-CPTestEnumeration -Include DisplayTestType, DisplayMonitorType

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -match '/v4/Tests/enumeration\?' -and
                $Uri -match 'displayTestType=true' -and
                $Uri -match 'displayMonitorType=true'
            }
        }
    }

    It 'Converts a transaction script' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{ script = 'playwright-script' }
                }
            }

            $result = Convert-CPTestScript -Script 'selenium-script'

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://io.catchpoint.com/api/v4/Tests/scriptconvert?languageScriptShouldConvertTo=3&scriptLanguage=1' -and
                $Method -eq 'POST' -and
                $Body -match '"script":"selenium-script"'
            }

            $result.script | Should -Be 'playwright-script'
        }
    }
}
