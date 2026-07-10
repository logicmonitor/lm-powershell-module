<#
.SYNOPSIS
Creates a new device datasource SDT (Scheduled Downtime) in Logic Monitor.

.DESCRIPTION
The New-LMDeviceDatasourceSDT function creates a new device datasource SDT (Scheduled Downtime) in Logic Monitor.

.PARAMETER Comment
The comment for the SDT. Required in the Default parameter set; optional with -ScheduleWizard (prompted when omitted).

.PARAMETER ScheduleWizard
Launches an interactive wizard to create the SDT. Prompts only for values not already supplied, including device and datasource selection when needed.

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

.PARAMETER DeviceDataSourceId
The ID of the device datasource for which to create the SDT.

.EXAMPLE
New-LMDeviceDatasourceSDT -ScheduleWizard
Launches the full interactive wizard to select a device, datasource, comment, and schedule.

.EXAMPLE
New-LMDeviceDatasourceSDT -ScheduleWizard -Comment "Maintenance" -DeviceDataSourceId 123
Launches the schedule wizard only; datasource and comment are pre-supplied.

.EXAMPLE
New-LMDeviceDatasourceSDT -Comment "Maintenance" -Duration 60 -DeviceDataSourceId 123
Creates a one-time SDT starting now for 60 minutes.

.EXAMPLE
New-LMDeviceDatasourceSDT -Comment "Daily maintenance" -SdtType Daily -StartHour 3 -StartMinute 0 -EndHour 4 -EndMinute 0 -DeviceDataSourceId 123
Creates a daily recurring SDT.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.SDT object.
#>
function New-LMDeviceDatasourceSDT {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'ShouldProcess is invoked in Invoke-LMCreateSDT via CallerPSCmdlet')]
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

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$DeviceDataSourceId
    )

    process {
        if ($ScheduleWizard) {
            $EffectiveBound = Invoke-LMSDTCmdletWizard -ResourceType DeviceDatasource -BoundParameters $PSBoundParameters
            if (-not $EffectiveBound) {
                return
            }
        }
        else {
            if ([string]::IsNullOrWhiteSpace($DeviceDataSourceId)) {
                throw 'DeviceDataSourceId is required.'
            }

            $EffectiveBound = @{}
            foreach ($Key in $PSBoundParameters.Keys) {
                $EffectiveBound[$Key] = $PSBoundParameters[$Key]
            }
        }

        $Comment = $EffectiveBound['Comment']
        $DeviceDataSourceId = $EffectiveBound['DeviceDataSourceId']
        $SchedulePayload = Build-LMSDTSchedulePayload -BoundParameters $EffectiveBound

        $Payload = @{
            comment            = $Comment
            deviceDataSourceId = $DeviceDataSourceId
            type               = 'DeviceDataSourceSDT'
        }

        foreach ($Key in $SchedulePayload.Keys) {
            $Payload[$Key] = $SchedulePayload[$Key]
        }

        Invoke-LMCreateSDT -CallerPSCmdlet $PSCmdlet -Payload $Payload -ShouldProcessTarget "Comment: $Comment | DeviceDataSourceId: $DeviceDataSourceId" -ShouldProcessAction 'Create Device Datasource SDT'
    }
}
