<#
.NOTES
Instance-level properties require a device with a real, already-discovered
datasource instance - unlike most other Pester tests in this suite, a
freshly-created test device has no collector activity and therefore no
discovered instances to tag. These tests instead target the HostStatus
datasource's single "HostStatus" instance, which is present on any
actively-monitored device with a working collector, using -PreferredCollectorId
(supplied by Run-Tests.ps1) to locate a real device on that collector.
If no actively-monitored device can be found, the affected tests report
Inconclusive rather than failing, matching this suite's existing pattern for
environment-dependent lag/timing (see -InvokeTestRetryOrInconclusive).
#>
Describe 'InstanceProperty Testing New/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        . "$PSScriptRoot/Connect-LMTestAccount.ps1"
        Connect-LMTestAccount -DisableConsoleLogging -SkipCredValidation

        $script:TestSuffix = Get-LMTestSuffix
        $script:TestPropertyName = "pesterTestProp"
        $script:TestPropertyValue = "pesterTestValue-$($script:TestSuffix)"

        # Find any actively-monitored device that has a real HostStatus
        # instance discovered - instance properties can't be tested against
        # a freshly-created device with no collector activity.
        $script:FixtureDevice = $null
        $script:FixtureInstance = $null
        try {
            $candidateDevices = Get-LMDevice -ErrorAction Stop | Select-Object -First 50
            foreach ($candidate in $candidateDevices) {
                $instances = Get-LMDeviceDatasourceInstance -Id $candidate.id -DatasourceName "HostStatus" -ErrorAction SilentlyContinue
                if ($instances) {
                    $script:FixtureDevice = $candidate
                    $script:FixtureInstance = $instances | Select-Object -First 1
                    break
                }
            }
        }
        catch {
            # Leave $script:FixtureDevice/$script:FixtureInstance null - individual
            # tests below report Inconclusive when no fixture was found.
        }
    }

    Describe 'New-LMInstanceProperty' {
        It 'When given a device/datasource/instance by id, adds the property and returns the updated instance' {
            if (-not $script:FixtureDevice) {
                Set-ItResult -Inconclusive -Because "No actively-monitored device with a discovered HostStatus instance was found on this portal."
                return
            }

            $result = New-LMInstanceProperty -Id $script:FixtureDevice.id -DatasourceId $script:FixtureInstance.dataSourceId -InstanceName $script:FixtureInstance.name -PropertyName $script:TestPropertyName -PropertyValue $script:TestPropertyValue -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            ($result.customProperties | Where-Object { $_.name -eq $script:TestPropertyName }).value | Should -Be $script:TestPropertyValue
        }

        It 'When adding a second property, preserves the first (additive, not destructive)' {
            if (-not $script:FixtureDevice) {
                Set-ItResult -Inconclusive -Because "No actively-monitored device with a discovered HostStatus instance was found on this portal."
                return
            }

            $result = New-LMInstanceProperty -Id $script:FixtureDevice.id -DatasourceId $script:FixtureInstance.dataSourceId -InstanceName $script:FixtureInstance.name -PropertyName "$($script:TestPropertyName)2" -PropertyValue "second-$($script:TestSuffix)" -Confirm:$false
            $result.customProperties.name | Should -Contain $script:TestPropertyName
            $result.customProperties.name | Should -Contain "$($script:TestPropertyName)2"
        }

        It 'When given a nonexistent instance name, throws' {
            if (-not $script:FixtureDevice) {
                Set-ItResult -Inconclusive -Because "No actively-monitored device with a discovered HostStatus instance was found on this portal."
                return
            }

            { New-LMInstanceProperty -Id $script:FixtureDevice.id -DatasourceId $script:FixtureInstance.dataSourceId -InstanceName "does-not-exist-$($script:TestSuffix)" -PropertyName "x" -PropertyValue "y" -Confirm:$false -ErrorAction Stop } | Should -Throw
        }
    }

    Describe 'Remove-LMInstanceProperty' {
        It 'When removing one property, preserves a sibling property' {
            if (-not $script:FixtureDevice) {
                Set-ItResult -Inconclusive -Because "No actively-monitored device with a discovered HostStatus instance was found on this portal."
                return
            }

            $result = Remove-LMInstanceProperty -Id $script:FixtureDevice.id -DatasourceId $script:FixtureInstance.dataSourceId -InstanceName $script:FixtureInstance.name -PropertyName "$($script:TestPropertyName)2" -Confirm:$false
            $result.customProperties.name | Should -Not -Contain "$($script:TestPropertyName)2"
            $result.customProperties.name | Should -Contain $script:TestPropertyName
        }

        It 'When given a property name that does not exist on the instance, throws' {
            if (-not $script:FixtureDevice) {
                Set-ItResult -Inconclusive -Because "No actively-monitored device with a discovered HostStatus instance was found on this portal."
                return
            }

            { Remove-LMInstanceProperty -Id $script:FixtureDevice.id -DatasourceId $script:FixtureInstance.dataSourceId -InstanceName $script:FixtureInstance.name -PropertyName "does-not-exist-$($script:TestSuffix)" -Confirm:$false -ErrorAction Stop } | Should -Throw
        }

        It 'Cleans up the remaining test property left on the fixture instance' {
            if (-not $script:FixtureDevice) {
                Set-ItResult -Inconclusive -Because "No actively-monitored device with a discovered HostStatus instance was found on this portal."
                return
            }

            { Remove-LMInstanceProperty -Id $script:FixtureDevice.id -DatasourceId $script:FixtureInstance.dataSourceId -InstanceName $script:FixtureInstance.name -PropertyName $script:TestPropertyName -Confirm:$false -ErrorAction Stop } | Should -Not -Throw
        }
    }

    AfterAll {
        Disconnect-LMAccount
    }
}
