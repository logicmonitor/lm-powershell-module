$Script:LMSDTValidWeekDays = @(
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
)

$Script:LMSDTValidWeekOfMonth = @(
    'First', 'Second', 'Third', 'Fourth', 'Last'
)

$Script:LMSDTRecurringSdtTypeMap = @{
    Daily         = 'daily'
    Weekly        = 'weekly'
    Monthly       = 'monthly'
    MonthlyByWeek = 'monthlyByWeek'
}

$Script:LMSDTScheduleParameterNames = @(
    'StartDate', 'EndDate', 'Duration', 'Timezone', 'SdtType',
    'StartHour', 'StartMinute', 'EndHour', 'EndMinute',
    'WeekDay', 'WeekOfMonth', 'DayOfMonth'
)

function ConvertTo-LMSDTScheduleSelection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$Selection
    )

    if (-not $Selection.ContainsKey('ScheduleType')) {
        throw 'Schedule selection requires ScheduleType.'
    }

    $Result = @{}

    switch ($Selection.ScheduleType) {
        'OneTimeDurationOnly' {
            $Result.Duration = $Selection.Duration
        }

        'OneTimeStartDuration' {
            $Result.StartDate = $Selection.StartDate
            $Result.Duration = $Selection.Duration
        }

        'OneTimeRange' {
            $Result.StartDate = $Selection.StartDate
            $Result.EndDate = $Selection.EndDate
        }

        'Daily' {
            $Result.SdtType = 'Daily'
            $Result.StartHour = $Selection.StartHour
            $Result.StartMinute = $Selection.StartMinute
            $Result.EndHour = $Selection.EndHour
            $Result.EndMinute = $Selection.EndMinute
        }

        'Weekly' {
            $Result.SdtType = 'Weekly'
            $Result.StartHour = $Selection.StartHour
            $Result.StartMinute = $Selection.StartMinute
            $Result.EndHour = $Selection.EndHour
            $Result.EndMinute = $Selection.EndMinute
            $Result.WeekDay = @($Selection.WeekDay)
        }

        'Monthly' {
            $Result.SdtType = 'Monthly'
            $Result.StartHour = $Selection.StartHour
            $Result.StartMinute = $Selection.StartMinute
            $Result.EndHour = $Selection.EndHour
            $Result.EndMinute = $Selection.EndMinute
            $Result.DayOfMonth = $Selection.DayOfMonth
        }

        'MonthlyByWeek' {
            $Result.SdtType = 'MonthlyByWeek'
            $Result.StartHour = $Selection.StartHour
            $Result.StartMinute = $Selection.StartMinute
            $Result.EndHour = $Selection.EndHour
            $Result.EndMinute = $Selection.EndMinute
            $Result.WeekDay = @($Selection.WeekDay)
            $Result.WeekOfMonth = $Selection.WeekOfMonth
        }

        default {
            throw "Unsupported schedule type '$($Selection.ScheduleType)'."
        }
    }

    if ($Selection.ContainsKey('Timezone') -and -not [String]::IsNullOrWhiteSpace($Selection.Timezone)) {
        $Result.Timezone = $Selection.Timezone
    }

    return $Result
}

function Get-LMSDTScheduleBoundParameters {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    $ScheduleBound = @{}
    foreach ($Key in $Script:LMSDTScheduleParameterNames) {
        if ($BoundParameters.ContainsKey($Key)) {
            $ScheduleBound[$Key] = $BoundParameters[$Key]
        }
    }

    return $ScheduleBound
}

function Resolve-LMSDTScheduleParameterSetName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters,

        [switch]$AllowPartial
    )

    $ScheduleBound = Get-LMSDTScheduleBoundParameters -BoundParameters $BoundParameters

    if ($ScheduleBound.Count -eq 0) {
        if ($AllowPartial) {
            return 'Partial'
        }

        throw 'No schedule parameters were specified.'
    }

    if ($ScheduleBound.ContainsKey('Duration') -and $ScheduleBound.ContainsKey('EndDate')) {
        throw 'Cannot specify both -Duration and -EndDate. Use -StartDate with -EndDate for a fixed window, or -Duration for a length-based one-time SDT.'
    }

    $HasRecurringMarker = $ScheduleBound.ContainsKey('SdtType') -or
        $ScheduleBound.ContainsKey('WeekDay') -or
        $ScheduleBound.ContainsKey('WeekOfMonth') -or
        $ScheduleBound.ContainsKey('DayOfMonth')

    $RecurringTimeFields = @('StartHour', 'StartMinute', 'EndHour', 'EndMinute')
    $RecurringTimeCount = @($RecurringTimeFields | Where-Object { $ScheduleBound.ContainsKey($_) }).Count
    $HasAnyRecurringTime = $RecurringTimeCount -gt 0
    $HasAllRecurringTime = $RecurringTimeCount -eq $RecurringTimeFields.Count

    if ($HasRecurringMarker -or $HasAnyRecurringTime) {
        if ($ScheduleBound.ContainsKey('Duration') -or ($ScheduleBound.ContainsKey('StartDate') -and $ScheduleBound.ContainsKey('EndDate'))) {
            throw 'Cannot mix recurring schedule parameters with one-time parameters (-Duration or -StartDate/-EndDate).'
        }

        if ($HasAnyRecurringTime -and -not $HasAllRecurringTime) {
            throw 'Recurring schedules require -StartHour, -StartMinute, -EndHour, and -EndMinute.'
        }

        return 'Recurring'
    }

    if ($ScheduleBound.ContainsKey('StartDate') -and $ScheduleBound.ContainsKey('EndDate')) {
        return 'OneTimeRange'
    }

    if ($ScheduleBound.ContainsKey('Duration')) {
        return 'OneTimeDuration'
    }

    if ($AllowPartial) {
        return 'Partial'
    }

    throw @'
Specify a schedule using one of:
  -Duration (optional -StartDate) for a one-time SDT
  -StartDate and -EndDate for a fixed one-time window
  -SdtType Daily|Weekly|Monthly|MonthlyByWeek with -StartHour, -StartMinute, -EndHour, and -EndMinute
'@
}

function Test-LMSDTDayOfMonth {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Int]$DayOfMonth
    )

    if ($DayOfMonth -eq -3) {
        return $true
    }

    if ($DayOfMonth -ge 1 -and $DayOfMonth -le 31) {
        return $true
    }

    throw 'DayOfMonth must be between 1 and 31, or -3 for the last day of the month.'
}

function Test-LMSDTWeekDay {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [String[]]$WeekDay
    )

    if ($null -eq $WeekDay -or $WeekDay.Count -eq 0) {
        throw 'WeekDay requires at least one day (Monday through Sunday).'
    }

    foreach ($Day in $WeekDay) {
        if ($Day -notin $Script:LMSDTValidWeekDays) {
            throw "Invalid WeekDay '$Day'. Valid values: $($Script:LMSDTValidWeekDays -join ', ')."
        }
    }

    return $true
}

function ConvertTo-LMSDTWeekDayApiValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String[]]$WeekDay
    )

    Test-LMSDTWeekDay -WeekDay $WeekDay | Out-Null
    return ($WeekDay -join ',')
}

function Get-LMSDTRecurringDurationMinutes {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Int]$StartHour,

        [Parameter(Mandatory)]
        [Int]$StartMinute,

        [Parameter(Mandatory)]
        [Int]$EndHour,

        [Parameter(Mandatory)]
        [Int]$EndMinute
    )

    $StartTotalMinutes = ($StartHour * 60) + $StartMinute
    $EndTotalMinutes = ($EndHour * 60) + $EndMinute
    $Duration = $EndTotalMinutes - $StartTotalMinutes

    if ($Duration -le 0) {
        $Duration += (24 * 60)
    }

    return $Duration
}

function Test-LMSDTScheduleParameters {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('OneTimeDuration', 'OneTimeRange', 'Recurring', 'Partial')]
        [String]$ParameterSetName,

        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    $StartDate = $BoundParameters['StartDate']
    $EndDate = $BoundParameters['EndDate']
    $Duration = $BoundParameters['Duration']
    $SdtType = $BoundParameters['SdtType']
    $StartHour = $BoundParameters['StartHour']
    $StartMinute = $BoundParameters['StartMinute']
    $EndHour = $BoundParameters['EndHour']
    $EndMinute = $BoundParameters['EndMinute']
    $WeekDay = $BoundParameters['WeekDay']
    $WeekOfMonth = $BoundParameters['WeekOfMonth']
    $DayOfMonth = $BoundParameters['DayOfMonth']

    switch ($ParameterSetName) {
        'OneTimeDuration' {
            if ($null -eq $Duration -or $Duration -le 0) {
                throw 'OneTimeDuration requires a positive -Duration value in minutes.'
            }

            if ($BoundParameters.ContainsKey('EndDate')) {
                throw 'Cannot specify both -Duration and -EndDate. Use -StartDate with -EndDate for a fixed window, or -Duration for a length-based one-time SDT.'
            }
        }

        'OneTimeRange' {
            if ($null -eq $StartDate -or $null -eq $EndDate) {
                throw 'One-time SDTs with a fixed window require both -StartDate and -EndDate.'
            }

            if ($EndDate -le $StartDate) {
                throw 'EndDate must be after StartDate.'
            }

            if ($BoundParameters.ContainsKey('Duration')) {
                throw 'Cannot specify both -Duration and -EndDate. Use -StartDate with -EndDate for a fixed window, or -Duration for a length-based one-time SDT.'
            }
        }

        'Recurring' {
            if ([String]::IsNullOrWhiteSpace($SdtType)) {
                throw 'Recurring SDTs require -SdtType (Daily, Weekly, Monthly, or MonthlyByWeek), or omit -SdtType when providing all four time fields to default to Daily.'
            }

            foreach ($RequiredParam in @('StartHour', 'StartMinute', 'EndHour', 'EndMinute')) {
                if (-not $BoundParameters.ContainsKey($RequiredParam)) {
                    throw "Recurring requires -$RequiredParam."
                }
            }

            switch ($SdtType) {
                'Weekly' {
                    Test-LMSDTWeekDay -WeekDay $WeekDay | Out-Null
                }
                'Monthly' {
                    if (-not $BoundParameters.ContainsKey('DayOfMonth')) {
                        throw 'Monthly recurring SDTs require -DayOfMonth.'
                    }
                    Test-LMSDTDayOfMonth -DayOfMonth $DayOfMonth | Out-Null
                }
                'MonthlyByWeek' {
                    Test-LMSDTWeekDay -WeekDay $WeekDay | Out-Null
                    if ([String]::IsNullOrWhiteSpace($WeekOfMonth)) {
                        throw 'MonthlyByWeek recurring SDTs require -WeekOfMonth.'
                    }
                    if ($WeekOfMonth -notin $Script:LMSDTValidWeekOfMonth) {
                        throw "Invalid WeekOfMonth '$WeekOfMonth'. Valid values: $($Script:LMSDTValidWeekOfMonth -join ', ')."
                    }
                }
            }
        }

        'Partial' {
            if ($BoundParameters.ContainsKey('Duration') -and $BoundParameters.ContainsKey('EndDate')) {
                throw 'Cannot specify both -Duration and -EndDate in the same update.'
            }

            if ($BoundParameters.ContainsKey('DayOfMonth')) {
                Test-LMSDTDayOfMonth -DayOfMonth $DayOfMonth | Out-Null
            }

            if ($BoundParameters.ContainsKey('WeekDay')) {
                Test-LMSDTWeekDay -WeekDay $WeekDay | Out-Null
            }

            if ($BoundParameters.ContainsKey('WeekOfMonth') -and $WeekOfMonth -notin $Script:LMSDTValidWeekOfMonth) {
                throw "Invalid WeekOfMonth '$WeekOfMonth'. Valid values: $($Script:LMSDTValidWeekOfMonth -join ', ')."
            }

            if ($BoundParameters.ContainsKey('SdtType') -and $SdtType -notin $Script:LMSDTRecurringSdtTypeMap.Keys) {
                throw "Invalid SdtType '$SdtType'. Valid values: $($Script:LMSDTRecurringSdtTypeMap.Keys -join ', ')."
            }
        }
    }

    return $true
}

function Build-LMSDTSchedulePayload {
    [CmdletBinding()]
    param (
        [ValidateSet('OneTimeDuration', 'OneTimeRange', 'Recurring', 'Partial')]
        [String]$ParameterSetName,

        [Parameter(Mandatory)]
        [hashtable]$BoundParameters,

        [switch]$AllowPartial
    )

    if ([String]::IsNullOrWhiteSpace($ParameterSetName)) {
        $ParameterSetName = Resolve-LMSDTScheduleParameterSetName -BoundParameters $BoundParameters -AllowPartial:$AllowPartial
    }

    $ScheduleBound = Get-LMSDTScheduleBoundParameters -BoundParameters $BoundParameters

    if ($ParameterSetName -eq 'Recurring' -and -not $ScheduleBound.ContainsKey('SdtType')) {
        $ScheduleBound['SdtType'] = 'Daily'
    }

    Test-LMSDTScheduleParameters -ParameterSetName $ParameterSetName -BoundParameters $ScheduleBound | Out-Null

    $Timezone = $ScheduleBound['Timezone']
    $StartDate = $ScheduleBound['StartDate']
    $EndDate = $ScheduleBound['EndDate']
    $Duration = $ScheduleBound['Duration']
    $SdtType = $ScheduleBound['SdtType']
    $StartHour = $ScheduleBound['StartHour']
    $StartMinute = $ScheduleBound['StartMinute']
    $EndHour = $ScheduleBound['EndHour']
    $EndMinute = $ScheduleBound['EndMinute']
    $WeekDay = $ScheduleBound['WeekDay']
    $WeekOfMonth = $ScheduleBound['WeekOfMonth']
    $DayOfMonth = $ScheduleBound['DayOfMonth']

    $NeedsTimezone = $ParameterSetName -in @('OneTimeDuration', 'OneTimeRange', 'Recurring') -or
        ($ParameterSetName -eq 'Partial' -and (
                $ScheduleBound.ContainsKey('StartDate') -or
                $ScheduleBound.ContainsKey('EndDate') -or
                $ScheduleBound.ContainsKey('Duration')
            ))

    $EffectiveTimezone = $null
    if ($NeedsTimezone) {
        $EffectiveTimezone = Resolve-LMSDTTimezone -Timezone $Timezone
    }
    elseif ($ScheduleBound.ContainsKey('Timezone') -and -not [String]::IsNullOrWhiteSpace($Timezone)) {
        Test-LMTimezoneId -Timezone $Timezone | Out-Null
        $EffectiveTimezone = Resolve-LMTimezoneToIANAId -Timezone $Timezone
    }

    $Data = @{}

    if ($null -ne $EffectiveTimezone -and (
            $ParameterSetName -ne 'Partial' -or $ScheduleBound.ContainsKey('Timezone') -or $NeedsTimezone
        )) {
        $Data['timezone'] = $EffectiveTimezone
    }

    switch ($ParameterSetName) {
        'OneTimeDuration' {
            $EffectiveStartDate = if ($StartDate) { $StartDate } else { Get-Date }
            $EffectiveEndDate = $EffectiveStartDate.AddMinutes($Duration)

            $Data['sdtType'] = 'oneTime'
            $Data['duration'] = $Duration
            $Data['startDateTime'] = ConvertTo-LMSDTEpochMillis -DateTime $EffectiveStartDate -Timezone $EffectiveTimezone
            $Data['endDateTime'] = ConvertTo-LMSDTEpochMillis -DateTime $EffectiveEndDate -Timezone $EffectiveTimezone
        }

        'OneTimeRange' {
            $ComputedDuration = [Int][Math]::Round(($EndDate - $StartDate).TotalMinutes)

            $Data['sdtType'] = 'oneTime'
            $Data['duration'] = $ComputedDuration
            $Data['startDateTime'] = ConvertTo-LMSDTEpochMillis -DateTime $StartDate -Timezone $EffectiveTimezone
            $Data['endDateTime'] = ConvertTo-LMSDTEpochMillis -DateTime $EndDate -Timezone $EffectiveTimezone
        }

        'Recurring' {
            $ApiSdtType = $Script:LMSDTRecurringSdtTypeMap[$SdtType]
            $RecurringDuration = Get-LMSDTRecurringDurationMinutes -StartHour $StartHour -StartMinute $StartMinute -EndHour $EndHour -EndMinute $EndMinute

            $Data['sdtType'] = $ApiSdtType
            $Data['duration'] = $RecurringDuration
            $Data['hour'] = $StartHour
            $Data['minute'] = $StartMinute
            $Data['endHour'] = $EndHour
            $Data['endMinute'] = $EndMinute

            switch ($SdtType) {
                'Weekly' {
                    $Data['weekDay'] = ConvertTo-LMSDTWeekDayApiValue -WeekDay $WeekDay
                }
                'Monthly' {
                    $Data['monthDay'] = $DayOfMonth
                }
                'MonthlyByWeek' {
                    $Data['weekDay'] = ConvertTo-LMSDTWeekDayApiValue -WeekDay $WeekDay
                    $Data['weekOfMonth'] = $WeekOfMonth
                }
            }
        }

        'Partial' {
            if ($ScheduleBound.ContainsKey('SdtType')) {
                $Data['sdtType'] = $Script:LMSDTRecurringSdtTypeMap[$SdtType]
            }

            if ($ScheduleBound.ContainsKey('Duration')) {
                $Data['duration'] = $Duration
            }

            if ($ScheduleBound.ContainsKey('StartHour')) { $Data['hour'] = $StartHour }
            if ($ScheduleBound.ContainsKey('StartMinute')) { $Data['minute'] = $StartMinute }
            if ($ScheduleBound.ContainsKey('EndHour')) { $Data['endHour'] = $EndHour }
            if ($ScheduleBound.ContainsKey('EndMinute')) { $Data['endMinute'] = $EndMinute }

            if ($ScheduleBound.ContainsKey('WeekDay')) {
                $Data['weekDay'] = ConvertTo-LMSDTWeekDayApiValue -WeekDay $WeekDay
            }

            if ($ScheduleBound.ContainsKey('DayOfMonth')) {
                $Data['monthDay'] = $DayOfMonth
            }

            if ($ScheduleBound.ContainsKey('WeekOfMonth')) {
                $Data['weekOfMonth'] = $WeekOfMonth
            }

            if ($ScheduleBound.ContainsKey('StartDate') -or $ScheduleBound.ContainsKey('EndDate') -or $ScheduleBound.ContainsKey('Duration')) {
                if (-not $EffectiveTimezone) {
                    $EffectiveTimezone = Resolve-LMSDTTimezone -Timezone $Timezone
                    $Data['timezone'] = $EffectiveTimezone
                }

                $PartialStartDate = if ($ScheduleBound.ContainsKey('StartDate')) { $StartDate } else { $null }
                $PartialEndDate = if ($ScheduleBound.ContainsKey('EndDate')) { $EndDate } else { $null }

                if ($ScheduleBound.ContainsKey('Duration')) {
                    if ($PartialStartDate) {
                        $PartialEndDate = $PartialStartDate.AddMinutes($Duration)
                    }
                    $Data['duration'] = $Duration
                }

                if ($PartialStartDate) {
                    $Data['startDateTime'] = ConvertTo-LMSDTEpochMillis -DateTime $PartialStartDate -Timezone $EffectiveTimezone
                }

                if ($PartialEndDate) {
                    $Data['endDateTime'] = ConvertTo-LMSDTEpochMillis -DateTime $PartialEndDate -Timezone $EffectiveTimezone
                }

                if ($ScheduleBound.ContainsKey('StartDate') -and $ScheduleBound.ContainsKey('EndDate') -and -not $ScheduleBound.ContainsKey('Duration')) {
                    $Data['duration'] = [Int][Math]::Round(($EndDate - $StartDate).TotalMinutes)
                }
            }

            if ($ScheduleBound.ContainsKey('StartHour') -and
                $ScheduleBound.ContainsKey('StartMinute') -and
                $ScheduleBound.ContainsKey('EndHour') -and
                $ScheduleBound.ContainsKey('EndMinute') -and
                -not $ScheduleBound.ContainsKey('Duration')) {
                $Data['duration'] = Get-LMSDTRecurringDurationMinutes -StartHour $StartHour -StartMinute $StartMinute -EndHour $EndHour -EndMinute $EndMinute
            }
        }
    }

    return $Data
}

function Write-LMSDTSchedulePreview {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [hashtable]$PreviewPayload
    )

    Write-Host "Schedule type: $($PreviewPayload.sdtType)"
    if ($PreviewPayload.ContainsKey('duration')) {
        Write-Host "Duration (minutes): $($PreviewPayload.duration)"
    }
    if ($PreviewPayload.ContainsKey('startDateTime')) {
        Write-Host "Start: $($PreviewPayload.startDateTime)"
    }
    if ($PreviewPayload.ContainsKey('endDateTime')) {
        Write-Host "End: $($PreviewPayload.endDateTime)"
    }
    if ($PreviewPayload.ContainsKey('hour')) {
        Write-Host "Time window: $($PreviewPayload.hour):$($PreviewPayload.minute.ToString('00')) - $($PreviewPayload.endHour):$($PreviewPayload.endMinute.ToString('00'))"
    }
    if ($PreviewPayload.ContainsKey('weekDay')) {
        Write-Host "WeekDay: $($PreviewPayload.weekDay)"
    }
    if ($PreviewPayload.ContainsKey('monthDay')) {
        Write-Host "MonthDay: $($PreviewPayload.monthDay)"
    }
    if ($PreviewPayload.ContainsKey('weekOfMonth')) {
        Write-Host "WeekOfMonth: $($PreviewPayload.weekOfMonth)"
    }
    if ($PreviewPayload.ContainsKey('timezone')) {
        Write-Host "Timezone: $($PreviewPayload.timezone)"
    }
}

function Invoke-LMCreateSDT {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCmdlet]$CallerPSCmdlet,

        [Parameter(Mandatory)]
        [hashtable]$Payload,

        [Parameter(Mandatory)]
        [String]$ShouldProcessTarget,

        [Parameter(Mandatory)]
        [String]$ShouldProcessAction
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error 'Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.'
        return
    }

    $ResourcePath = '/sdt/sdts'
    $RequestBody = Format-LMData -Data $Payload -UserSpecifiedKeys @()

    if ($CallerPSCmdlet.ShouldProcess($ShouldProcessTarget, $ShouldProcessAction)) {
        $Headers = New-LMHeader -Auth $Script:LMAuth -Method 'POST' -ResourcePath $ResourcePath -Data $RequestBody
        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CallerPSCmdlet.MyInvocation -Payload $RequestBody

        return Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method 'POST' -Headers $Headers[0] -WebSession $Headers[1] -Body $RequestBody
    }
}
