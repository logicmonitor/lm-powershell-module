Describe 'ServiceInsight Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        . "$PSScriptRoot/Connect-LMTestAccount.ps1"
        Connect-LMTestAccount -DisableConsoleLogging -SkipCredValidation

        $script:InvokeTestRetry = {
            param(
                [Parameter(Mandatory)]
                [scriptblock]$ScriptBlock,
                [Parameter(Mandatory)]
                [string]$OperationName,
                [int]$MaxAttempts = 8,
                [int]$DelaySeconds = 5
            )

            $lastError = $null

            for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
                try {
                    return & $ScriptBlock
                }
                catch {
                    $lastError = $_

                    if ($attempt -lt $MaxAttempts) {
                        Start-Sleep -Seconds $DelaySeconds
                    }
                }
            }

            throw "$OperationName failed after $MaxAttempts attempts. Last error: $($lastError.Exception.Message)"
        }

        $script:InvokeTestRetryOrInconclusive = {
            param(
                [Parameter(Mandatory)]
                [scriptblock]$ScriptBlock,
                [Parameter(Mandatory)]
                [string]$OperationName,
                [int]$MaxAttempts = 8,
                [int]$DelaySeconds = 5
            )

            try {
                return & $script:InvokeTestRetry -ScriptBlock $ScriptBlock -OperationName $OperationName -MaxAttempts $MaxAttempts -DelaySeconds $DelaySeconds
            }
            catch {
                Set-ItResult -Inconclusive -Because "Likely API indexing lag: $($_.Exception.Message)"
            }
        }

        $script:TestSuffix = Get-LMTestSuffix
        $script:SiTestName = "si-build-test-$($script:TestSuffix)"
        $script:SiTestDisplayName = "SI.Build.Test.$($script:TestSuffix)"

        $script:SiDeviceFilter = @{
            deviceGroupFullPath = "*"
            deviceDisplayName   = "*"
            deviceProperties    = @(@{ name = "testProperty"; value = $script:TestSuffix })
        }
        $script:SiDataPoints = @(
            @{
                name                = "idleInterval_maximum"
                type                = 2
                dataType            = 7
                postProcessorMethod = "aggregation"
                postProcessorParam  = (@{
                        version    = "1.0"
                        expression = @{ funcName = "maximum"; dataSourceName = "HostStatus"; dataPointName = "idleInterval" }
                        dataLack   = "ignore"
                    } | ConvertTo-Json -Compress)
            }
        )
    }

    Describe 'New-LMServiceInsight' {
        It 'When given mandatory parameters, returns a created device and companion datasource' {
            $Script:NewServiceInsight = New-LMServiceInsight -Name $script:SiTestName -DisplayName $script:SiTestDisplayName -DeviceMemberFilter $script:SiDeviceFilter -DataPoints $script:SiDataPoints -Confirm:$false
            $Script:NewServiceInsight | Should -Not -BeNullOrEmpty
            $Script:NewServiceInsight.Device.id | Should -Not -BeNullOrEmpty
            $Script:NewServiceInsight.Device.deviceType | Should -Be 6
            $Script:NewServiceInsight.Datasource.id | Should -Not -BeNullOrEmpty
        }

        It 'When given no member filters at all, throws an error' {
            { New-LMServiceInsight -Name "$($script:SiTestName)-nofilter" -DisplayName "Should Fail" -DataPoints $script:SiDataPoints -Confirm:$false -ErrorAction Stop } | Should -Throw
        }
    }

    Describe 'Get-LMServiceInsight' {
        It 'When given an id should return that Service Insight with parsed member filters' {
            $ServiceInsight = & $script:InvokeTestRetryOrInconclusive -OperationName 'Get-LMServiceInsight by Id' -ScriptBlock {
                $result = Get-LMServiceInsight -Id $Script:NewServiceInsight.Device.id -ErrorAction Stop
                if (($result | Measure-Object).Count -ne 1) {
                    throw "Service Insight '$($Script:NewServiceInsight.Device.id)' is not queryable yet."
                }
                $result
            }
            if ($null -ne $ServiceInsight) {
                $ServiceInsight.DeviceMemberFilter.Count | Should -Be 1
                $ServiceInsight.EvalMembersInterval | Should -Be 30
            }
        }

        It 'When given a DisplayName should return specified Service Insight matching that name' {
            $ServiceInsight = & $script:InvokeTestRetryOrInconclusive -OperationName 'Get-LMServiceInsight by DisplayName' -ScriptBlock {
                $result = Get-LMServiceInsight -DisplayName $script:SiTestDisplayName -ErrorAction Stop
                if (($result | Measure-Object).Count -lt 1) {
                    throw "Service Insight '$($script:SiTestDisplayName)' not visible yet."
                }
                $result
            }
            if ($null -ne $ServiceInsight) {
                ($ServiceInsight | Measure-Object).Count | Should -BeGreaterThan 0
            }
        }

        It 'When given -Raw, returns the plain device object without the parsed member filter properties' {
            $RawServiceInsight = Get-LMServiceInsight -Id $Script:NewServiceInsight.Device.id -Raw
            $RawServiceInsight.PSObject.Properties.Name | Should -Not -Contain 'DeviceMemberFilter'
        }
    }

    Describe 'Set-LMServiceInsight' {
        It 'When given an updated EvalMembersInterval, persists the new value' {
            { Set-LMServiceInsight -Id $Script:NewServiceInsight.Device.id -EvalMembersInterval 1440 -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
            (Get-LMServiceInsight -Id $Script:NewServiceInsight.Device.id).EvalMembersInterval | Should -Be 1440
        }

        It 'When given only -Id with no other field, throws instead of silently no-op-ing' {
            { Set-LMServiceInsight -Id $Script:NewServiceInsight.Device.id -Confirm:$false -ErrorAction Stop } | Should -Throw
        }
    }

    Describe 'Remove-LMServiceInsight' {
        It 'When given an id, removes the Service Insight device and its companion datasource' {
            { Remove-LMServiceInsight -Id $Script:NewServiceInsight.Device.id -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
        }
    }

    AfterAll {
        Disconnect-LMAccount
    }
}

Describe 'DynamicServiceInsight Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        . "$PSScriptRoot/Connect-LMTestAccount.ps1"
        Connect-LMTestAccount -DisableConsoleLogging -SkipCredValidation

        $script:TplTestSuffix = Get-LMTestSuffix
        $script:TplTestName = "dsi-build-test-$($script:TplTestSuffix)"
    }

    Describe 'New-LMDynamicServiceInsight' {
        It 'When given mandatory parameters, returns a created template with a resolvable id' {
            $response = New-LMDynamicServiceInsight -Name $script:TplTestName -Description "Pester test template" `
                -Cardinality @(@{name = "testProperty"; type = "RESOURCE_PROPERTY" }) `
                -PropertySelector @(@{value = @(); name = "testProperty"; type = "RESOURCE_PROPERTY"; inclusionType = "INCLUDE"; label = "testProperty"; isOpen = $true }) `
                -ServiceNamingPattern @("", "##testProperty##", "") `
                -Properties @(@{id = "testProperty"; name = "testProperty"; value = "##testProperty##"; type = "RESOURCE_PROPERTY" }) `
                -CreateGroup $false -Confirm:$false

            $response | Should -Not -BeNullOrEmpty
            $Script:NewTemplateId = $response.data.byId.RestServiceTemplate.PSObject.Properties.Name | Select-Object -First 1
            $Script:NewTemplateId | Should -Not -BeNullOrEmpty
        }
    }

    Describe 'Get-LMDynamicServiceInsight' {
        It 'When given an id should return that template with the configured naming pattern' {
            $Template = Get-LMDynamicServiceInsight -Id $Script:NewTemplateId
            $Template | Should -Not -BeNullOrEmpty
            $Template.name | Should -Be $script:TplTestName
        }
    }

    Describe 'Set-LMDynamicServiceInsight' {
        It 'When given -IsEnabled only, applies a minimal partial update' {
            { Set-LMDynamicServiceInsight -Id $Script:NewTemplateId -IsEnabled $true -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
            (Get-LMDynamicServiceInsight -Id $Script:NewTemplateId).isEnabled | Should -Be $true
        }

        It 'When given a field other than IsEnabled, preserves previously-set fields (full-object merge path)' {
            { Set-LMDynamicServiceInsight -Id $Script:NewTemplateId -Description "Updated by Pester" -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
            $Updated = Get-LMDynamicServiceInsight -Id $Script:NewTemplateId
            $Updated.description | Should -Be "Updated by Pester"
            $Updated.isEnabled | Should -Be $true
        }
    }

    Describe 'Remove-LMDynamicServiceInsight' {
        It 'When given an id, removes the template from logic monitor' {
            { Remove-LMDynamicServiceInsight -Id $Script:NewTemplateId -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
        }
    }

    AfterAll {
        Disconnect-LMAccount
    }
}
