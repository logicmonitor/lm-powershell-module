BeforeAll {
    if ($Module) {
        $script:DevModuleName = Import-Module $Module -Force -PassThru | Select-Object -ExpandProperty Name
    }
    else {
        $devModule = Join-Path $PSScriptRoot '..' '..' 'Dev.Logic.Monitor.psd1'
        $script:DevModuleName = Import-Module $devModule -Force -PassThru | Select-Object -ExpandProperty Name
    }
}

Describe 'Catchpoint instant test cmdlets' {
    BeforeEach {
        Disconnect-CPAccount
        Connect-CPAccount -BearerToken 'test-token' -SkipCredValidation
    }

    It 'Requires an active Catchpoint connection' {
        Disconnect-CPAccount

        { Get-CPInstantTest -Id 1 -NodeId 2 -ErrorAction Stop } | Should -Throw
    }

    It 'Creates an instant test from URL and node IDs' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{
                        id               = 99
                        instantTestNodes = @([PSCustomObject]@{ id = 17 })
                    }
                }
            }

            $result = New-CPInstantTest -Url 'https://example.com' -NodeId 17 -Confirm:$false

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://io.catchpoint.com/api/v4/InstantTests' -and
                $Method -eq 'POST' -and
                $Body -match '"url":"https://example.com"' -and
                $Body -match '"id":17'
            }

            $result.id | Should -Be 99
            $result.PSObject.TypeNames[0] | Should -Be 'Catchpoint.InstantTest'
        }
    }

    It 'Gets instant test configuration' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{
                        instantTest = [PSCustomObject]@{ url = 'https://example.com' }
                    }
                }
            }

            $result = Get-CPInstantTestConfiguration -Id 0

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://io.catchpoint.com/api/v4/InstantTests/configuration/0' -and
                $Method -eq 'GET'
            }

            $result.instantTest.url | Should -Be 'https://example.com'
        }
    }

    It 'Gets instant test results by id and node' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{
                        instantTestStatus = 'Completed'
                    }
                }
            }

            $result = Get-CPInstantTest -Id 99 -NodeId 17

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://io.catchpoint.com/api/v4/InstantTests/99?nodeId=17&stepId=0' -and
                $Method -eq 'GET'
            }

            $result.instantTestStatus | Should -Be 'Completed'
            $result.PSObject.TypeNames[0] | Should -Be 'Catchpoint.InstantTest.Result'
        }
    }

    It 'Runs an existing test as an instant test' {
        InModuleScope -ModuleName $script:DevModuleName {
            Mock Invoke-CPRestMethod {
                return [PSCustomObject]@{
                    data = [PSCustomObject]@{ id = 100 }
                }
            }

            $result = Invoke-CPInstantTest -TestId 12345 -NodeId 17, 22 -OnDemand -Confirm:$false

            Should -Invoke Invoke-CPRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://io.catchpoint.com/api/v4/InstantTests/12345?onDemand=true' -and
                $Method -eq 'POST' -and
                $Body -match '"id":17' -and
                $Body -match '"id":22'
            }

            $result.id | Should -Be 100
        }
    }
}
