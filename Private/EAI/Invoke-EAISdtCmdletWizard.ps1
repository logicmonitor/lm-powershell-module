function Invoke-EAISdtCmdletWizard {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    if (-not (Test-EAIAuth)) {
        Write-Error 'Please ensure you are connected to Edwin before running this command. Use Connect-EAIAccount and try again.'
        return $null
    }

    try {
        $result = Get-LMSDTCleanBoundParameters -BoundParameters $BoundParameters

        if (-not $result.ContainsKey('Name') -or [string]::IsNullOrWhiteSpace([string]$result['Name'])) {
            $result['Name'] = Read-LMStringValue -Prompt 'Enter SDT name'
        }

        if (-not $result.ContainsKey('Filter')) {
            $savedFilter = Get-Variable -Name EAIFilter -Scope Global -ErrorAction SilentlyContinue
            if ($savedFilter -and $null -ne $savedFilter.Value) {
                if (Get-LMUserConfirmation -Prompt 'Use the filter saved in `$EAIFilter?' -DefaultAnswer 'y') {
                    $result['Filter'] = $savedFilter.Value
                }
            }

            if (-not $result.ContainsKey('Filter')) {
                $result['Filter'] = Build-EAISdtFilter -PassThru
                if ($null -eq $result['Filter']) {
                    return $null
                }
            }
        }

        $scheduleBound = Get-LMSDTScheduleBoundParameters -BoundParameters $result
        if ($scheduleBound.Count -eq 0) {
            $scheduleSelection = Build-EAISdtSchedule -PassThru
            if ($null -eq $scheduleSelection) {
                return $null
            }
            $result = Merge-LMSDTBoundParameters -Target $result -Source $scheduleSelection
        }

        if (-not $result.ContainsKey('Name') -or [string]::IsNullOrWhiteSpace([string]$result['Name'])) {
            throw 'Name is required.'
        }

        if (-not $result.ContainsKey('Filter')) {
            throw 'Filter is required.'
        }

        if (-not (Confirm-EAISdtWizardSummary -Mode Create -BoundParameters $result)) {
            return $null
        }

        return $result
    }
    catch [LMSDTWizardCancelledException] {
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        return $null
    }
}

function Invoke-EAISdtUpdateWizard {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    if (-not (Test-EAIAuth)) {
        Write-Error 'Please ensure you are connected to Edwin before running this command. Use Connect-EAIAccount and try again.'
        return $null
    }

    try {
        $result = Get-LMSDTCleanBoundParameters -BoundParameters $BoundParameters

        if (-not $result.ContainsKey('Id') -or [string]::IsNullOrWhiteSpace([string]$result['Id'])) {
            do {
                $methods = @(
                    @{ Name = 'Enter schedule ID'; Value = 'Id' }
                    @{ Name = 'Browse schedules'; Value = 'Browse' }
                )
                $method = Get-LMUserSelection -Prompt 'How do you want to select the schedule?' -Choices $methods -ChoiceLabelProperty 'Name'

                switch ($method.Value) {
                    'Id' {
                        do {
                            $scheduleId = Read-LMWizardHost 'Enter schedule ID (q to cancel)'
                            $schedule = Get-EAISdt -Id $scheduleId
                            if ($schedule) {
                                $label = if ([string]::IsNullOrWhiteSpace([string]$schedule.name)) { '(no name)' } else { $schedule.name }
                                Write-Host "Selected schedule: $label (ID: $($schedule.scheduleId))" -ForegroundColor Green
                                $result['Id'] = [string]$schedule.scheduleId
                                break
                            }

                            Write-Host "No schedule found with ID '$scheduleId'." -ForegroundColor Yellow
                        } while (-not $result.ContainsKey('Id'))
                    }
                    'Browse' {
                        $selected = Invoke-LMSDTWizardBrowseSelection `
                            -Browse { Get-EAISdt } `
                            -DisplayProperty 'name' `
                            -IdProperty 'scheduleId' `
                            -ResourceLabel 'SDT schedule' `
                            -FilterProperty 'name'
                        if ($selected) {
                            $label = if ([string]::IsNullOrWhiteSpace([string]$selected.name)) { '(no name)' } else { $selected.name }
                            Write-Host "Selected schedule: $label (ID: $($selected.scheduleId))" -ForegroundColor Green
                            $result['Id'] = [string]$selected.scheduleId
                        }
                    }
                }

                if ($result.ContainsKey('Id') -and -not [string]::IsNullOrWhiteSpace([string]$result['Id'])) {
                    break
                }

                if (-not (Get-LMUserConfirmation -Prompt 'Choose a different selection method?' -DefaultAnswer 'y')) {
                    return $null
                }
            } while ($true)
        }

        if (-not $result.ContainsKey('Name') -and -not $result.ContainsKey('Description') -and -not $result.ContainsKey('Enabled')) {
            if (Get-LMUserConfirmation -Prompt 'Update schedule metadata (name, description, or enabled status)?' -DefaultAnswer 'n') {
                if (Get-LMUserConfirmation -Prompt 'Update the schedule name?' -DefaultAnswer 'n') {
                    $result['Name'] = Read-LMStringValue -Prompt 'Enter updated schedule name'
                }

                if (Get-LMUserConfirmation -Prompt 'Update the schedule description?' -DefaultAnswer 'n') {
                    $result['Description'] = Read-LMStringValue -Prompt 'Enter updated schedule description'
                }

                if (Get-LMUserConfirmation -Prompt 'Change enabled status?' -DefaultAnswer 'n') {
                    $enabledChoice = Get-LMUserSelection -Prompt 'Enable or disable this schedule?' -Choices @(
                        @{ Name = 'Enable'; Value = $true }
                        @{ Name = 'Disable'; Value = $false }
                    ) -ChoiceLabelProperty 'Name'
                    $result['Enabled'] = [bool]$enabledChoice.Value
                }
            }
        }

        if (-not $result.ContainsKey('Filter')) {
            if (Get-LMUserConfirmation -Prompt 'Update the schedule filter?' -DefaultAnswer 'n') {
                $existingFilter = $null
                if ($result.ContainsKey('Id')) {
                    $existingSchedule = Get-EAISdt -Id $result['Id'] -ErrorAction SilentlyContinue
                    if ($existingSchedule) {
                        $existingFilter = $existingSchedule.filter
                    }
                }

                $result['Filter'] = Build-EAISdtFilter -PassThru -ExistingFilter $existingFilter
                if ($null -eq $result['Filter']) {
                    return $null
                }
            }
        }

        $scheduleBound = Get-LMSDTScheduleBoundParameters -BoundParameters $result
        if ($scheduleBound.Count -eq 0) {
            if (Get-LMUserConfirmation -Prompt 'Update the schedule recurrence?' -DefaultAnswer 'n') {
                $scheduleSelection = Build-EAISdtSchedule -PassThru
                if ($null -eq $scheduleSelection) {
                    return $null
                }
                $result = Merge-LMSDTBoundParameters -Target $result -Source $scheduleSelection
            }
        }

        if (-not $result.ContainsKey('Id') -or [string]::IsNullOrWhiteSpace([string]$result['Id'])) {
            throw 'Id is required.'
        }

        if (-not (Confirm-EAISdtWizardSummary -Mode Update -BoundParameters $result)) {
            return $null
        }

        return $result
    }
    catch [LMSDTWizardCancelledException] {
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        return $null
    }
}
