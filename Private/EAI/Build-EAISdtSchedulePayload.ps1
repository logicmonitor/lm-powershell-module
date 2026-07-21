$Script:EAISdtWeekOfMonthMap = @{
    First  = 1
    Second = 2
    Third  = 3
    Fourth = 4
    Last   = -1
}

$Script:EAISdtSdtTypeToFrequencyMap = @{
    Daily         = 'DAILY'
    Weekly        = 'WEEKLY'
    Monthly       = 'MONTHLY'
    MonthlyByWeek = 'MONTHLY'
}

function Format-EAISdtLocalDateTime {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Datetime]$DateTime
    )

    return $DateTime.ToString('yyyy-MM-ddTHH:mm:ss')
}

function ConvertTo-EAISdtIsoDuration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Int]$TotalMinutes
    )

    if ($TotalMinutes -le 0) {
        throw 'Duration must be greater than zero minutes.'
    }

    $hours = [Math]::Floor($TotalMinutes / 60)
    $minutes = $TotalMinutes % 60

    if ($hours -gt 0 -and $minutes -eq 0) {
        return "PT${hours}H"
    }

    if ($hours -gt 0) {
        return "PT${hours}H${minutes}M"
    }

    return "PT${TotalMinutes}M"
}

function ConvertFrom-EAISdtIsoDuration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Duration
    )

    if ([string]::IsNullOrWhiteSpace($Duration)) {
        throw 'Duration value is required.'
    }

    if ($Duration -match '^P(?:(\d+)D)?(?:T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?)?$') {
        $days = if ($Matches[1]) { [int]$Matches[1] } else { 0 }
        $hours = if ($Matches[2]) { [int]$Matches[2] } else { 0 }
        $minutes = if ($Matches[3]) { [int]$Matches[3] } else { 0 }
        $seconds = if ($Matches[4]) { [int]$Matches[4] } else { 0 }
        return ($days * 24 * 60) + ($hours * 60) + $minutes + [Math]::Round($seconds / 60.0)
    }

    throw "Unable to parse ISO-8601 duration '$Duration'."
}

function Get-EAISdtWallClockNow {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Timezone
    )

    $timeZoneInfo = Find-LMTimeZoneInfo -Timezone $Timezone
    return [TimeZoneInfo]::ConvertTime([DateTime]::UtcNow, $timeZoneInfo)
}

function Get-EAISdtImminentStartDateTime {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Timezone,

        [ValidateRange(1, 60)]
        [Int]$BufferMinutes = 2
    )

    $now = Get-EAISdtWallClockNow -Timezone $Timezone
    $buffered = $now.AddMinutes($BufferMinutes)
    return [Datetime]::new(
        $buffered.Year,
        $buffered.Month,
        $buffered.Day,
        $buffered.Hour,
        $buffered.Minute,
        0
    )
}

function Assert-EAISdtFutureStartDateTime {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Timezone,

        [Parameter(Mandatory)]
        [Datetime]$StartDateTime
    )

    $now = Get-EAISdtWallClockNow -Timezone $Timezone
    $start = [Datetime]::SpecifyKind($StartDateTime, [System.DateTimeKind]::Unspecified)

    if ($start -le $now) {
        throw @"
StartDate must be in the future for timezone '$Timezone'.
Edwin requires startTime to be after the current local time ($($now.ToString('yyyy-MM-dd HH:mm:ss'))).
"@
    }

    return $start
}

function Get-EAISdtFutureRecurringStartDateTime {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$ScheduleBound,

        [Parameter(Mandatory)]
        [String]$Timezone
    )

    $startDateTime = Get-EAISdtRecurringStartDateTime -ScheduleBound $ScheduleBound -Timezone $Timezone
    $now = Get-EAISdtWallClockNow -Timezone $Timezone

    while ($startDateTime -le $now) {
        $startDateTime = $startDateTime.AddDays(1)
    }

    return $startDateTime
}

function Resolve-EAISdtTimezone {
    [CmdletBinding()]
    param (
        [AllowNull()]
        [AllowEmptyString()]
        [String]$Timezone
    )

    if (-not [String]::IsNullOrWhiteSpace($Timezone)) {
        Test-LMTimezoneId -Timezone $Timezone | Out-Null
        return (Resolve-LMTimezoneToIANAId -Timezone $Timezone)
    }

    return (Resolve-LMTimezoneToIANAId -Timezone (Get-TimeZone).Id)
}

function Get-EAISdtEnabledApiValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters,

        [ValidateSet('ENABLED', 'DISABLED')]
        [String]$Default = 'ENABLED'
    )

    if ($BoundParameters.ContainsKey('Enabled')) {
        if ($BoundParameters['Enabled']) {
            return 'ENABLED'
        }

        return 'DISABLED'
    }

    return $Default
}

function Test-EAISdtFilterObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Filter
    )

    if ($null -eq $Filter) {
        throw 'Filter is required.'
    }

    foreach ($propertyName in @('schemaName', 'schemaVersion', 'expression')) {
        if ($null -eq $Filter.PSObject.Properties[$propertyName]) {
            throw "Filter is missing required property '$propertyName'."
        }
    }

    if ([string]::IsNullOrWhiteSpace([string]$Filter.schemaName)) {
        throw 'Filter.schemaName must not be blank.'
    }

    if ([string]::IsNullOrWhiteSpace([string]$Filter.schemaVersion)) {
        throw 'Filter.schemaVersion must not be blank.'
    }

    if ($null -eq $Filter.expression) {
        throw 'Filter.expression is required.'
    }

    return $true
}

function ConvertTo-EAISdtFilterObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Filter
    )

    if ($Filter -is [hashtable]) {
        $Filter = [PSCustomObject]$Filter
    }

    Test-EAISdtFilterObject -Filter $Filter | Out-Null
    return $Filter
}

function Read-EAISdtFilterFromFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Filter file not found: $Path"
    }

    try {
        $filter = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        throw "Failed to parse filter JSON from '$Path': $($_.Exception.Message)"
    }

    Test-EAISdtFilterObject -Filter $filter | Out-Null
    return $filter
}

function ConvertTo-EAISdtRecurrencePattern {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$ScheduleBound,

        [Parameter(Mandatory)]
        [ValidateSet('OneTimeDuration', 'OneTimeRange', 'Recurring')]
        [String]$ParameterSetName
    )

    switch ($ParameterSetName) {
        { $_ -in @('OneTimeDuration', 'OneTimeRange') } {
            return @{
                downtimeScheduleType = 'ONE_TIME'
                frequency            = 'DAILY'
            }
        }

        'Recurring' {
            $sdtType = if ($ScheduleBound.ContainsKey('SdtType')) {
                $ScheduleBound['SdtType']
            }
            else {
                'Daily'
            }

            $pattern = @{
                downtimeScheduleType = 'RECURRING'
                frequency            = $Script:EAISdtSdtTypeToFrequencyMap[$sdtType]
            }

            switch ($sdtType) {
                'Weekly' {
                    $pattern.weekDays = @($ScheduleBound['WeekDay'])
                }
                'Monthly' {
                    $pattern.monthDay = $ScheduleBound['DayOfMonth']
                }
                'MonthlyByWeek' {
                    $pattern.weekDays = @($ScheduleBound['WeekDay'])
                    $pattern.weekOfMonth = $Script:EAISdtWeekOfMonthMap[$ScheduleBound['WeekOfMonth']]
                }
            }

            return $pattern
        }
    }

    throw "Unsupported schedule parameter set '$ParameterSetName'."
}

function Get-EAISdtRecurringStartDateTime {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$ScheduleBound,

        [Parameter(Mandatory)]
        [String]$Timezone
    )

    $startHour = $ScheduleBound['StartHour']
    $startMinute = $ScheduleBound['StartMinute']
    $startDate = $ScheduleBound['StartDate']

    if ($startDate) {
        return $startDate.Date.AddHours($startHour).AddMinutes($startMinute)
    }

    $timeZoneInfo = Find-LMTimeZoneInfo -Timezone $Timezone
    $nowInTimezone = [TimeZoneInfo]::ConvertTime([DateTime]::UtcNow, $timeZoneInfo)
    return $nowInTimezone.Date.AddHours($startHour).AddMinutes($startMinute)
}

function Build-EAISdtScheduleFields {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters,

        [switch]$AllowPartial,

        [Object]$ExistingSchedule
    )

    $scheduleBound = Get-LMSDTScheduleBoundParameters -BoundParameters $BoundParameters

    if ($AllowPartial -and $ExistingSchedule -and $scheduleBound.Count -gt 0) {
        $existingBound = ConvertFrom-EAISdtScheduleToBoundParameters -Schedule $ExistingSchedule
        foreach ($key in $existingBound.Keys) {
            if (-not $scheduleBound.ContainsKey($key)) {
                $scheduleBound[$key] = $existingBound[$key]
            }
        }
    }

    if ($scheduleBound.Count -eq 0) {
        if ($AllowPartial) {
            return @{}
        }

        throw 'No schedule parameters were specified.'
    }

    $parameterSetName = Resolve-LMSDTScheduleParameterSetName -BoundParameters $scheduleBound -AllowPartial:$AllowPartial

    if ($parameterSetName -eq 'Partial') {
        return @{}
    }

    if ($parameterSetName -eq 'Recurring' -and -not $scheduleBound.ContainsKey('SdtType')) {
        $scheduleBound['SdtType'] = 'Daily'
    }

    Test-LMSDTScheduleParameters -ParameterSetName $parameterSetName -BoundParameters $scheduleBound | Out-Null

    $timezone = Resolve-EAISdtTimezone -Timezone $scheduleBound['Timezone']
    $result = @{
        timezone = $timezone
    }

    switch ($parameterSetName) {
        'OneTimeDuration' {
            $durationMinutes = $scheduleBound['Duration']

            if ($scheduleBound['StartDate']) {
                $effectiveStart = Assert-EAISdtFutureStartDateTime -Timezone $timezone -StartDateTime $scheduleBound['StartDate']
            }
            else {
                $effectiveStart = Get-EAISdtImminentStartDateTime -Timezone $timezone
            }

            $result.startTime = Format-EAISdtLocalDateTime -DateTime $effectiveStart
            $result.duration = ConvertTo-EAISdtIsoDuration -TotalMinutes $durationMinutes
            $result.recurrencePattern = ConvertTo-EAISdtRecurrencePattern -ScheduleBound $scheduleBound -ParameterSetName $parameterSetName
        }

        'OneTimeRange' {
            $startDate = Assert-EAISdtFutureStartDateTime -Timezone $timezone -StartDateTime $scheduleBound['StartDate']
            $endDate = $scheduleBound['EndDate']
            $durationMinutes = [Int][Math]::Round(($endDate - $startDate).TotalMinutes)

            $result.startTime = Format-EAISdtLocalDateTime -DateTime $startDate
            $result.duration = ConvertTo-EAISdtIsoDuration -TotalMinutes $durationMinutes
            $result.recurrencePattern = ConvertTo-EAISdtRecurrencePattern -ScheduleBound $scheduleBound -ParameterSetName $parameterSetName
        }

        'Recurring' {
            $durationMinutes = Get-LMSDTRecurringDurationMinutes `
                -StartHour $scheduleBound['StartHour'] `
                -StartMinute $scheduleBound['StartMinute'] `
                -EndHour $scheduleBound['EndHour'] `
                -EndMinute $scheduleBound['EndMinute']

            $startDateTime = Get-EAISdtFutureRecurringStartDateTime -ScheduleBound $scheduleBound -Timezone $timezone

            $result.startTime = Format-EAISdtLocalDateTime -DateTime $startDateTime
            $result.duration = ConvertTo-EAISdtIsoDuration -TotalMinutes $durationMinutes
            $result.recurrencePattern = ConvertTo-EAISdtRecurrencePattern -ScheduleBound $scheduleBound -ParameterSetName $parameterSetName
        }
    }

    return $result
}

function ConvertFrom-EAISdtScheduleToBoundParameters {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Schedule
    )

    $result = @{}

    if ($Schedule.timezone) {
        $result.Timezone = $Schedule.timezone
    }

    if ($Schedule.startTime) {
        $startTime = [Datetime]$Schedule.startTime
        $result.StartHour = $startTime.Hour
        $result.StartMinute = $startTime.Minute
    }

    if ($Schedule.duration) {
        $durationMinutes = ConvertFrom-EAISdtIsoDuration -Duration $Schedule.duration
        if ($null -ne $result.StartHour -and $null -ne $result.StartMinute) {
            $startTotalMinutes = ($result.StartHour * 60) + $result.StartMinute
            $endTotalMinutes = $startTotalMinutes + $durationMinutes
            $result.EndHour = [Math]::Floor(($endTotalMinutes % (24 * 60)) / 60)
            $result.EndMinute = $endTotalMinutes % 60
        }
        else {
            $result.Duration = $durationMinutes
            if ($Schedule.startTime) {
                $result.StartDate = [Datetime]$Schedule.startTime
            }
        }
    }

    $pattern = $Schedule.recurrencePattern
    if ($pattern) {
        if ($pattern.downtimeScheduleType -eq 'ONE_TIME') {
            if ($Schedule.startTime) {
                $result.StartDate = [Datetime]$Schedule.startTime
            }
            if ($Schedule.duration) {
                $result.Duration = ConvertFrom-EAISdtIsoDuration -Duration $Schedule.duration
            }
        }
        else {
            switch ($pattern.frequency) {
                'DAILY' { $result.SdtType = 'Daily' }
                'WEEKLY' {
                    $result.SdtType = 'Weekly'
                    if ($pattern.weekDays) {
                        $result.WeekDay = @($pattern.weekDays)
                    }
                }
                'MONTHLY' {
                    if ($pattern.monthDay) {
                        $result.SdtType = 'Monthly'
                        $result.DayOfMonth = $pattern.monthDay
                    }
                    elseif ($pattern.weekOfMonth -and $pattern.weekDays) {
                        $result.SdtType = 'MonthlyByWeek'
                        $result.WeekDay = @($pattern.weekDays)
                        $weekOfMonthEntry = $Script:EAISdtWeekOfMonthMap.GetEnumerator() |
                            Where-Object { $_.Value -eq $pattern.weekOfMonth } |
                            Select-Object -First 1
                        if ($weekOfMonthEntry) {
                            $result.WeekOfMonth = $weekOfMonthEntry.Key
                        }
                    }
                    else {
                        $result.SdtType = 'Monthly'
                    }
                }
            }
        }
    }

    return $result
}

function Build-EAISdtSchedulePayload {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    if (-not $BoundParameters.ContainsKey('Name') -or [string]::IsNullOrWhiteSpace([string]$BoundParameters['Name'])) {
        throw 'Name is required.'
    }

    if (-not $BoundParameters.ContainsKey('Filter')) {
        throw 'Filter is required.'
    }

    $scheduleFields = Build-EAISdtScheduleFields -BoundParameters $BoundParameters

    $payload = @{
        name    = [string]$BoundParameters['Name']
        enabled = Get-EAISdtEnabledApiValue -BoundParameters $BoundParameters
        filter  = ConvertTo-EAISdtFilterObject -Filter $BoundParameters['Filter']
        version = 1
    }

    if ($BoundParameters.ContainsKey('Description') -and -not [string]::IsNullOrWhiteSpace([string]$BoundParameters['Description'])) {
        $payload.description = [string]$BoundParameters['Description']
    }

    foreach ($key in $scheduleFields.Keys) {
        $payload[$key] = $scheduleFields[$key]
    }

    return $payload
}

function Test-EAISdtScheduleSnapshot {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $InputObject
    )

    if ($null -eq $InputObject) {
        return $false
    }

    return $null -ne $InputObject.PSObject.Properties['name'] -and
        $null -ne $InputObject.PSObject.Properties['filter']
}

function ConvertTo-EAISdtScheduleSnapshot {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $ExistingSchedule
    )

    if (-not (Test-EAISdtScheduleSnapshot -InputObject $ExistingSchedule)) {
        throw 'Existing schedule is missing required fields. Retrieve the schedule with Get-EAISdt before updating metadata.'
    }

    $payload = @{
        name    = [string]$ExistingSchedule.name
        enabled = [string]$ExistingSchedule.enabled
        filter  = ConvertTo-EAISdtFilterObject -Filter $ExistingSchedule.filter
    }

    if ($null -ne $ExistingSchedule.PSObject.Properties['description']) {
        $payload.description = [string]$ExistingSchedule.description
    }

    foreach ($key in @('timezone', 'startTime', 'recurrencePattern', 'endTime', 'duration')) {
        if ($null -ne $ExistingSchedule.PSObject.Properties[$key] -and $null -ne $ExistingSchedule.$key) {
            $payload[$key] = $ExistingSchedule.$key
        }
    }

    return $payload
}

function Build-EAISdtMetadataUpdatePayload {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters,

        [Parameter(Mandatory)]
        $ExistingSchedule
    )

    $hasMetadataUpdate = $false
    foreach ($key in @('Name', 'Description', 'Enabled')) {
        if ($BoundParameters.ContainsKey($key)) {
            $hasMetadataUpdate = $true
            break
        }
    }

    if (-not $hasMetadataUpdate) {
        throw 'No metadata fields were specified for update.'
    }

    $payload = ConvertTo-EAISdtScheduleSnapshot -ExistingSchedule $ExistingSchedule

    if ($BoundParameters.ContainsKey('Name') -and -not [string]::IsNullOrWhiteSpace([string]$BoundParameters['Name'])) {
        $payload.name = [string]$BoundParameters['Name']
    }

    if ($BoundParameters.ContainsKey('Description')) {
        $payload.description = [string]$BoundParameters['Description']
    }

    if ($BoundParameters.ContainsKey('Enabled')) {
        $payload.enabled = Get-EAISdtEnabledApiValue -BoundParameters $BoundParameters
    }

    return $payload
}

function Build-EAISdtFilterUpdatePayload {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    if (-not $BoundParameters.ContainsKey('Filter')) {
        throw 'Filter is required for filter updates.'
    }

    return @{
        newFilter = ConvertTo-EAISdtFilterObject -Filter $BoundParameters['Filter']
    }
}

function Build-EAISdtRecurrenceUpdatePayload {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters,

        [Parameter(Mandatory)]
        $ExistingSchedule
    )

    $scheduleFields = Build-EAISdtScheduleFields -BoundParameters $BoundParameters -AllowPartial -ExistingSchedule $ExistingSchedule

    if (-not $scheduleFields.ContainsKey('recurrencePattern')) {
        throw 'No recurrence fields were specified for update.'
    }

    return @{
        newPattern = $scheduleFields.recurrencePattern
    }
}

function Write-EAISdtSchedulePreview {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [hashtable]$PreviewPayload
    )

    if ($PreviewPayload.ContainsKey('timezone')) {
        Write-Host "Timezone: $($PreviewPayload.timezone)"
    }

    if ($PreviewPayload.ContainsKey('startTime')) {
        Write-Host "Start: $($PreviewPayload.startTime)"
    }

    if ($PreviewPayload.ContainsKey('duration')) {
        Write-Host "Duration: $($PreviewPayload.duration)"
    }

    if ($PreviewPayload.ContainsKey('recurrencePattern')) {
        $pattern = $PreviewPayload.recurrencePattern
        Write-Host "Recurrence: $($pattern.downtimeScheduleType) / $($pattern.frequency)"
        if ($pattern.weekDays) {
            Write-Host "WeekDays: $($pattern.weekDays -join ', ')"
        }
        if ($pattern.monthDay) {
            Write-Host "MonthDay: $($pattern.monthDay)"
        }
        if ($pattern.weekOfMonth) {
            Write-Host "WeekOfMonth: $($pattern.weekOfMonth)"
        }
    }
}

function Confirm-EAISdtWizardSummary {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Create', 'Update')]
        [String]$Mode,

        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    Write-Host ''
    Write-Host '--- Edwin SDT Summary ---' -ForegroundColor Cyan

    if ($Mode -eq 'Update') {
        $schedule = Get-EAISdt -Id $BoundParameters['Id'] -ErrorAction SilentlyContinue
        if ($schedule) {
            $label = if ([string]::IsNullOrWhiteSpace([string]$schedule.name)) { '(no name)' } else { $schedule.name }
            Write-Host "Schedule: $label (ID: $($schedule.scheduleId))"
        }
        else {
            Write-Host "Schedule ID: $($BoundParameters['Id'])"
        }
    }

    if ($Mode -eq 'Create' -and $BoundParameters.ContainsKey('Name')) {
        Write-Host "Name: $($BoundParameters['Name'])"
    }

    if ($BoundParameters.ContainsKey('Description') -and -not [string]::IsNullOrWhiteSpace([string]$BoundParameters['Description'])) {
        Write-Host "Description: $($BoundParameters['Description'])"
    }

    if ($BoundParameters.ContainsKey('Filter')) {
        $filter = ConvertTo-EAISdtFilterObject -Filter $BoundParameters['Filter']
        Write-Host "Filter: $($filter.schemaName) v$($filter.schemaVersion)"
    }

    if ($BoundParameters.ContainsKey('Enabled')) {
        Write-Host "Enabled: $(Get-EAISdtEnabledApiValue -BoundParameters $BoundParameters)"
    }

    $scheduleBound = Get-LMSDTScheduleBoundParameters -BoundParameters $BoundParameters
    if ($scheduleBound.Count -gt 0) {
        if ($Mode -eq 'Create') {
            $previewPayload = Build-EAISdtScheduleFields -BoundParameters $BoundParameters
        }
        else {
            $existingSchedule = if ($schedule) { $schedule } else { $null }
            $previewPayload = Build-EAISdtScheduleFields -BoundParameters $BoundParameters -AllowPartial -ExistingSchedule $existingSchedule
        }

        Write-EAISdtSchedulePreview -PreviewPayload $previewPayload
    }

    Write-Host '-------------------------'

    if (-not (Get-LMUserConfirmation -Prompt 'Proceed with this SDT?' -DefaultAnswer 'y')) {
        Write-Host 'SDT wizard cancelled.' -ForegroundColor Yellow
        return $false
    }

    return $true
}
