class LMSDTWizardCancelledException : System.Exception {
    LMSDTWizardCancelledException([string]$Message = 'SDT wizard cancelled.') : base($Message) { }
}

function Stop-LMSDTWizard {
    [CmdletBinding()]
    param (
        [string]$Message = 'SDT wizard cancelled.'
    )

    throw [LMSDTWizardCancelledException]::new($Message)
}

function Test-LMSDTWizardCancelKeyword {
    [CmdletBinding()]
    param (
        [AllowNull()]
        [string]$UserInput
    )

    if ($null -ne $UserInput -and $UserInput.Trim().ToLower() -match '^(q|quit|cancel)$') {
        Stop-LMSDTWizard
    }
}

function Read-LMWizardHost {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [string]$Prompt
    )

    try {
        $inputValue = Read-Host $Prompt
        Test-LMSDTWizardCancelKeyword -UserInput $inputValue
        return $inputValue
    }
    catch [LMSDTWizardCancelledException] {
        throw
    }
    catch [System.Management.Automation.PipelineStoppedException] {
        Stop-LMSDTWizard
    }
    catch [System.OperationCanceledException] {
        Stop-LMSDTWizard
    }
}

function Invoke-LMSDTWizardHandler {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [scriptblock]$ScriptBlock
    )

    try {
        return & $ScriptBlock
    }
    catch [LMSDTWizardCancelledException] {
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        return $null
    }
}

function Get-LMUserSelection {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param(
        [Parameter(Mandatory)]
        [string]$Prompt,
        [Parameter(Mandatory)]
        [array]$Choices,
        [Parameter(Mandatory)]
        [string]$ChoiceLabelProperty
    )

    Write-Host $Prompt
    Write-Host '  0. Cancel'
    for ($i = 0; $i -lt $Choices.Count; $i++) {
        Write-Host ("  " + ($i + 1) + ". " + $Choices[$i].($ChoiceLabelProperty))
    }

    $choiceNumber = -1
    do {
        $choiceInput = Read-LMWizardHost "Enter selection number (0-$($Choices.Count), q to cancel)"
        if ($choiceInput -eq '0') {
            Stop-LMSDTWizard
        }

        if ([int]::TryParse($choiceInput, [ref]$choiceNumber) -and $choiceNumber -ge 1 -and $choiceNumber -le $Choices.Count) {
            continue
        }

        Write-Host "Invalid input. Enter 1-$($Choices.Count), 0, or q to cancel." -ForegroundColor Red
        $choiceNumber = -1
    } while ($choiceNumber -lt 1)

    return $Choices[$choiceNumber - 1]
}

function Get-LMUserConfirmation {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param(
        [Parameter(Mandatory)]
        [string]$Prompt,
        [string]$DefaultAnswer = 'n'
    )

    $answer = ''
    do {
        $choiceInput = Read-LMWizardHost "$Prompt (y/n/q) [$DefaultAnswer]"
        if ([string]::IsNullOrEmpty($choiceInput)) {
            $choiceInput = $DefaultAnswer
        }

        if ($choiceInput.ToLower() -in @('y', 'n')) {
            $answer = $choiceInput.ToLower()
        }
        else {
            Write-Host "Invalid input. Enter 'y', 'n', or 'q' to cancel." -ForegroundColor Red
        }
    } while ([string]::IsNullOrEmpty($answer))

    return ($answer -eq 'y')
}

function Read-LMIntInRange {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param(
        [Parameter(Mandatory)]
        [string]$Prompt,
        [Parameter(Mandatory)]
        [int]$Minimum,
        [Parameter(Mandatory)]
        [int]$Maximum
    )

    $value = $null
    do {
        $inputValue = Read-LMWizardHost "$Prompt (q to cancel)"
        if ([int]::TryParse($inputValue, [ref]$value) -and $value -ge $Minimum -and $value -le $Maximum) {
            return $value
        }

        Write-Host "Invalid input. Enter a number between $Minimum and $Maximum, or q to cancel." -ForegroundColor Red
        $value = $null
    } while ($null -eq $value)
}

function Read-LMDateTimeValue {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param(
        [Parameter(Mandatory)]
        [string]$Prompt,
        [Nullable[Datetime]]$Default
    )

    do {
        $defaultText = if ($Default) { " [$Default]" } else { '' }
        $inputValue = Read-LMWizardHost "$Prompt$defaultText (q to cancel)"
        if ([string]::IsNullOrWhiteSpace($inputValue)) {
            if ($Default) {
                return $Default
            }

            Write-Host "A value is required. Enter a date/time or q to cancel." -ForegroundColor Red
            continue
        }

        try {
            return [Datetime]::Parse($inputValue)
        }
        catch {
            Write-Host "Invalid date/time. Example: $(Get-Date -Format 'yyyy-MM-dd HH:mm')" -ForegroundColor Red
        }
    } while ($true)
}

function Read-LMStringValue {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param(
        [Parameter(Mandatory)]
        [string]$Prompt,
        [switch]$AllowEmpty
    )

    do {
        $inputValue = Read-LMWizardHost "$Prompt (q to cancel)"
        if ($AllowEmpty -or -not [string]::IsNullOrWhiteSpace($inputValue)) {
            return $inputValue
        }

        Write-Host "A value is required. Enter a value or q to cancel." -ForegroundColor Red
    } while ($true)
}
