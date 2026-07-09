Describe 'Get-LMAlert Tests' {
    BeforeAll {
        . "$PSScriptRoot/../Private/Test-LMResponseHasPagination.ps1"
        . "$PSScriptRoot/../Private/Add-ObjectTypeInfo.ps1"
        . "$PSScriptRoot/../Private/Get-LMPortalURI.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMPaginatedGet.ps1"
        . "$PSScriptRoot/../Private/New-LMHeader.ps1"
        . "$PSScriptRoot/../Private/Resolve-LMDebugInfo.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMRestMethod.ps1"
        . "$PSScriptRoot/../Public/Get-LMAlert.ps1"
    }

    BeforeEach {
        $Script:LMAuth = @{
            Valid  = $true
            Type   = 'SessionSync'
            Portal = 'unit-test'
        }

        Mock Get-LMPortalURI { 'logicmonitor.com/santaba/rest' }
        Mock New-LMHeader { @(@{}, $null) }
        Mock Resolve-LMDebugInfo { }
    }

    Context 'All parameter set query encoding' {
        It 'URL-encodes the filter and sort query values' {
            $capturedUri = $null
            Mock Invoke-LMRestMethod {
                param($Uri)
                $script:capturedUri = $Uri
                return [PSCustomObject]@{
                    total = 1
                    items = @(
                        [PSCustomObject]@{ id = 1; internalId = 'LMD1' }
                    )
                }
            }

            $expectedFilter = [System.Web.HttpUtility]::UrlEncode('rule:"*",type:"*",cleared:"true"')
            $expectedSort = [System.Web.HttpUtility]::UrlEncode('+resourceId')

            $null = Get-LMAlert -ClearedAlerts $true

            $script:capturedUri | Should -Match "filter=$([regex]::Escape($expectedFilter))"
            $script:capturedUri | Should -Match "sort=$([regex]::Escape($expectedSort))"
            $script:capturedUri | Should -Not -Match 'filter=rule:"\*"'
        }

        It 'Returns alert objects from a paginated response' {
            Mock Invoke-LMRestMethod {
                return [PSCustomObject]@{
                    total = 1
                    items = @(
                        [PSCustomObject]@{ id = 42; internalId = 'LMD42' }
                    )
                }
            }

            $result = Get-LMAlert -ClearedAlerts $true
            $result.id | Should -Be 42
            $result.PSTypeNames[0] | Should -Be 'LogicMonitor.Alert'
        }
    }

    Context 'Range parameter set query encoding' {
        It 'URL-encodes the range filter with lowercase cleared value' {
            $capturedUri = $null
            Mock Invoke-LMRestMethod {
                param($Uri)
                $script:capturedUri = $Uri
                return [PSCustomObject]@{
                    total = 0
                    items = @()
                }
            }

            $null = Get-LMAlert -StartDate ([datetime]'2024-01-01') `
                -EndDate ([datetime]'2024-01-02') `
                -ClearedAlerts $true

            $script:capturedUri | Should -Match 'filter=startEpoch'
            $script:capturedUri | Should -Match '%2ccleared%3a%22true%22'
            $script:capturedUri | Should -Match 'sort=%2bresourceId'
            $script:capturedUri | Should -Not -Match 'cleared:"True"'
            $script:capturedUri | Should -Not -Match ',rule:"'
        }
    }

    Context 'ExtractResponse handling' {
        It 'Unwraps items when the response has no total property' {
            Mock Invoke-LMRestMethod {
                return [PSCustomObject]@{
                    items = @(
                        [PSCustomObject]@{ id = 7; internalId = 'LMD7' }
                    )
                }
            }

            $result = Get-LMAlert -ClearedAlerts $true
            @($result).Count | Should -Be 1
            $result.id | Should -Be 7
        }
    }
}
