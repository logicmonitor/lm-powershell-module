<#
.SYNOPSIS
Updates a Scheduled Down Time (SDT) entry in LogicMonitor.

.DESCRIPTION
The Set-LMSDT function modifies an existing SDT entry in LogicMonitor, allowing updates to both one-time and recurring schedules.

.PARAMETER Id
Specifies the ID of the SDT entry to modify. Required in the Default parameter set; optional with -ScheduleWizard (prompted when omitted).

.PARAMETER ScheduleWizard
Launches an interactive wizard to update the SDT. Prompts only for values not already supplied, so you can pass the SDT ID and comment and receive schedule help only.

.PARAMETER Comment
Specifies a comment for the SDT entry.

.PARAMETER Duration
Duration in minutes for one-time SDT updates.

.PARAMETER StartDate
Specifies the start date and time for one-time SDT.

.PARAMETER EndDate
Specifies the end date and time for one-time SDT.

.PARAMETER Timezone
Specifies the timezone for SDTs. Accepts IANA timezone IDs (e.g. America/New_York), Windows standard names (e.g. Eastern Standard Time), or the output of (Get-TimeZone).StandardName. For one-time date conversion, if omitted, the portal timezone is used.

.PARAMETER SdtType
Recurring schedule type: Daily, Weekly, Monthly, or MonthlyByWeek.

.PARAMETER StartHour
Specifies the start hour (0-23) for recurring SDT.

.PARAMETER StartMinute
Specifies the start minute (0-59) for recurring SDT.

.PARAMETER EndHour
Specifies the end hour (0-23) for recurring SDT.

.PARAMETER EndMinute
Specifies the end minute (0-59) for recurring SDT.

.PARAMETER WeekDay
Specifies the day(s) of the week for recurring SDT.

.PARAMETER WeekOfMonth
Specifies which week of the month for recurring SDT. Valid values: First, Second, Third, Fourth, Last.

.PARAMETER DayOfMonth
Specifies the day of the month (1-31, or -3 for last day) for recurring SDT.

.EXAMPLE
Set-LMSDT -ScheduleWizard
Launches the full interactive wizard to select an SDT and update its schedule.

.EXAMPLE
Set-LMSDT -ScheduleWizard -Id A_591 -Comment "Extended maintenance"
Launches the schedule wizard only; SDT ID and comment are pre-supplied.

.EXAMPLE
Set-LMSDT -Id 123 -StartDate "2024-01-01 00:00" -EndDate "2024-01-02 00:00" -Comment "Extended maintenance"
Updates a one-time SDT entry with new dates and comment.

.EXAMPLE
Set-LMSDT -Id 123 -SdtType Weekly -StartHour 13 -StartMinute 7 -EndHour 14 -EndMinute 7 -WeekDay Monday, Thursday
Updates a recurring SDT to a weekly schedule on Monday and Thursday.

.INPUTS
None.

.OUTPUTS
Returns the response from the API containing the updated SDT configuration.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMSDT {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None', DefaultParameterSetName = 'Default')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the ScheduleWizard to work')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$Id,

        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Switch]$ScheduleWizard,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$Comment,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(1, [Int]::MaxValue)]
        [Nullable[Int]]$Duration,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Nullable[Datetime]]$StartDate,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Nullable[Datetime]]$EndDate,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateScript({ Test-LMTimezoneId -Timezone $_ })]
        [String]$Timezone,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateSet('Daily', 'Weekly', 'Monthly', 'MonthlyByWeek')]
        [String]$SdtType,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 23)]
        [Nullable[Int]]$StartHour,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 59)]
        [Nullable[Int]]$StartMinute,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 23)]
        [Nullable[Int]]$EndHour,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 59)]
        [Nullable[Int]]$EndMinute,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateSet('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')]
        [String[]]$WeekDay,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateSet('First', 'Second', 'Third', 'Fourth', 'Last')]
        [String]$WeekOfMonth,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Nullable[Int]]$DayOfMonth
    )

    if ($Script:LMAuth.Valid) {
        if ($ScheduleWizard) {
            $EffectiveBound = Invoke-LMSDTUpdateWizard -BoundParameters $PSBoundParameters
            if (-not $EffectiveBound) {
                return
            }
            $Id = $EffectiveBound['Id']
        }
        elseif ([string]::IsNullOrWhiteSpace($Id)) {
            throw 'Id is required.'
        }

        $ResourcePath = "/sdt/sdts/$Id"
        $Message = "Id: $Id"

        $Data = @{}
        if ($ScheduleWizard) {
            if ($EffectiveBound.ContainsKey('Comment')) {
                $Data['comment'] = $EffectiveBound['Comment']
            }
        }
        elseif ($PSBoundParameters.ContainsKey('Comment')) {
            $Data['comment'] = $Comment
        }

        $ScheduleKeys = @(
            'StartDate', 'EndDate', 'Duration', 'Timezone', 'SdtType',
            'StartHour', 'StartMinute', 'EndHour', 'EndMinute',
            'WeekDay', 'WeekOfMonth', 'DayOfMonth'
        )

        $HasScheduleUpdate = $false
        if ($ScheduleWizard) {
            $ScheduleBound = Get-LMSDTScheduleBoundParameters -BoundParameters $EffectiveBound
            $HasScheduleUpdate = $ScheduleBound.Count -gt 0
        }
        else {
            foreach ($Key in $ScheduleKeys) {
                if ($PSBoundParameters.ContainsKey($Key)) {
                    $HasScheduleUpdate = $true
                    break
                }
            }
        }

        if ($HasScheduleUpdate) {
            if ($ScheduleWizard) {
                $SchedulePayload = Build-LMSDTSchedulePayload -BoundParameters $EffectiveBound
            }
            else {
                $SchedulePayload = Build-LMSDTSchedulePayload -BoundParameters $PSBoundParameters -AllowPartial
            }
            foreach ($Key in $SchedulePayload.Keys) {
                $Data[$Key] = $SchedulePayload[$Key]
            }
        }
        elseif ($PSBoundParameters.ContainsKey('Timezone')) {
            $Data['timezone'] = Resolve-LMTimezoneToIANAId -Timezone (Resolve-LMSDTTimezone -Timezone $Timezone)
        }

        $Data = Format-LMData -Data $Data -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys

        if ($PSCmdlet.ShouldProcess($Message, 'Set SDT')) {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method 'PATCH' -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            return Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method 'PATCH' -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
        }
    }
    else {
        Write-Error 'Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.'
    }
}
