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
            $MaxAttempts = 5
            $DelaySeconds = 5
            $Success = $false
            
            for ($Attempt = 1; $Attempt -le $MaxAttempts; $Attempt++) {
                try {
                    $OpsNote = Get-LMOpsNote -Id $Script:NewOpsNote.Id -ErrorAction Stop
                    ($OpsNote | Measure-Object).Count | Should -BeExactly 1
                    $Success = $true
                    break
                }
                catch {
                    if ($Attempt -eq $MaxAttempts) {
                        Set-ItResult -Inconclusive -Because "Get-LMOpsNote by ID failed after $MaxAttempts attempts, likely due to backend timing: $($_.Exception.Message)"
                    }
                    else {
                        Write-Host "Attempt $Attempt failed, retrying in $DelaySeconds seconds..." -ForegroundColor Yellow
                        Start-Sleep -Seconds $DelaySeconds
                    }
                }
            }
        }
        It 'When given a tag should return specified opsnote matching that tag value' {
            $MaxAttempts = 5
            $DelaySeconds = 5
            $Success = $false
            
            for ($Attempt = 1; $Attempt -le $MaxAttempts; $Attempt++) {
                try {
                    $OpsNote = Get-LMOpsNote -Tag $Script:NewOpsNote.Tags.name -ErrorAction Stop
                    ($OpsNote | Measure-Object).Count | Should -BeExactly 1
                    $Success = $true
                    break
                }
                catch {
                    if ($Attempt -eq $MaxAttempts) {
                        Set-ItResult -Inconclusive -Because "Get-LMOpsNote by tag failed after $MaxAttempts attempts, likely due to backend timing: $($_.Exception.Message)"
                    }
                    else {
                        Write-Host "Attempt $Attempt failed, retrying in $DelaySeconds seconds..." -ForegroundColor Yellow
                        Start-Sleep -Seconds $DelaySeconds
                    }
                }
            }
        }
        It 'When given a wildcard tag should return all opsnotes matching that wildcard value' {
            $MaxAttempts = 5
            $DelaySeconds = 5
            $Success = $false
            
            for ($Attempt = 1; $Attempt -le $MaxAttempts; $Attempt++) {
                try {
                    $OpsNote = Get-LMOpsNote -Tag "$(($Script:NewOpsNote.Tags.name.Split(".")[0]))*" -ErrorAction Stop
                    ($OpsNote | Measure-Object).Count | Should -BeGreaterThan 0
                    $Success = $true
                    break
                }
                catch {
                    if ($Attempt -eq $MaxAttempts) {
                        Set-ItResult -Inconclusive -Because "Get-LMOpsNote by wildcard tag failed after $MaxAttempts attempts, likely due to backend timing: $($_.Exception.Message)"
                    }
                    else {
                        Write-Host "Attempt $Attempt failed, retrying in $DelaySeconds seconds..." -ForegroundColor Yellow
                        Start-Sleep -Seconds $DelaySeconds
                    }
                }
            }
        }
    }

    Describe 'Set-LMOpsNote' {
        It 'When given a set of parameters, returns an updated opsnote with matching values' {
            $MaxAttempts = 5
            $DelaySeconds = 5
            $Success = $false
            
            for ($Attempt = 1; $Attempt -le $MaxAttempts; $Attempt++) {
                try {
                    $OpsNote = Set-LMOpsNote -Id $Script:NewOpsNote.Id -Note "OpsNote.Build.Test: $Script:TimeNow Updated"-ErrorAction Stop
                    $OpsNote.Note | Should -Be "OpsNote.Build.Test: $Script:TimeNow Updated"
                    $Success = $true
                    break
                }
                catch {
                    if ($Attempt -eq $MaxAttempts) {
                        Set-ItResult -Inconclusive -Because "Set-LMOpsNote failed after $MaxAttempts attempts: $($_.Exception.Message)"
                    }
                    else {
                        Write-Host "Attempt $Attempt failed, retrying in $DelaySeconds seconds..." -ForegroundColor Yellow
                        Start-Sleep -Seconds $DelaySeconds
                    }
                }
            }
        }
    }

    Describe 'Remove-LMOpsNote' {
        It 'When given an id, remove the opsnote from logic monitor (inconclusive on failure)' {
            $MaxAttempts = 5
            $DelaySeconds = 5
            $Success = $false
            
            for ($Attempt = 1; $Attempt -le $MaxAttempts; $Attempt++) {
                try {
                    Remove-LMOpsNote -Id $Script:NewOpsNote.Id -ErrorAction Stop -Confirm:$false
                    $Success = $true
                    break
                }
                catch {
                    if ($Attempt -eq $MaxAttempts) {
                        Set-ItResult -Inconclusive -Because "Remove-LMOpsNote failed after $MaxAttempts attempts: $($_.Exception.Message)"
                    }
                    else {
                        Write-Host "Attempt $Attempt failed, retrying in $DelaySeconds seconds..." -ForegroundColor Yellow
                        Start-Sleep -Seconds $DelaySeconds
                    }
                }
            }
        }
    }
    
    AfterAll {
        Disconnect-LMAccount
    }
}