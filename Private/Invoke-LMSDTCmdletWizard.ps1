function Merge-LMSDTBoundParameters {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$Target,

        [Parameter(Mandatory)]
        [hashtable]$Source
    )

    foreach ($Key in $Source.Keys) {
        $Target[$Key] = $Source[$Key]
    }

    return $Target
}

function Get-LMSDTCleanBoundParameters {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    $Result = @{}
    foreach ($Key in $BoundParameters.Keys) {
        if ($Key -ne 'ScheduleWizard') {
            $Result[$Key] = $BoundParameters[$Key]
        }
    }

    return $Result
}

function Confirm-LMSDTWizardSummary {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Create', 'Update')]
        [String]$Mode,

        [ValidateSet('Device', 'Collector', 'DeviceGroup', 'Website', 'WebsiteGroup', 'DeviceDatasource', 'DeviceDatasourceInstance')]
        [String]$ResourceType,

        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    Write-Host ''
    Write-Host '--- SDT Summary ---' -ForegroundColor Cyan

    if ($Mode -eq 'Create') {
        foreach ($line in (Get-LMSDTWizardTargetSummaryLines -ResourceType $ResourceType -BoundParameters $BoundParameters)) {
            Write-Host $line
        }
    }
    else {
        $sdt = Get-LMSDT -Id $BoundParameters['Id'] -ErrorAction SilentlyContinue
        if ($sdt) {
            $comment = if ([string]::IsNullOrWhiteSpace([string]$sdt.comment)) { '(no comment)' } else { $sdt.comment }
            Write-Host "SDT: $comment (ID: $($sdt.id))"
            if ($sdt.type) {
                Write-Host "SDT type: $($sdt.type)"
            }
        }
        else {
            Write-Host "SDT ID: $($BoundParameters['Id'])"
        }
    }

    if ($BoundParameters.ContainsKey('Comment') -and -not [string]::IsNullOrWhiteSpace([string]$BoundParameters['Comment'])) {
        Write-Host "Comment: $($BoundParameters['Comment'])"
    }

    $previewPayload = Build-LMSDTSchedulePayload -BoundParameters $BoundParameters
    Write-LMSDTSchedulePreview -PreviewPayload $previewPayload
    Write-Host '-------------------'

    if (-not (Get-LMUserConfirmation -Prompt 'Proceed with this SDT?' -DefaultAnswer 'y')) {
        Write-Host 'SDT wizard cancelled.' -ForegroundColor Yellow
        return $false
    }

    return $true
}

function Invoke-LMSDTCmdletWizard {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Device', 'Collector', 'DeviceGroup', 'Website', 'WebsiteGroup', 'DeviceDatasource', 'DeviceDatasourceInstance')]
        [String]$ResourceType,

        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error 'Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.'
        return $null
    }

    try {
        $Result = Get-LMSDTCleanBoundParameters -BoundParameters $BoundParameters

        if (-not (Test-LMSDTResourceComplete -ResourceType $ResourceType -BoundParameters $Result)) {
            $ResourceSelection = Invoke-LMSDTResourceWizard -ResourceType $ResourceType -BoundParameters $Result
            if ($null -eq $ResourceSelection) {
                return $null
            }
            $Result = Merge-LMSDTBoundParameters -Target $Result -Source $ResourceSelection
        }

        if (-not $Result.ContainsKey('Comment') -or [string]::IsNullOrWhiteSpace([string]$Result['Comment'])) {
            $Result['Comment'] = Read-LMStringValue -Prompt 'Enter SDT comment'
        }

        $ScheduleBound = Get-LMSDTScheduleBoundParameters -BoundParameters $Result
        if ($ScheduleBound.Count -eq 0) {
            $ScheduleSelection = Build-LMSDTSchedule -PassThru
            if ($null -eq $ScheduleSelection) {
                return $null
            }
            $Result = Merge-LMSDTBoundParameters -Target $Result -Source $ScheduleSelection
        }

        $Result = Resolve-LMSDTResourceIdentifiers -ResourceType $ResourceType -BoundParameters $Result
        Test-LMSDTResourceIdentifiersValid -ResourceType $ResourceType -BoundParameters $Result | Out-Null

        if (-not $Result.ContainsKey('Comment') -or [string]::IsNullOrWhiteSpace([string]$Result['Comment'])) {
            throw 'Comment is required.'
        }

        if (-not (Confirm-LMSDTWizardSummary -Mode Create -ResourceType $ResourceType -BoundParameters $Result)) {
            return $null
        }

        return $Result
    }
    catch [LMSDTWizardCancelledException] {
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        return $null
    }
}

function Invoke-LMSDTUpdateWizard {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error 'Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.'
        return $null
    }

    try {
        $Result = Get-LMSDTCleanBoundParameters -BoundParameters $BoundParameters

        if (-not $Result.ContainsKey('Id') -or [string]::IsNullOrWhiteSpace([string]$Result['Id'])) {
            do {
                $methods = @(
                    @{ Name = 'Enter SDT ID'; Value = 'Id' }
                    @{ Name = 'Browse SDTs'; Value = 'Browse' }
                )
                $method = Get-LMUserSelection -Prompt 'How do you want to select the SDT?' -Choices $methods -ChoiceLabelProperty 'Name'

                switch ($method.Value) {
                    'Id' {
                        do {
                            $sdtId = Read-LMWizardHost 'Enter SDT ID (q to cancel)'
                            $sdt = Get-LMSDT -Id $sdtId
                            if ($sdt) {
                                $comment = if ([string]::IsNullOrWhiteSpace([string]$sdt.comment)) { '(no comment)' } else { $sdt.comment }
                                Write-Host "Selected SDT: $comment (ID: $($sdt.id))" -ForegroundColor Green
                                $Result['Id'] = [string]$sdt.Id
                                break
                            }

                            Write-Host "No SDT found with ID '$sdtId'." -ForegroundColor Yellow
                        } while (-not $Result.ContainsKey('Id'))
                    }
                    'Browse' {
                        $selected = Invoke-LMSDTWizardBrowseSelection `
                            -Browse { Get-LMSDT -BatchSize 100 } `
                            -DisplayProperty 'comment' `
                            -IdProperty 'id' `
                            -ResourceLabel 'SDT' `
                            -FilterProperty 'comment'
                        if ($selected) {
                            $comment = if ([string]::IsNullOrWhiteSpace([string]$selected.comment)) { '(no comment)' } else { $selected.comment }
                            Write-Host "Selected SDT: $comment (ID: $($selected.Id))" -ForegroundColor Green
                            $Result['Id'] = [string]$selected.Id
                        }
                    }
                }

                if ($Result.ContainsKey('Id') -and -not [string]::IsNullOrWhiteSpace([string]$Result['Id'])) {
                    break
                }

                if (-not (Get-LMUserConfirmation -Prompt 'Choose a different selection method?' -DefaultAnswer 'y')) {
                    return $null
                }
            } while ($true)
        }

        if (-not $Result.ContainsKey('Comment')) {
            if (Get-LMUserConfirmation -Prompt 'Update the SDT comment?' -DefaultAnswer 'n') {
                $Result['Comment'] = Read-LMStringValue -Prompt 'Enter updated SDT comment'
            }
        }

        $ScheduleBound = Get-LMSDTScheduleBoundParameters -BoundParameters $Result
        if ($ScheduleBound.Count -eq 0) {
            $ScheduleSelection = Build-LMSDTSchedule -PassThru
            if ($null -eq $ScheduleSelection) {
                return $null
            }
            $Result = Merge-LMSDTBoundParameters -Target $Result -Source $ScheduleSelection
        }

        if (-not $Result.ContainsKey('Id') -or [string]::IsNullOrWhiteSpace([string]$Result['Id'])) {
            throw 'Id is required.'
        }

        if (-not (Confirm-LMSDTWizardSummary -Mode Update -BoundParameters $Result)) {
            return $null
        }

        return $Result
    }
    catch [LMSDTWizardCancelledException] {
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        return $null
    }
}
