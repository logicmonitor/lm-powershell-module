<#
.SYNOPSIS
Creates a new LogicMonitor Device Group Scheduled Downtime.

.DESCRIPTION
The New-LMDeviceGroupSDT function creates a new scheduled downtime for a LogicMonitor device group.

.PARAMETER Comment
Specifies the comment for the scheduled downtime. Required in the Default parameter set; optional with -ScheduleWizard (prompted when omitted).

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

.PARAMETER DeviceGroupId
ID of the device group. Provide either -DeviceGroupId or -DeviceGroupName.

.PARAMETER DeviceGroupName
Name of the device group. Provide either -DeviceGroupId or -DeviceGroupName.

.EXAMPLE
New-LMDeviceGroupSDT -ScheduleWizard
Launches the full interactive wizard to select a device group, comment, and schedule.

.EXAMPLE
New-LMDeviceGroupSDT -ScheduleWizard -Comment "Maintenance" -DeviceGroupId 1
Launches the schedule wizard only; device group and comment are pre-supplied.

.EXAMPLE
New-LMDeviceGroupSDT -Comment "Maintenance" -StartDate "2026-07-02 13:00" -EndDate "2026-07-10 14:00" -DeviceGroupId 1
Creates a one-time SDT with explicit start and end dates.

.EXAMPLE
New-LMDeviceGroupSDT -Comment "Daily window" -SdtType Daily -StartHour 13 -StartMinute 7 -EndHour 14 -EndMinute 7 -DeviceGroupName "Production"
Creates a daily recurring SDT for a device group resolved by name.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.SDT object.
#>
function New-LMDeviceGroupSDT {

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
        [String]$DeviceGroupId,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$DeviceGroupName
    )

    process {
        if ($ScheduleWizard) {
            $EffectiveBound = Invoke-LMSDTCmdletWizard -ResourceType DeviceGroup -BoundParameters $PSBoundParameters
            if (-not $EffectiveBound) {
                return
            }
        }
        else {
            if ($DeviceGroupId -and $DeviceGroupName) {
                throw 'Provide either -DeviceGroupId or -DeviceGroupName, not both.'
            }
            if (-not $DeviceGroupId -and -not $DeviceGroupName) {
                throw 'Either -DeviceGroupId or -DeviceGroupName is required.'
            }

            $EffectiveBound = @{}
            foreach ($Key in $PSBoundParameters.Keys) {
                $EffectiveBound[$Key] = $PSBoundParameters[$Key]
            }

            if ($DeviceGroupName) {
                $LookupResult = (Get-LMDeviceGroup -Name $DeviceGroupName).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DeviceGroupName) {
                    return
                }
                $EffectiveBound['DeviceGroupId'] = [string]$LookupResult
            }
        }

        $Comment = $EffectiveBound['Comment']
        $DeviceGroupId = $EffectiveBound['DeviceGroupId']
        $SchedulePayload = Build-LMSDTSchedulePayload -BoundParameters $EffectiveBound

        $Payload = @{
            comment       = $Comment
            deviceGroupId = $DeviceGroupId
            type          = 'ResourceGroupSDT'
        }

        foreach ($Key in $SchedulePayload.Keys) {
            $Payload[$Key] = $SchedulePayload[$Key]
        }

        Invoke-LMCreateSDT -CallerPSCmdlet $PSCmdlet -Payload $Payload -ShouldProcessTarget "Comment: $Comment | DeviceGroupId: $DeviceGroupId" -ShouldProcessAction 'Create Device Group SDT'
    }
}
