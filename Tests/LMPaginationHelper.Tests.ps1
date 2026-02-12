Describe 'Pagination Helper Tests' {
    BeforeAll {
        . "$PSScriptRoot/../Private/Test-LMResponseHasPagination.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMPaginatedGet.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMPaginatedPostV4.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMCursorPagedGet.ps1"
    }

    Describe 'Test-LMResponseHasPagination' {
        It 'Returns false for null response' {
            Test-LMResponseHasPagination -Response $null | Should -BeFalse
        }

        It 'Returns false when total property is missing' {
            $response = [PSCustomObject]@{ items = @() }
            Test-LMResponseHasPagination -Response $response | Should -BeFalse
        }

        It 'Returns true when total property exists' {
            $response = [PSCustomObject]@{
                total = 1
                items = @(
                    [PSCustomObject]@{ id = 1 }
                )
            }
            Test-LMResponseHasPagination -Response $response | Should -BeTrue
        }

        It 'Returns false when total value is not numeric' {
            $response = [PSCustomObject]@{
                total = 'abc'
                items = @()
            }
            Test-LMResponseHasPagination -Response $response | Should -BeFalse
        }
    }

    Describe 'Invoke-LMPaginatedGet' {
        It 'Returns null when request returns null response' {
            $result = Invoke-LMPaginatedGet -InvokeRequest {
                param($Offset, $PageSize)
                return $null
            }

            $result | Should -BeNullOrEmpty
        }

        It 'Returns single object for non-paged response when configured' {
            $result = Invoke-LMPaginatedGet -SingleObjectWhenNotPaged -InvokeRequest {
                param($Offset, $PageSize)
                return [PSCustomObject]@{ id = 10; name = 'single' }
            }

            $result.id | Should -Be 10
            $result.name | Should -Be 'single'
        }

        It 'Aggregates paged items across offsets' {
            $result = Invoke-LMPaginatedGet -BatchSize 2 -InvokeRequest {
                param($Offset, $PageSize)

                switch ($Offset) {
                    0 {
                        return [PSCustomObject]@{
                            total = 3
                            items = @(
                                [PSCustomObject]@{ id = 1 },
                                [PSCustomObject]@{ id = 2 }
                            )
                        }
                    }
                    default {
                        return [PSCustomObject]@{
                            total = 3
                            items = @(
                                [PSCustomObject]@{ id = 3 }
                            )
                        }
                    }
                }
            }

            ($result | Measure-Object).Count | Should -Be 3
            ($result.id -join ',') | Should -Be '1,2,3'
        }

        It 'Returns empty array for paged response with no items when configured' {
            $result = Invoke-LMPaginatedGet -NormalizeEmptyToArray -InvokeRequest {
                param($Offset, $PageSize)
                return [PSCustomObject]@{
                    total = 0
                    items = @()
                }
            }

            @($result).Count | Should -Be 0
        }

        It 'Returns collected results when a paged endpoint stalls with empty page' {
            $result = Invoke-LMPaginatedGet -BatchSize 2 -InvokeRequest {
                param($Offset, $PageSize)

                if ($Offset -eq 0) {
                    return [PSCustomObject]@{
                        total = 5
                        items = @(
                            [PSCustomObject]@{ id = 1 },
                            [PSCustomObject]@{ id = 2 }
                        )
                    }
                }

                return [PSCustomObject]@{
                    total = 5
                    items = @()
                }
            }

            ($result | Measure-Object).Count | Should -Be 2
            ($result.id -join ',') | Should -Be '1,2'
        }

        It 'Supports response extraction for nested response shapes' {
            $result = Invoke-LMPaginatedGet -SingleObjectWhenNotPaged -ExtractResponse {
                param($RawResponse)
                return $RawResponse.inner
            } -InvokeRequest {
                param($Offset, $PageSize)
                return [PSCustomObject]@{
                    inner = [PSCustomObject]@{
                        id = 42
                        name = 'nested'
                    }
                }
            }

            $result.id | Should -Be 42
            $result.name | Should -Be 'nested'
        }

        It 'Caps results with MaxItems and emits warning' {
            $WarningPreference = 'Continue'
            $result = Invoke-LMPaginatedGet -BatchSize 2 -MaxItems 3 -MaxItemsWarningMessage 'max hit' -InvokeRequest {
                param($Offset, $PageSize)

                switch ($Offset) {
                    0 {
                        return [PSCustomObject]@{
                            total = 4
                            items = @(
                                [PSCustomObject]@{ id = 1 },
                                [PSCustomObject]@{ id = 2 }
                            )
                        }
                    }
                    default {
                        return [PSCustomObject]@{
                            total = 4
                            items = @(
                                [PSCustomObject]@{ id = 3 },
                                [PSCustomObject]@{ id = 4 }
                            )
                        }
                    }
                }
            } 3>&1

            ($result | Where-Object { $_ -isnot [System.Management.Automation.WarningRecord] }).Count | Should -Be 3
            ($result | Where-Object { $_ -is [System.Management.Automation.WarningRecord] }).Count | Should -Be 1
        }

        It 'Stops when MaxItems is reached exactly' {
            $WarningPreference = 'Continue'
            $script:requestCount = 0
            $result = Invoke-LMPaginatedGet -BatchSize 2 -MaxItems 4 -MaxItemsWarningMessage 'max hit' -InvokeRequest {
                param($Offset, $PageSize)

                $script:requestCount++
                switch ($Offset) {
                    0 {
                        return [PSCustomObject]@{
                            total = 6
                            items = @(
                                [PSCustomObject]@{ id = 1 },
                                [PSCustomObject]@{ id = 2 }
                            )
                        }
                    }
                    default {
                        return [PSCustomObject]@{
                            total = 6
                            items = @(
                                [PSCustomObject]@{ id = 3 },
                                [PSCustomObject]@{ id = 4 }
                            )
                        }
                    }
                }
            } 3>&1

            ($result | Where-Object { $_ -isnot [System.Management.Automation.WarningRecord] }).Count | Should -Be 4
            ($result | Where-Object { $_ -is [System.Management.Automation.WarningRecord] }).Count | Should -Be 1
            $script:requestCount | Should -Be 2
        }
    }

    Describe 'Invoke-LMPaginatedPostV4' {
        It 'Aggregates POST pages using body offset increments' {
            $result = Invoke-LMPaginatedPostV4 -BatchSize 2 -InvokeRequest {
                param($Offset, $PageSize)

                switch ($Offset) {
                    0 { return [PSCustomObject]@{ data = [PSCustomObject]@{ items = @(1, 2) } } }
                    2 { return [PSCustomObject]@{ data = [PSCustomObject]@{ items = @(3) } } }
                    default { return [PSCustomObject]@{ data = [PSCustomObject]@{ items = @() } } }
                }
            } -ExtractItems {
                param($Response)
                return @($Response.data.items)
            }

            ($result | Measure-Object).Count | Should -Be 3
            ($result -join ',') | Should -Be '1,2,3'
        }
    }

    Describe 'Invoke-LMCursorPagedGet' {
        It 'Collects pages from cursor tokens until complete' {
            $result = Invoke-LMCursorPagedGet -InvokeRequest {
                param($Cursor, $PageIndex, $PreviousResponse)

                if (!$Cursor) {
                    return [PSCustomObject]@{ items = @(1); nextPageParams = 'cursor=abc' }
                }

                return [PSCustomObject]@{ items = @(2); nextPageParams = $null }
            } -ExtractItems {
                param($Response)
                return @($Response.items)
            } -GetNextCursor {
                param($Response)
                return $Response.nextPageParams
            } -IsComplete {
                param($Response, $PageIndex, $Cursor)
                return [string]::IsNullOrWhiteSpace([string]$Response.nextPageParams)
            }

            ($result | Measure-Object).Count | Should -Be 2
            ($result -join ',') | Should -Be '1,2'
        }

        It 'Stops when MaxPages is reached' {
            $result = Invoke-LMCursorPagedGet -MaxPages 1 -MaxPagesWarningMessage 'max pages' -InvokeRequest {
                param($Cursor, $PageIndex, $PreviousResponse)
                return [PSCustomObject]@{ items = @($PageIndex + 1); nextPageParams = "cursor=$PageIndex" }
            } -ExtractItems {
                param($Response)
                return @($Response.items)
            } -GetNextCursor {
                param($Response)
                return $Response.nextPageParams
            } -IsComplete {
                param($Response, $PageIndex, $Cursor)
                return $false
            } 6>&1

            ($result | Where-Object { $_ -isnot [System.Management.Automation.InformationRecord] }).Count | Should -Be 1
            ($result | Where-Object { $_ -is [System.Management.Automation.InformationRecord] }).Count | Should -Be 1
        }
    }
}
