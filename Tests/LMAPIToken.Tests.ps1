Describe 'Get-LMAPIToken' {
    BeforeAll {
        . "$PSScriptRoot/../Private/Shared/Add-ObjectTypeInfo.ps1"
        . "$PSScriptRoot/../Private/LM/Get-LMPortalURI.ps1"
        . "$PSScriptRoot/../Private/LM/New-LMHeader.ps1"
        . "$PSScriptRoot/../Private/LM/Resolve-LMDebugInfo.ps1"
        . "$PSScriptRoot/../Private/LM/Invoke-LMRestMethod.ps1"
        . "$PSScriptRoot/../Private/LM/Test-LMResponseHasPagination.ps1"
        . "$PSScriptRoot/../Private/LM/Invoke-LMPaginatedGet.ps1"
        . "$PSScriptRoot/../Public/LM/Get-LMAPIToken.ps1"
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
        Mock Invoke-LMRestMethod {
            param($Uri)

            if ($Uri -match '[?&]type=bearer(?:&|$)') {
                return [PSCustomObject]@{
                    items = @([PSCustomObject]@{ id = 2; type = 'Bearer' })
                }
            }

            return [PSCustomObject]@{
                items = @([PSCustomObject]@{ id = 1; type = 'LMv1' })
            }
        }
    }

    It 'queries and combines LMv1 and bearer tokens when Type is wildcard' {
        $result = Get-LMAPIToken -Type '*'

        ($result | Measure-Object).Count | Should -Be 2
        $result.id | Should -Be @(1, 2)
        Assert-MockCalled Invoke-LMRestMethod -Times 1 -Exactly -ParameterFilter {
            $Uri -notmatch '[?&]type='
        }
        Assert-MockCalled Invoke-LMRestMethod -Times 1 -Exactly -ParameterFilter {
            $Uri -match '[?&]type=bearer(?:&|$)'
        }
    }
}
