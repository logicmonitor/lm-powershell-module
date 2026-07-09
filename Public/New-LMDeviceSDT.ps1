<#
.SYNOPSIS
Creates a new Logic Monitor Device Scheduled Down Time (SDT).

.DESCRIPTION
The New-LMDeviceSDT function creates a new SDT for a Logic Monitor device.

.PARAMETER Comment
Specifies the comment for the SDT. Required in the Default parameter set; optional with -ScheduleWizard (prompted when omitted).

.PARAMETER ScheduleWizard
Launches an interactive wizard to create the SDT. Prompts only for values not already supplied, so you can pass resource and comment parameters and receive schedule help only.

.PARAMETER Duration
Duration in minutes for one-time SDTs. Use alone (starts now) or with -StartDate.

.PARAMETER StartDate
Start date and time. Required for OneTimeRange; optional for OneTimeDuration.

.PARAMETER EndDate
End date and time. Required for OneTimeRange.

.PARAMETER Timezone
Specifies the timezone for SDTs. Accepts IANA timezone IDs (e.g. America/New_York), Windows standard names (e.g. Eastern Standard Time), or the output of (Get-TimeZone).StandardName. If omitted, the portal timezone is used.

.PARAMETER SdtType
Recurring schedule type: Daily, Weekly, Monthly, or MonthlyByWeek.

.PARAMETER StartHour
Start hour (0-23) for recurring SDTs.

.PARAMETER StartMinute
Start minute (0-59) for recurring SDTs.

.PARAMETER EndHour
End hour (0-23) for recurring SDTs.

.PARAMETER EndMinute
End minute (0-59) for recurring SDTs.

.PARAMETER WeekDay
Day(s) of the week for Weekly or MonthlyByWeek SDTs. Accepts multiple values.

.PARAMETER WeekOfMonth
Week of the month for MonthlyByWeek SDTs: First, Second, Third, Fourth, or Last.

.PARAMETER DayOfMonth
Day of the month for Monthly SDTs (1-31), or -3 for the last day of the month.

.PARAMETER DeviceId
ID of the device. Provide either -DeviceId or -DeviceName.

.PARAMETER DeviceName
Name of the device. Provide either -DeviceId or -DeviceName.

.EXAMPLE
New-LMDeviceSDT -ScheduleWizard
Launches the full interactive wizard to select a device, comment, and schedule.

.EXAMPLE
New-LMDeviceSDT -ScheduleWizard -Comment "Maintenance" -DeviceId 123
Launches the schedule wizard only; device and comment are pre-supplied.

.EXAMPLE
New-LMDeviceSDT -Comment "Maintenance" -Duration 60 -DeviceId 123
Creates a one-time SDT starting now for 60 minutes.

.EXAMPLE
New-LMDeviceSDT -Comment "Weekly window" -SdtType Weekly -StartHour 13 -StartMinute 7 -EndHour 14 -EndMinute 7 -WeekDay Monday, Thursday -DeviceId 123
Creates a weekly recurring SDT on Monday and Thursday.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.SDT object.
#>
function New-LMDeviceSDT {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None', DefaultParameterSetName = 'Default')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the ScheduleWizard to work')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$Comment,

        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Switch]$ScheduleWizard,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(1, [Int]::MaxValue)]
        [Int]$Duration,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Datetime]$StartDate,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Datetime]$EndDate,

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
        [Int]$StartHour,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 59)]
        [Int]$StartMinute,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 23)]
        [Int]$EndHour,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 59)]
        [Int]$EndMinute,

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
        [Int]$DayOfMonth,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$DeviceId,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$DeviceName
    )

    process {
        if ($ScheduleWizard) {
            $EffectiveBound = Invoke-LMSDTCmdletWizard -ResourceType Device -BoundParameters $PSBoundParameters
            if (-not $EffectiveBound) {
                return
            }
        }
        else {
            if ($DeviceId -and $DeviceName) {
                throw 'Provide either -DeviceId or -DeviceName, not both.'
            }
            if (-not $DeviceId -and -not $DeviceName) {
                throw 'Either -DeviceId or -DeviceName is required.'
            }

            $EffectiveBound = @{}
            foreach ($Key in $PSBoundParameters.Keys) {
                $EffectiveBound[$Key] = $PSBoundParameters[$Key]
            }

            if ($DeviceName) {
                $LookupResult = (Get-LMDevice -Name $DeviceName).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DeviceName) {
                    return
                }
                $EffectiveBound['DeviceId'] = [string]$LookupResult
            }
        }

        $Comment = $EffectiveBound['Comment']
        $DeviceId = $EffectiveBound['DeviceId']
        $SchedulePayload = Build-LMSDTSchedulePayload -BoundParameters $EffectiveBound

        $Payload = @{
            comment  = $Comment
            deviceId = $DeviceId
            type     = 'ResourceSDT'
        }

        foreach ($Key in $SchedulePayload.Keys) {
            $Payload[$Key] = $SchedulePayload[$Key]
        }

        Invoke-LMCreateSDT -CallerPSCmdlet $PSCmdlet -Payload $Payload -ShouldProcessTarget "Comment: $Comment | DeviceId: $DeviceId" -ShouldProcessAction 'Create Device SDT'
    }
}
