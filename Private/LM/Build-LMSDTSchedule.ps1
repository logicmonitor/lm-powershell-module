function Build-LMSDTSchedule {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for the interactive wizard')]
    param (
        [Switch]$PassThru
    )

    try {
    function Read-RecurringTimeWindow {
        return @{
            StartHour   = Read-LMIntInRange -Prompt 'Start hour (0-23)' -Minimum 0 -Maximum 23
            StartMinute = Read-LMIntInRange -Prompt 'Start minute (0-59)' -Minimum 0 -Maximum 59
            EndHour     = Read-LMIntInRange -Prompt 'End hour (0-23)' -Minimum 0 -Maximum 23
            EndMinute   = Read-LMIntInRange -Prompt 'End minute (0-59)' -Minimum 0 -Maximum 59
        }
    }

    function Read-WeekDaySelection {
        $selectedDays = [System.Collections.Generic.List[string]]::new()
        $availableDays = $Script:LMSDTValidWeekDays

        do {
            Write-Host 'Select weekdays (enter numbers separated by commas, e.g. 1,4):'
            for ($i = 0; $i -lt $availableDays.Count; $i++) {
                Write-Host ("  " + ($i + 1) + ". " + $availableDays[$i])
            }

            $inputValue = Read-LMWizardHost 'Weekday selection (q to cancel)'
            $selectedDays.Clear()
            $isValid = $true

            foreach ($part in ($inputValue -split ',')) {
                $dayNumber = 0
                if (-not [int]::TryParse($part.Trim(), [ref]$dayNumber) -or $dayNumber -lt 1 -or $dayNumber -gt $availableDays.Count) {
                    $isValid = $false
                    break
                }

                $dayName = $availableDays[$dayNumber - 1]
                if ($selectedDays -notcontains $dayName) {
                    $selectedDays.Add($dayName)
                }
            }

            if (-not $isValid -or $selectedDays.Count -eq 0) {
                Write-Host 'Invalid selection. Choose at least one weekday using numbers from the list.' -ForegroundColor Red
            }
        } while (-not $isValid -or $selectedDays.Count -eq 0)

        return @($selectedDays)
    }

    function Read-TimezoneSelection {
        if (Get-LMUserConfirmation -Prompt 'Use portal default timezone?' -DefaultAnswer 'y') {
            return $null
        }

        do {
            $timezone = Read-LMWizardHost 'Enter timezone (IANA or Windows name, e.g. America/New_York; q to cancel)'
            try {
                Test-LMTimezoneId -Timezone $timezone | Out-Null
                return $timezone
            }
            catch {
                Write-Host $_.Exception.Message -ForegroundColor Red
            }
        } while ($true)
    }

    $scheduleTypes = @(
        @{ Name = 'One-time: duration only (starts now)'; Value = 'OneTimeDurationOnly' }
        @{ Name = 'One-time: start + duration'; Value = 'OneTimeStartDuration' }
        @{ Name = 'One-time: fixed start and end'; Value = 'OneTimeRange' }
        @{ Name = 'Daily recurring'; Value = 'Daily' }
        @{ Name = 'Weekly recurring'; Value = 'Weekly' }
        @{ Name = 'Monthly: day of month'; Value = 'Monthly' }
        @{ Name = 'Monthly: by week'; Value = 'MonthlyByWeek' }
    )

    $selectedScheduleType = Get-LMUserSelection -Prompt 'Select SDT schedule type:' -Choices $scheduleTypes -ChoiceLabelProperty 'Name'
    $maxDurationMinutes = [int]::MaxValue

    $selection = @{
        ScheduleType = $selectedScheduleType.Value
    }

    switch ($selectedScheduleType.Value) {
        'OneTimeDurationOnly' {
            $selection.Duration = Read-LMIntInRange -Prompt 'Duration in minutes' -Minimum 1 -Maximum $maxDurationMinutes
        }

        'OneTimeStartDuration' {
            $selection.StartDate = Read-LMDateTimeValue -Prompt 'Start date/time' -Default (Get-Date)
            $selection.Duration = Read-LMIntInRange -Prompt 'Duration in minutes' -Minimum 1 -Maximum $maxDurationMinutes
        }

        'OneTimeRange' {
            $selection.StartDate = Read-LMDateTimeValue -Prompt 'Start date/time' -Default (Get-Date)
            do {
                $selection.EndDate = Read-LMDateTimeValue -Prompt 'End date/time' -Default $selection.StartDate.AddHours(1)
                if ($selection.EndDate -le $selection.StartDate) {
                    Write-Host 'End date/time must be after start date/time.' -ForegroundColor Red
                    $selection.Remove('EndDate')
                }
            } while (-not $selection.ContainsKey('EndDate'))
        }

        'Daily' {
            $selection.SdtType = 'Daily'
            $selection += Read-RecurringTimeWindow
        }

        'Weekly' {
            $selection.SdtType = 'Weekly'
            $selection += Read-RecurringTimeWindow
            $selection.WeekDay = Read-WeekDaySelection
        }

        'Monthly' {
            $selection.SdtType = 'Monthly'
            $selection += Read-RecurringTimeWindow

            $monthDayChoices = @(
                @{ Name = 'Specific day (1-31)'; Value = 'SpecificDay' }
                @{ Name = 'Last day of month'; Value = 'LastDay' }
            )
            $monthDayChoice = Get-LMUserSelection -Prompt 'Select monthly day type:' -Choices $monthDayChoices -ChoiceLabelProperty 'Name'
            if ($monthDayChoice.Value -eq 'LastDay') {
                $selection.DayOfMonth = -3
            }
            else {
                $selection.DayOfMonth = Read-LMIntInRange -Prompt 'Day of month (1-31)' -Minimum 1 -Maximum 31
            }
        }

        'MonthlyByWeek' {
            $selection.SdtType = 'MonthlyByWeek'
            $selection += Read-RecurringTimeWindow
            $selection.WeekDay = Read-WeekDaySelection

            $weekOfMonthChoices = @(
                @{ Name = 'First'; Value = 'First' }
                @{ Name = 'Second'; Value = 'Second' }
                @{ Name = 'Third'; Value = 'Third' }
                @{ Name = 'Fourth'; Value = 'Fourth' }
                @{ Name = 'Last'; Value = 'Last' }
            )
            $weekOfMonthChoice = Get-LMUserSelection -Prompt 'Select week of month:' -Choices $weekOfMonthChoices -ChoiceLabelProperty 'Name'
            $selection.WeekOfMonth = $weekOfMonthChoice.Value
        }
    }

    $timezone = Read-TimezoneSelection
    if ($timezone) {
        $selection.Timezone = $timezone
    }

    $scheduleParameters = ConvertTo-LMSDTScheduleSelection -Selection $selection
    $previewPayload = Build-LMSDTSchedulePayload -BoundParameters $scheduleParameters

    Write-Host ''
    Write-Host '--- SDT Schedule Preview ---' -ForegroundColor Cyan
    Write-LMSDTSchedulePreview -PreviewPayload $previewPayload
    Write-Host '----------------------------'

    if (-not (Get-LMUserConfirmation -Prompt 'Use this schedule?' -DefaultAnswer 'y')) {
        Write-Host 'Schedule wizard cancelled.' -ForegroundColor Yellow
        return $null
    }

    return $scheduleParameters
    }
    catch [LMSDTWizardCancelledException] {
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        return $null
    }
}
