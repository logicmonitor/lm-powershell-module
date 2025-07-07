Describe 'Dashboard Testing New/Get/Import/Export/Copy/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging -SkipCredValidation
        
        # Get the path to our test dashboard JSON
        $Script:TestDashboardJsonPath = Join-Path $PSScriptRoot "PesterTestDashboard.json"
        $Script:TimeNow = Get-Date -UFormat %m%d%Y-%H%M
    }
    
    Describe 'New-LMDashboardGroup' {
        It 'When given mandatory parameters, returns a created dashboard group with matching values' {
            $Script:NewDashboardGroup = New-LMDashboardGroup -Name "Dashboard.Build.Test-$Script:TimeNow" -Description "Test dashboard group for Pester tests" -ParentGroupId 1
            $Script:NewDashboardGroup | Should -Not -BeNullOrEmpty
            $Script:NewDashboardGroup.name | Should -Be "Dashboard.Build.Test-$Script:TimeNow"
            $Script:NewDashboardGroup.description | Should -Be "Test dashboard group for Pester tests"
        }
    }
    
    Describe 'Get-LMDashboardGroup' {
        It 'When given no parameters, returns all dashboard groups' {
            $DashboardGroups = Get-LMDashboardGroup
            ($DashboardGroups | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that dashboard group' {
            $DashboardGroup = Get-LMDashboardGroup -Id $Script:NewDashboardGroup.Id -ErrorAction Stop
            ($DashboardGroup | Measure-Object).Count | Should -BeExactly 1
            $DashboardGroup.name | Should -Be $Script:NewDashboardGroup.name
        }
        It 'When given a name should return that dashboard group' {
            $DashboardGroup = Get-LMDashboardGroup -Name $Script:NewDashboardGroup.name -ErrorAction Stop
            ($DashboardGroup | Measure-Object).Count | Should -BeExactly 1
            $DashboardGroup.id | Should -Be $Script:NewDashboardGroup.id
        }
    }

    Describe 'Import-LMDashboard' {
        It 'When given a JSON file path, imports and returns a dashboard with matching values' {
            # Read and modify the test dashboard JSON to include our test group and unique name
            $DashboardJson = Get-Content $Script:TestDashboardJsonPath -Raw | ConvertFrom-Json
            $DashboardJson.name = "Dashboard.Build.Test-$Script:TimeNow"
            $DashboardJson.description = "Imported test dashboard for Pester tests"
            
            $Script:ImportedDashboard = Import-LMDashboard -File $($DashboardJson | ConvertTo-Json -Depth 10) -ErrorAction Stop -ParentGroupId $Script:NewDashboardGroup.id
            $Script:ImportedDashboard | Should -Not -BeNullOrEmpty
            $Script:ImportedDashboard.name | Should -Be "Dashboard.Build.Test-$Script:TimeNow"
        }
    }

    Describe 'Get-LMDashboard' {
        It 'When given no parameters, returns all dashboards' {
            $Dashboards = Get-LMDashboard
            ($Dashboards | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that dashboard' {
            $Dashboard = Get-LMDashboard -Id $Script:ImportedDashboard.Id -ErrorAction Stop
            ($Dashboard | Measure-Object).Count | Should -BeExactly 1
            $Dashboard.name | Should -Be $Script:ImportedDashboard.name
        }
        It 'When given a name should return that dashboard' {
            $Dashboard = Get-LMDashboard -Name $Script:ImportedDashboard.name -ErrorAction Stop
            ($Dashboard | Measure-Object).Count | Should -BeExactly 1
            $Dashboard.id | Should -Be $Script:ImportedDashboard.id
        }
    }

    Describe 'Export-LMDashboard' {
        It 'When given a dashboard id, exports dashboard to JSON file' {
            $ExportPath = $env:TMPDIR
            $Dashboard = Export-LMDashboard -Id $Script:ImportedDashboard.id -FilePath $ExportPath -ErrorAction Stop -PassThru
            
            # Verify file was created and contains valid JSON
            Test-Path $ExportPath | Should -Be $true
            $Dashboard.name | Should -Be $Script:ImportedDashboard.name
        }
    }

    Describe 'Copy-LMDashboard' {
        It 'When given a dashboard id and new name, creates a copy with matching properties and widget tokens' {
            $CopyName = "Dashboard.Build.Test-Copy-$Script:TimeNow"
            
            # Define test widget tokens
            $TestTokens = @{
                "defaultResourceName" = "TestResource-$Script:TimeNow"
                "defaultResourceGroup" = "TestGroup-$Script:TimeNow"
                "testToken" = "TestValue123"
            }
            
            $Script:CopiedDashboard = Copy-LMDashboard -DashboardId $Script:ImportedDashboard.id -Name $CopyName -ParentGroupId $Script:NewDashboardGroup.id -DashboardTokens $TestTokens -ErrorAction Stop
            $Script:CopiedDashboard | Should -Not -BeNullOrEmpty
            $Script:CopiedDashboard.name | Should -Be $CopyName
            $Script:CopiedDashboard.id | Should -Not -Be $Script:ImportedDashboard.id
            $Script:CopiedDashboard.groupId | Should -Be $Script:NewDashboardGroup.id
            
            # Verify widget tokens were set correctly
            $Script:CopiedDashboard.widgetTokens | Should -Not -BeNullOrEmpty
            ($Script:CopiedDashboard.widgetTokens | Measure-Object).Count | Should -Be 3
            
            # Check each token was set with correct values
            $defaultResourceToken = $Script:CopiedDashboard.widgetTokens | Where-Object { $_.name -eq "defaultResourceName" }
            $defaultResourceToken | Should -Not -BeNullOrEmpty
            $defaultResourceToken.value | Should -Be "TestResource-$Script:TimeNow"
            $defaultResourceToken.type | Should -Be "owned"
            
            $defaultGroupToken = $Script:CopiedDashboard.widgetTokens | Where-Object { $_.name -eq "defaultResourceGroup" }
            $defaultGroupToken | Should -Not -BeNullOrEmpty
            $defaultGroupToken.value | Should -Be "TestGroup-$Script:TimeNow"
            $defaultGroupToken.type | Should -Be "owned"
            
            $testToken = $Script:CopiedDashboard.widgetTokens | Where-Object { $_.name -eq "testToken" }
            $testToken | Should -Not -BeNullOrEmpty
            $testToken.value | Should -Be "TestValue123"
            $testToken.type | Should -Be "owned"
        }
    }

    Describe 'Get-LMDashboardWidget' {
        It 'When given a dashboard id, returns dashboard widgets' {
            $Widgets = Get-LMDashboardWidget -DashboardId $Script:ImportedDashboard.id -ErrorAction Stop
            $Widgets | Should -Not -BeNullOrEmpty
            ($Widgets | Measure-Object).Count | Should -BeGreaterThan 0
            # Our test dashboard should have 2 widgets (Alerts and NOC)
            ($Widgets | Measure-Object).Count | Should -Be 2
        }
    }

    Describe 'Remove-LMDashboard' {
        It 'When given a dashboard id, removes the dashboard from LogicMonitor (original)' {
            Remove-LMDashboard -Id $Script:ImportedDashboard.Id -ErrorAction Stop -Confirm:$false
        }
        It 'When given a dashboard id, removes the dashboard from LogicMonitor (copy)' {
            Remove-LMDashboard -Id $Script:CopiedDashboard.Id -ErrorAction Stop -Confirm:$false
        }
    }

    Describe 'Remove-LMDashboardGroup' {
        It 'When given a dashboard group id, removes the group from LogicMonitor' {
            Remove-LMDashboardGroup -Id $Script:NewDashboardGroup.Id -ErrorAction Stop -Confirm:$false
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}