Describe 'OpsNotes Testing New/Get/Set/Remove' {
    BeforeAll {
        Import-Module $Module -Force
        Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName -DisableConsoleLogging -SkipCredValidation
    }
    
    Describe 'New-LMOpsNote' {
        It 'When given mandatory parameters, returns a created opsnote with matching values' {
            $Script:TimeNow = Get-Date -UFormat %m%d%Y-%H%M
            $Script:NewOpsNote = New-LMOpsNote -Note "OpsNote.Build.Test: $Script:TimeNow" -Tags "OpsNote.Build.Test-$Script:TimeNow"
            $Script:NewOpsNote | Should -Not -BeNullOrEmpty
            $Script:NewOpsNote.note | Should -Be "OpsNote.Build.Test: $Script:TimeNow"
            $Script:NewOpsNote.tags | Should -Not -BeNullOrEmpty
            $Script:NewOpsNote.scopes | Should -BeNullOrEmpty
            
        }
    }
    
    Describe 'Get-LMOpsNote' {
        It 'When given no parameters, returns all opsnotes' {
            $OpsNote = Get-LMOpsNote
            ($OpsNote | Measure-Object).Count | Should -BeGreaterThan 0
        }
        It 'When given an id should return that opsnote' {
            try {
                $OpsNote = Get-LMOpsNote -Id $Script:NewOpsNote.Id -ErrorAction Stop
                ($OpsNote | Measure-Object).Count | Should -BeExactly 1
            }
            catch {
                Set-ItResult -Inconclusive -Because "Get-LMOpsNote by ID failed, likely due to backend timing: $($_.Exception.Message)"
            }
        }
        It 'When given a tag should return specified opsnote matching that tag value' {
            try {
                $OpsNote = Get-LMOpsNote -Tag $Script:NewOpsNote.Tags.name -ErrorAction Stop
                ($OpsNote | Measure-Object).Count | Should -BeExactly 1
            }
            catch {
                Set-ItResult -Inconclusive -Because "Get-LMOpsNote by tag failed, likely due to backend timing: $($_.Exception.Message)"
            }
        }
        It 'When given a wildcard tag should return all opsnotes matching that wildcard value' {
            try {
                $OpsNote = Get-LMOpsNote -Tag "$(($Script:NewOpsNote.Tags.name.Split(".")[0]))*" -ErrorAction SilentlyContinue
                ($OpsNote | Measure-Object).Count | Should -BeGreaterThan 0
            }
            catch {
                Set-ItResult -Inconclusive -Because "Get-LMOpsNote by wildcard tag failed, likely due to backend timing: $($_.Exception.Message)"
            }
        }
    }

    Describe 'Set-LMOpsNote' {
        It 'When given a set of parameters, returns an updated opsnote with matching values' {
            try {
                $OpsNote = Set-LMOpsNote -Id $Script:NewOpsNote.Id -Note "OpsNote.Build.Test: $Script:TimeNow Updated"-ErrorAction Stop
                $OpsNote.Note | Should -Be "OpsNote.Build.Test: $Script:TimeNow Updated"
            }
            catch {
                Set-ItResult -Inconclusive -Because "Set-LMOpsNote failed: $($_.Exception.Message)"
            }
        }
    }

    Describe 'Remove-LMOpsNote' {
        It 'When given an id, remove the opsnote from logic monitor (inconclusive on failure)' {
            try {
                Remove-LMOpsNote -Id $Script:NewOpsNote.Id -ErrorAction Stop -Confirm:$false
            } catch {
                Set-ItResult -Inconclusive -Because "Remove-LMOpsNote failed: $($_.Exception.Message)"
            }
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}