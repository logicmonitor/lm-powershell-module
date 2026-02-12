Describe 'Pagination Cmdlet Regression Tests' {
    BeforeAll {
        . "$PSScriptRoot/../Private/Add-ObjectTypeInfo.ps1"
        . "$PSScriptRoot/../Private/Get-LMPortalURI.ps1"
        . "$PSScriptRoot/../Private/New-LMHeader.ps1"
        . "$PSScriptRoot/../Private/Resolve-LMDebugInfo.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMRestMethod.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMPaginatedPostV4.ps1"
        . "$PSScriptRoot/../Private/Invoke-LMCursorPagedGet.ps1"
        . "$PSScriptRoot/../Public/Get-LMNormalizedProperty.ps1"
        . "$PSScriptRoot/../Public/Get-LMDeviceData.ps1"

        function Get-LMDeviceDataSourceList { }
        function Test-LookupResult { }
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
        Mock Test-LookupResult { $false }
    }

    Context 'Get-LMNormalizedProperty' {
        It 'Aggregates multiple v4 pages' {
            Mock Invoke-LMRestMethod {
                param($CallerPSCmdlet, $Uri, $Method, $Headers, $WebSession, $Body)
                $payload = $Body | ConvertFrom-Json
                $offset = [int]$payload.meta.paging.pageOffsetCount

                if ($offset -eq 0) {
                    $firstPage = [PSCustomObject]@{}
                    for ($i = 0; $i -lt 100; $i++) {
                        $firstPage | Add-Member -MemberType NoteProperty -Name ([string]$i) -Value ([PSCustomObject]@{ id = ($i + 1); name = "prop-$($i + 1)" })
                    }
                    return [PSCustomObject]@{
                        data = [PSCustomObject]@{
                            byId = [PSCustomObject]@{
                                normalizedProperties = $firstPage
                            }
                        }
                    }
                }

                if ($offset -eq 100) {
                    return [PSCustomObject]@{
                        data = [PSCustomObject]@{
                            byId = [PSCustomObject]@{
                                normalizedProperties = [PSCustomObject]@{
                                    "0" = [PSCustomObject]@{ id = 101; name = 'prop-101' }
                                }
                            }
                        }
                    }
                }

                return [PSCustomObject]@{ data = [PSCustomObject]@{ byId = [PSCustomObject]@{ normalizedProperties = $null } } }
            }

            $result = Get-LMNormalizedProperty

            ($result | Measure-Object).Count | Should -Be 101
            $result[0].name | Should -Be 'prop-1'
            $result[100].name | Should -Be 'prop-101'
        }
    }

    Context 'Get-LMDeviceData' {
        It 'Aggregates nextPageParams responses into datapoint rows' {
            Mock Invoke-LMRestMethod {
                param($CallerPSCmdlet, $Uri, $Method, $Headers, $WebSession, $Body)

                if ($Uri -like '*cursor=abc*') {
                    return [PSCustomObject]@{
                        values = @(@(12))
                        time = @(2000)
                        dataPoints = @('cpu')
                        nextPageParams = $null
                    }
                }

                return [PSCustomObject]@{
                    values = @(@(11))
                    time = @(1000)
                    dataPoints = @('cpu')
                    nextPageParams = 'cursor=abc'
                }
            }

            Mock Get-LMDeviceDataSourceList {
                @([PSCustomObject]@{ dataSourceId = 2; id = 2 })
            }

            $result = Get-LMDeviceData -DeviceId 1 -DatasourceId 2 -InstanceId 3

            ($result | Measure-Object).Count | Should -Be 2
            $result[0].cpu | Should -Be 11
            $result[1].cpu | Should -Be 12
        }
    }
}
